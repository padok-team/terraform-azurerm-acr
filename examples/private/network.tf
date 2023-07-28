resource "azurerm_virtual_network" "this" {
  name                = "vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = random_pet.this.id
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  private_endpoint_network_policies_enabled = true

  address_prefixes = ["10.0.0.0/28"]
}

resource "azurerm_private_dns_zone" "this" {
  # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}
