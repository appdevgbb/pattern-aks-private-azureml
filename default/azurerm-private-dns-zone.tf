resource "azurerm_private_dns_zone" "hub" {
  name                = local.zone_name
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "hubDnsLink"
  resource_group_name   = azurerm_resource_group.default.name
  private_dns_zone_name = azurerm_private_dns_zone.hub.name
  virtual_network_id    = azurerm_virtual_network.default.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "acr-privatelink"
  resource_group_name   = azurerm_resource_group.default.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = azurerm_virtual_network.default.id
}
