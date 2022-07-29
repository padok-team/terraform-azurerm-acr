data "azurerm_client_config" "self" {}

resource "azurerm_container_registry" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  zone_redundancy_enabled = true
  sku                     = var.sku

  public_network_access_enabled = var.public_network_access_enabled

  admin_enabled = var.admin_enabled

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
    identity_ids = concat(var.identity_ids, [var.encryption_identity_name != null ? data.azurerm_user_assigned_identity.this[0].id : azurerm_user_assigned_identity.this[0].id])
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
    identity_client_id = var.encryption_identity_name != null ? data.azurerm_user_assigned_identity.this[0].client_id : azurerm_user_assigned_identity.this[0].client_id
  }

  tags = var.tags
}

data "azurerm_user_assigned_identity" "this" {
  count               = var.encryption_identity_name != null ? 1 : 0
  name                = var.encryption_identity_name
  resource_group_name = coalesce(var.encryption_identity_resource_group_name, var.resource_group_name)
}

resource "azurerm_user_assigned_identity" "this" {
  count = var.encryption_identity_name != null ? 0 : 1

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "acr-${var.name}-identity"
}

resource "azurerm_key_vault_access_policy" "this" {
  count = var.encryption_identity_name != null ? 0 : 1

  key_vault_id = var.encryption_key_vault_id
  tenant_id    = coalesce(var.encryption_tenant_id, data.azurerm_client_config.self.tenant_id)
  object_id    = azurerm_user_assigned_identity.this[0].principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey"
  ]
}
