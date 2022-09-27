resource "azurerm_storage_account" "nfs" {
  name                     = "nfs${local.prefix}stor${local.suffix}"
  location                 = var.resource_group.location
  resource_group_name      = var.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_private_endpoint" "storagefile" {
  name                = "${local.prefix}-nfs-storagefile-endpoint-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.prefix}-nfs-storagefile-connection-${local.suffix}"
    private_connection_resource_id = azurerm_storage_account.nfs.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "nfs-storagefile-private-endpoint-group"
    private_dns_zone_ids = var.storagefile_private_dns_zone_ids
  }
}