resource "azurerm_log_analytics_workspace" "azfw" {
  name                = "${local.prefix}-azfw-ws-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
