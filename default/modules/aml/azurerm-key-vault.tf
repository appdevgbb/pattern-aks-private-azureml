resource "azurerm_key_vault" "example" {
  name                = "${local.prefix}akv${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_private_endpoint" "kv_ple" {
  name                = "${local.prefix}-akv-endpoint-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                 = "${local.prefix}-akv-connection-${local.suffix}"
    private_connection_resource_id = azurerm_key_vault.example.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "akv-private-endpoint-group"
    private_dns_zone_ids = var.akv_private_dns_zone_ids
  }
}
