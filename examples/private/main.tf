
resource "random_pet" "this" {
  separator = ""
}

resource "azurerm_resource_group" "this" {
  name     = random_pet.this.id
  location = "francecentral"
}

module "acr" {
  source         = "../.."
  name           = random_pet.this.id
  resource_group = azurerm_resource_group.this

  public_network_access_enabled = false

  encryption_key_vault_id     = module.key_vault.this.id
  encryption_key_vault_key_id = azurerm_key_vault_key.this.id

  private_endpoint = {
    enable              = true
    subnet_id           = azurerm_subnet.this.id
    private_dns_zone_id = azurerm_private_dns_zone.this.id
  }

  depends_on = [
    module.key_vault
  ]
}
