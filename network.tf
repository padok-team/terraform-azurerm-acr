resource "azurerm_private_endpoint" "these" {
  for_each = var.private_endpoints

  name                = each.value.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  subnet_id           = each.value.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  # Reference: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  private_service_connection {
    name                           = var.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
  }
  tags = var.tags
}
