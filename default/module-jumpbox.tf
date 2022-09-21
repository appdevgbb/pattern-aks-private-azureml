module "jumpbox" {
  depends_on = [
    module.firewall
  ]

  source = "./modules/jumpbox"

  prefix = local.prefix
  suffix = local.suffix

  subnet_id      = azurerm_subnet.jumpbox.id
  resource_group = azurerm_resource_group.default
}


resource "azurerm_firewall_nat_rule_collection" "ssh" {
  name                = "JumpboxSshNatRule"
  azure_firewall_name = module.firewall.name
  resource_group_name = azurerm_resource_group.default.name
  priority            = 200
  action              = "Dnat"

  rule {
    name = "JumpboxSSH"

    source_addresses = [
      "*"
    ]

    destination_ports = [
      "22",
    ]

    destination_addresses = [
      module.firewall.public_ip_address
    ]

    translated_port = 22

    translated_address = module.jumpbox.ip_address

    protocols = [
      "TCP"
    ]
  }
}