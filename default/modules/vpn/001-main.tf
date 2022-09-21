data "azurerm_client_config" "current" {}

locals {
  prefix    = var.prefix
  suffix    = var.suffix
  workspace = terraform.workspace

  hostname  = "${local.prefix}${local.workspace}${local.suffix}"
  subnet_id = var.subnet_id
}