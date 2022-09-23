resource "azurerm_log_analytics_workspace" "example" {
  name                = "${local.prefix}aml${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "example" {
  name                = "${local.prefix}aml${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  name                = "${local.prefix}akv${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "example" {
  name                     = "${local.prefix}stor${local.suffix}"
  location                 = var.resource_group.location
  resource_group_name      = var.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "${local.prefix}workspace${local.suffix}"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  public_access_behind_virtual_network_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "example" {
  name                          = "${local.prefix}amlacr${local.suffix}"
  resource_group_name           = var.resource_group.name
  location                      = var.resource_group.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "acr" {
  name                = "${local.prefix}-acr-endpoint-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.acr_subnet_id

  private_service_connection {
    name                           = "${local.prefix}-acr-connection-${local.suffix}"
    private_connection_resource_id = azurerm_container_registry.example.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-private-endpoint-group"
    private_dns_zone_ids = var.acr_private_dns_zone_ids
  }
}


resource "azurerm_role_assignment" "mi-access-to-acr" {
  scope                = azurerm_container_registry.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_machine_learning_workspace.example.identity[0].principal_id
}

# resource "azurerm_private_endpoint" "aml" {
#   name                = "${local.prefix}-aml-endpoint-${local.suffix}"
#   location            = var.resource_group.location
#   resource_group_name = var.resource_group.name
#   subnet_id           = var.subnet_id

#   private_service_connection {
#     name                           = "${local.prefix}-aml-connection-${local.suffix}"
#     private_connection_resource_id = azurerm_machine_learning_workspace.example.id
#     is_manual_connection           = false
#     subresource_names              = ["amlworkspace"]
#   }

#   private_dns_zone_group {
#     name                 = "aml-private-endpoint-group"
#     private_dns_zone_ids = var.aml_private_dns_zone_ids
#   }
# }
