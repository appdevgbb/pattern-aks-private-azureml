
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "${azurerm_firewall.default.name}-diag-settings"
  target_resource_id = azurerm_firewall.default.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azfw.id
  log_analytics_destination_type = "AzureDiagnostics"

  metric {
    category = "AllMetrics"
    enabled = true
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled = true
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWThreatIntel"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWNetworkRuleAggregation"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWNetworkRule"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWNatRuleAggregation"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZNatRule"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWIdpsSignature"
    enabled = false
    retention_policy {
      days = 0
      enabled = false
    }
  }

  log {
    category = "AZFWApplicationRule"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AZFWApplicationRuleAggregation"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AZFWDnsQuery"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AZFWFatFlow"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AZFWFqdnResolveFailure"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [
      log
    ]
  }

}