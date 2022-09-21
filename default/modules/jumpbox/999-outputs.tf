output "fqdn" {
  value = azurerm_public_ip.jumpbox.fqdn
}

output "ip_address" {
  value = azurerm_network_interface.jumpbox.private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.jumpbox.ip_address
}