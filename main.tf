resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  zone_redundancy_enabled = true
  sku                 = var.sku

  public_network_access_enabled = false

  retention_policy {
    enabled = true
    days = var.retention_duration
  }

  dynamic "network_rule_set" {
    for_each = var.subnet_ids
    content {
      virtual_network {
        action = "Allow"
        subnet_id = each.key
      }
    }
  }
  
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = concat(var.identity_ids, [var.encryption_identity_name != null ? data.azurerm_user_assigned_identity.this[0].id : azurerm_user_assigned_identity.this[0].id])
  }

  dynamic "georeplications" {
    for_each = var.georeplications
    content {
      location                  = each.key
      regional_endpoint_enabled = each.value.regional_endpoint_enabled
      zone_redundancy_enabled   = each.value.zone_redundancy_enabled
      tags                      = each.value.tags
    }
  }

  # Encryption should be enabled by default.
  encryption {
    enabled            = true
    key_vault_key_id   = var.key_vault_key_id
    identity_client_id = var.encryption_identity_name != null ? data.azurerm_user_assigned_identity.this[0].client_id : azurerm_user_assigned_identity.this[0].client_id
  }
}

data "azurerm_user_assigned_identity" "this" {
  count               = var.encryption_identity_name != null ? 1 : 0
  name                = var.encryption_identity_name
  resource_group_name = var.encryption_identity_resource_group_name ? var.encryption_identity_resource_group_name : var.resource_group_name
}

resource "azurerm_user_assigned_identity" "this" {
  count = var.encryption_identity_name != null ? 0 : 1

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "acr-${var.name}-identity"
}
