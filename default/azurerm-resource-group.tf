resource "azurerm_resource_group" "default" {
  name     = "${local.prefix}-${local.workspace}-${local.suffix}"
  location = var.location
}

