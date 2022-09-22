# hub
# 
resource "azurerm_virtual_network" "default" {
  name                = "${azurerm_resource_group.default.name}-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.255.0.0/16"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.0.0/26"]
}

resource "azurerm_subnet" "acr" {
  name                 = "AcrSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  # service_endpoints     = ["Microsoft.ContainerRegistry"]
  # enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = true
  address_prefixes                               = ["10.255.0.160/27"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "JumpboxSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.255.240/28"]
}

# spokes
#

# spoke-1
resource "azurerm_virtual_network" "aks-1-vnet" {
  name                = "aks-1-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.220.0.0/16"]
}

resource "azurerm_subnet" "aks-1-cluster" {
  name                                           = "Aks1ClusterSubnet"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.aks-1-vnet.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes                               = ["10.220.0.0/22"]
}

resource "azurerm_subnet" "aks-1-ingress" {
  name                                           = "Aks1IngressSubnet"
  resource_group_name                            = azurerm_resource_group.default.name
  virtual_network_name                           = azurerm_virtual_network.aks-1-vnet.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes                               = ["10.220.4.0/22"]
}

# peerings
#
# hub-to-spoke-1
resource "azurerm_virtual_network_peering" "hub-to-spoke-1" {
  name                      = "hub-to-spoke-1"
  resource_group_name       = azurerm_resource_group.default.name
  virtual_network_name      = azurerm_virtual_network.default.name
  remote_virtual_network_id = azurerm_virtual_network.aks-1-vnet.id
}

resource "azurerm_virtual_network_peering" "spoke-1-to-hub" {
 name                      = "spoke-1-to-hub"
 resource_group_name       = azurerm_resource_group.default.name
 virtual_network_name      = azurerm_virtual_network.aks-1-vnet.name
 remote_virtual_network_id = azurerm_virtual_network.default.id
}
