data "azurerm_client_config" "this" {}

resource "random_pet" "keyvault" {}
resource "random_pet" "acr" {
  separator = ""
}

resource "azurerm_resource_group" "example" {
  name     = "example-acr"
  location = "francecentral"
}

module "key_vault" {
  source = "git@github.com:padok-team/terraform-azurerm-keyvault.git?ref=v0.2.0"

  name           = random_pet.keyvault.id # KeyVault names are globally unique
  resource_group = azurerm_resource_group.example
  tenant_id      = data.azurerm_client_config.this.tenant_id
  sku_name       = "standard"

  enable_network_acl        = false
  enable_rbac_authorization = true

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_role_assignment" "keyvault_administrator" {
  scope                = module.key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "29ecfec2-8b7b-4a66-91ba-757694c84bf6" # TODO: set your principal ID here
}

resource "azurerm_key_vault_key" "example" {
  name         = "acr-key"
  key_vault_id = module.key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    module.key_vault,
    azurerm_role_assignment.keyvault_administrator
  ]
}

module "acr" {
  source              = "../.."
  name                = random_pet.acr.id
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  public_network_access_enabled = true

  encryption_key_vault_id     = module.key_vault.this.id
  encryption_key_vault_key_id = azurerm_key_vault_key.example.id

  georeplications = {
    "eastus" = {
      regional_endpoint_enabled = true,
      zone_redundancy_enabled   = true,
      tags = {
        "continent" = "america"
      }
    },
    "japaneast" = {
      regional_endpoint_enabled = true,
      zone_redundancy_enabled   = true,
      tags = {
        "continent" = "asia"
      }
    }
  }

  depends_on = [
    module.key_vault,
  ]
}
