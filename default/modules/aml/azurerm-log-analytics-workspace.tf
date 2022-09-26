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