data "azurerm_client_config" "current" {
}

locals {
  prefix    = var.prefix
  suffix    = var.suffix
  hostname = "${local.prefix}win11${local.suffix}"
  current_user = data.azurerm_client_config.current.object_id
}