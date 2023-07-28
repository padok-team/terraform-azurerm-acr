terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

locals {
  ip = "176.163.170.91" # Fill here with your IP address.
}

data "azurerm_client_config" "this" {}

resource "random_pet" "keyvault" {}
resource "random_pet" "acr" {
  separator = ""
}

resource "azurerm_resource_group" "this" {
  name     = "example-acr"
  location = "francecentral"
}

module "keyvault" {
  source         = "git@github.com:padok-team/terraform-azurerm-keyvault.git?ref=v0.5.0"
  name           = random_pet.keyvault.id
  resource_group = azurerm_resource_group.this
  sku_name       = "standard"
  tenant_id      = data.azurerm_client_config.this.tenant_id

  access_policy = {
    (data.azurerm_client_config.this.object_id) = {
      key_permissions = ["Get", "List", "Create", "Delete", "Update"]
    }
  }

  network_acls = {
    ip_rules                   = [local.ip]
    virtual_network_subnet_ids = []
  }

  depends_on = [
    azurerm_resource_group.this
  ]
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
    module.keyvault.example
  ]
}

module "acr" {
  source         = "../.."
  name           = random_pet.acr.id
  resource_group = azurerm_resource_group.this

  public_network_access_enabled = true
  ip_addresses                  = [local.ip]

  encryption_key_vault_id     = module.keyvault.id
  encryption_key_vault_key_id = azurerm_key_vault_key.example.id

  depends_on = [
    module.keyvault
  ]
}
