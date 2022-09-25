
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "${azurerm_firewall.default.name}-diag-settings"
  target_resource_id = azurerm_firewall.default.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azfw.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled = true
  }
}