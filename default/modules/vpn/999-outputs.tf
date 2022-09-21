output "ca_cert" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "ca_private_key" {
  value = {
    algorithm = tls_private_key.ca.algorithm
    pem       = tls_private_key.ca.private_key_pem
  }
}

output "gateway" {
  value = azurerm_virtual_network_gateway.default
}

output "fqdn" {
  value = azurerm_public_ip.vpngateway.fqdn
}

# output "key_vault_id" {
# 	value = azurerm_key_vault.vpn.id
# }