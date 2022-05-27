terraform {
  required_version = "~> 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.82.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

locals {
  ip = "" # Fill here with your IP address.
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
  source              = "git@github.com:padok-team/terraform-azurerm-keyvault.git?ref=v0.1.1"
  name                = random_pet.keyvault.id
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"

  access_policy = {
    (data.azurerm_client_config.self.object_id) = {
      key_permissions = ["Get", "List", "Create", "Delete", "Update"]
    }
  }

  network_acls = {
    ip_rules                   = [local.ip]
    virtual_network_subnet_ids = []
  }

  depends_on = [
    azurerm_resource_group.example
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
