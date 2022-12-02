locals {
  ip = "31.32.227.74" # Fill here with your IP address.
}

data "azurerm_client_config" "self" {}

resource "random_pet" "keyvault" {}
resource "random_pet" "acr" {
  separator = ""
}

resource "azurerm_resource_group" "example" {
  name     = "example-acr"
  location = "francecentral"
}

module "keyvault" {
  source = "git@github.com:padok-team/terraform-azurerm-keyvault.git?ref=v0.2.0"

  name           = random_pet.keyvault.id # KeyVault names are globally unique
  resource_group = azurerm_resource_group.example
  tenant_id      = data.azurerm_client_config.self.tenant_id
  sku_name       = "standard"

  enable_network_acl        = true
  enable_rbac_authorization = true

  network_acls = {
    ip_rules                   = [local.ip]
    virtual_network_subnet_ids = []
  }

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_role_assignment" "keyvault_administrator" {
  scope                = module.keyvault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = "UPDATE ME !!" # TODO: set your principal ID here
}

resource "azurerm_key_vault_key" "example" {
  name         = "acr-key"
  key_vault_id = module.keyvault.id
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
    module.keyvault.example,
    azurerm_role_assignment.keyvault_administrator
  ]
}

module "acr" {
  source              = "../.."
  name                = random_pet.acr.id
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  public_network_access_enabled = true
  ip_addresses                  = [local.ip]

  encryption_key_vault_id     = module.keyvault.id
  encryption_key_vault_key_id = azurerm_key_vault_key.example.id

  depends_on = [
    module.keyvault
  ]
}
