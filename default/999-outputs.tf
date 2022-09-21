output "resource_group" {
  value = azurerm_resource_group.default.name
}

output "firewall" {
  value = {
    fqdn       = module.firewall.fqdn
    ip_address = module.firewall.public_ip_address
  }
}

output "jumpbox" {
  value = {
    fqdn       = module.jumpbox.fqdn
    ip_address = module.jumpbox.public_ip_address
  }
}

# output "vpn_id" {
#   value = module.vpn.gateway.id
# }

# output "client_cert_password" {
#   value = local.cert_password
# }