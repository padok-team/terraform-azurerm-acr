resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = concat(var.identity_ids, [var.encryption_identity_name ? data.azurerm_user_assigned_identity.this[0].id : azurerm_user_assigned_identity.this[0].id])
  }

  dynamic "georeplications" {
    for_each = var.georeplications == null ? [] : [0]
    content {
      location                  = georeplications.location
      regional_endpoint_enabled = georeplications.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.zone_redundancy_enabled
      tags                      = georeplications.tags
    }
  }

  # Encryption should be enabled by default.
  encryption {
    enabled            = true
    key_vault_key_id   = var.key_vault_key_id
    identity_client_id = var.encryption_identity_name ? data.azurerm_user_assigned_identity.this[0].client_id : azurerm_user_assigned_identity.this[0].client_id
  }
}

data "azurerm_user_assigned_identity" "this" {
  count               = var.encryption_identity_name ? 1 : 0
  name                = var.encryption_identity_name
  resource_group_name = var.encryption_identity_resource_group_name ? var.encryption_identity_resource_group_name : var.resource_group_name
}

resource "azurerm_user_assigned_identity" "this" {
  count = var.encryption_identity_name ? 0 : 1

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "acr-${var.name}-identity"
}
