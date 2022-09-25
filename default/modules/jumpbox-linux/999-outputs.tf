output "ip_address" {
  value = azurerm_network_interface.jumpbox.private_ip_address
}

output "admin_username" {
  value = var.admin_username
}