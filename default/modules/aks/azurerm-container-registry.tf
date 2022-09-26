resource "azurerm_container_registry" "default" {
  name                          = "${local.cluster_name}gbbacr"
  resource_group_name           = var.resource_group.name
  location                      = var.resource_group.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  # Only needed for service endpoint not needed for private link/endpoint
  # network_rule_set {
  #   default_action = "Deny"
  #   virtual_network {
  #     action = "Allow"s
  #     subnet_id = var.acr_subnet_id
  #   }
  # }
}

resource "azurerm_private_endpoint" "acr" {
  name                = "${local.cluster_name}-acr-endpoint"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.acr_subnet_id

  private_service_connection {
    name                           = "${local.cluster_name}-acr-connection"
    private_connection_resource_id = azurerm_container_registry.default.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-private-endpoint-group"
    private_dns_zone_ids = var.acr_private_dns_zone_ids
  }
}


resource "azurerm_role_assignment" "mi-access-to-acr" {
  scope                = azurerm_container_registry.default.id
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_identity.principal_id
}


