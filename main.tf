data "azurerm_client_config" "self" {}

resource "azurerm_container_registry" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group.name
  location                = var.resource_group.location
  zone_redundancy_enabled = true
  sku                     = var.sku

  public_network_access_enabled = var.public_network_access_enabled

  admin_enabled = var.admin_enabled

  trust_policy {
    enabled = var.trust_policy_enabled
  }
  retention_policy {
    enabled = true
    days    = var.retention_duration
  }

  # On this field, the provider source code differs from standard dynamic blocks.
  # More information here: https://discuss.hashicorp.com/t/using-dynamic-inside-blocks-in-a-resource/8542/3
  network_rule_set {
    default_action = var.network_default_action

    virtual_network = [
      for subnet_id in var.virtual_network : {
        action    = "Allow"
        subnet_id = subnet_id
      }
    ]

    ip_rule = [
      for ip_range in var.ip_addresses : {
        action   = "Allow"
        ip_range = ip_range
      }
    ]
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = concat(var.identity_ids, [var.encryption_identity != null ? var.encryption_identity.id : azurerm_user_assigned_identity.this[0].id])
  }

  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                  = georeplications.key
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      tags                      = georeplications.value.tags
    }
  }

  # Encryption should be enabled by default.
  encryption {
    enabled            = true
    key_vault_key_id   = var.encryption_key_vault_key_id
    identity_client_id = var.encryption_identity != null ? var.encryption_identity.client_id : azurerm_user_assigned_identity.this[0].client_id
  }

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.this,
    azurerm_key_vault_access_policy.this
  ]
}

resource "azurerm_user_assigned_identity" "this" {
  count = var.encryption_identity != null ? 0 : 1

  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  name                = "acr-${var.name}-identity"
}

resource "azurerm_key_vault_access_policy" "this" {
  count = (var.encryption_identity != null && var.keyvault_iam_authorization == true) ? 0 : 1

  key_vault_id = var.encryption_key_vault_id
  tenant_id    = coalesce(var.encryption_tenant_id, data.azurerm_client_config.self.tenant_id)
  object_id    = azurerm_user_assigned_identity.this[0].principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]

  depends_on = [
    azurerm_user_assigned_identity.this
  ]
}

resource "azurerm_role_assignment" "this" {
  count                = (var.encryption_identity != null && var.keyvault_iam_authorization == false) ? 0 : 1
  scope                = var.encryption_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.this[0].principal_id

  depends_on = [
    azurerm_user_assigned_identity.this
  ]
}
