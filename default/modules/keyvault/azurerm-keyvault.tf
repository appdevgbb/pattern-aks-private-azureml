data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "default-kv-01" {
  name                = "defaultKeyVault"
  resource_group_name = azurerm_resource_group.default.name
  enabled_for_disk_encryption = var.kv_settings.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.kv_settings.soft_delete_retention_days
  purge_protection_enabled    = var.kv_settings.purge_protection_enabled

  sku_name = var.kv_settings.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
