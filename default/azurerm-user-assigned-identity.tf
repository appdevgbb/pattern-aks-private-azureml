resource "azurerm_user_assigned_identity" "managed-id" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  name = "aks-user-assigned-managed-id"
}

resource "azurerm_role_assignment" "aks-mi-roles" {
  scope                = azurerm_private_dns_zone.hub.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.managed-id.principal_id
}

# cluster-1
#
resource "azurerm_role_assignment" "aks-mi-roles-aks-1" {
  scope                = azurerm_virtual_network.aks-1-vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.managed-id.principal_id
}

resource "azurerm_role_assignment" "aks-mi-roles-default-vnet" {
  scope                = azurerm_virtual_network.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.managed-id.principal_id
}

resource "azurerm_role_assignment" "aks-mi-roles-aks-1-rt" {
  scope                = azurerm_route_table.aks-1-rt.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.managed-id.principal_id
}

resource "azurerm_role_assignment" "aks-mi-roles-aks-1-dns-zone" {
  scope = azurerm_private_dns_zone.aksPrivateZone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id = azurerm_user_assigned_identity.managed-id.principal_id
}