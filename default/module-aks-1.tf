module "aks-1" {
  depends_on = [
    module.firewall,
    azurerm_subnet_route_table_association.aks-1,
    # explict dependency on the firewall rules ensures they're in place before deploying private cluster
    azurerm_firewall_application_rule_collection.aks,
    azurerm_firewall_application_rule_collection.azureMonitor,
    azurerm_firewall_application_rule_collection.updates,
    azurerm_firewall_network_rule_collection.ntp,
    azurerm_private_dns_zone.acr,
    azurerm_role_assignment.aks-mi-roles,
    azurerm_virtual_network.aks-1-vnet
  ]

  source = "./modules/aks"

  prefix = local.prefix
  suffix = local.suffix

  subnet_id                  = azurerm_subnet.aks-1-cluster.id
  acr_subnet_id              = azurerm_subnet.acr.id
  resource_group             = azurerm_resource_group.default
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id

  acr_private_dns_zone_ids = [
    azurerm_private_dns_zone.acr.id
  ]

  private_dns_zone_id = azurerm_private_dns_zone.aksPrivateZone.id

  cluster_name = "${local.prefix}azureml${local.suffix}"
  aks_settings = {
    kubernetes_version      = null
    private_cluster_enabled = true
    identity                = "UserAssigned"
    outbound_type           = "userDefinedRouting"
    network_plugin          = "kubenet"
    network_policy          = "calico"
    load_balancer_sku       = "standard"
    pod_cidr                = "10.174.0.0/17"
    service_cidr            = "10.174.128.0/17"
    dns_service_ip          = "10.174.128.10"
    docker_bridge_cidr      = "172.17.0.1/16"
    admin_username          = "dcasati"
    ssh_key                 = "~/.ssh/id_rsa.pub"
  }

  default_node_pool = {
    name                         = "defaultnp"
    enable_auto_scaling          = true
    node_count                   = 2
    min_count                    = 2
    max_count                    = 3
    vm_size                      = "Standard_D4s_v3"
    type                         = "VirtualMachineScaleSets"
    os_disk_size_gb              = 30
    only_critical_addons_enabled = true
  }

  user_node_pools = {
    "usernp1" = {
      vm_size     = "Standard_D4s_v3"
      node_count  = 3
      node_labels = null
      node_taints = []
    }
  }
}
