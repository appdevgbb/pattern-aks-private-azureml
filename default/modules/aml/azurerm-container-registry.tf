resource "azurerm_container_registry" "example" {
  name                          = "${local.prefix}amlacr${local.suffix}"
  resource_group_name           = var.resource_group.name
  location                      = var.resource_group.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "acr" {
  name                = "${local.prefix}-acr-endpoint-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.acr_subnet_id

  private_service_connection {
    name                           = "${local.prefix}-acr-connection-${local.suffix}"
    private_connection_resource_id = azurerm_container_registry.example.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-private-endpoint-group"
    private_dns_zone_ids = var.acr_private_dns_zone_ids
  }
}