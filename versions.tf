terraform {
  required_version = "~> 1.0.0"

  experiments = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.77.0"
    }
  }
}
