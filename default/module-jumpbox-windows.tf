module "win11jumpbox" {
  depends_on = [
    module.firewall
  ]

  source = "./modules/jumpbox-windows"

  prefix = local.prefix
  suffix = local.suffix

  sku = "Standard_D4s_v3"

  subnet_id      = azurerm_subnet.jumpbox.id
  resource_group = azurerm_resource_group.default

  admin_username = var.admin_username
}

resource "azurerm_firewall_nat_rule_collection" "rdp" {
  name                = "JumpboxSshRDPRule"
  azure_firewall_name = module.firewall.name
  resource_group_name = azurerm_resource_group.default.name
  priority            = 210
  action              = "Dnat"

  rule {
    name = "JumpboxRDP"

    source_addresses = [
      data.http.myip.response_body
    ]

    destination_ports = [
      "3389",
    ]

    destination_addresses = [
      module.firewall.public_ip_address
    ]

    translated_port = 3389

    translated_address = module.win11jumpbox.private_ip_address

    protocols = [
      "TCP"
    ]
  }
}