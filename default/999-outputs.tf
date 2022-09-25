output "resource_group_name" {
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
    fqdn               = module.firewall.fqdn
    public_ip_address = module.firewall.public_ip_address
    private_ip_address = module.jumpbox.ip_address
    username           = module.jumpbox.admin_username
    ssh = "${module.jumpbox.admin_username}@${module.firewall.fqdn}"
  }
}

output "aks_cluster_name" {
  value = module.aks-1.cluster_name
}

output "aml_workspace_name" {
  value = module.aml.workspace_name
}


output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "windows-jumpbox" {
  value = {
    fqdn        = module.firewall.fqdn
    public_ip_address  = module.firewall.public_ip_address
    private_ip_address = module.win11jumpbox.private_ip_address
    password    = module.win11jumpbox.admin_password    
  }
  sensitive = true
}