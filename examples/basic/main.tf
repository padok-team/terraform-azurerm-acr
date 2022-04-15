terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.82.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "francecentral"
}

module "acr" {
  source = "../.."
  name = "example"
  resource_group_name = azurerm_resource_group.example.name
  location = "francecentral"
}
