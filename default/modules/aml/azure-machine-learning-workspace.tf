resource "azurerm_machine_learning_workspace" "example" {
  name                    = "${local.prefix}workspace${local.suffix}"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
  
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  container_registry_id   = azurerm_container_registry.example.id
  
  public_access_behind_virtual_network_enabled = false

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "aml" {
  name                = "${local.prefix}-aml-endpoint-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.prefix}-aml-connection-${local.suffix}"
    private_connection_resource_id = azurerm_machine_learning_workspace.example.id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }

  private_dns_zone_group {
    name                 = "aml-private-endpoint-group"
    private_dns_zone_ids = var.aml_private_dns_zone_ids
  }
}
