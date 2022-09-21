variable "prefix" {
  type = string
}

variable "suffix" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "uid" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type = string
}

variable "acr_subnet_id" {
  type = string
}

variable "acr_private_dns_zone_ids" {
  type = list(any)
}

variable "resource_group" {
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "aks_settings" {
  type = object({
    kubernetes_version      = string
    private_cluster_enabled = bool
    identity                = string
    outbound_type           = string
    network_plugin          = string
    network_policy          = string
    load_balancer_sku       = string
    pod_cidr                = string
    service_cidr            = string
    dns_service_ip          = string
    docker_bridge_cidr      = string
    admin_username          = string
    ssh_key                 = string
  })
  default = {
    kubernetes_version      = null
    private_cluster_enabled = false
    identity                = "SystemAssigned"
    outbound_type           = "loadBalancer"
    network_plugin          = "azure"
    network_policy          = "calico"
    load_balancer_sku       = "standard"
    pod_cidr                = "10.174.0.0/17"
    service_cidr            = "10.174.128.0/17"
    dns_service_ip          = "10.174.128.10"
    docker_bridge_cidr      = "172.17.0.1/16"
    admin_username          = "azureuser"
    ssh_key                 = null
  }
}

variable "default_node_pool" {
  type = object({
    name                = string
    enable_auto_scaling = bool
    node_count          = number
    min_count           = number
    max_count           = number
    vm_size             = string
    type                = string
    os_disk_size_gb     = number
  })

  default = {
    name                = "defaultnp"
    enable_auto_scaling = true
    node_count          = 2
    min_count           = 2
    max_count           = 5
    vm_size             = "Standard_D4s_v3"
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 30
  }
}

variable "user_node_pools" {
  type = map(object({
    vm_size     = string
    node_count  = number
    node_labels = map(string)
    node_taints = list(string)
  }))

  default = {
    "usernp1" = {
      vm_size     = "Standard_D4s_v3"
      node_count  = 3
      node_labels = null
      node_taints = []
    }
  }
}
