module "dnsForwarder" {
  depends_on = [
    module.firewall
  ]

  source = "./modules/dnsForwarder"

  prefix = local.prefix
  suffix = local.suffix

  vnet_address_spaces = concat(azurerm_virtual_network.aks-1-vnet.address_space)
  # vnet_address_spaces = concat(azurerm_virtual_network.default.address_space, module.vpn.gateway.vpn_client_configuration[0].address_space)
  subnet_id      = azurerm_subnet.dnsForwarder.id
  resource_group = azurerm_resource_group.default
}
