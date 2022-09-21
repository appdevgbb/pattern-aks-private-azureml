locals {
  prefix        = var.prefix
  workspace     = terraform.workspace
  suffix        = var.suffix
  firewall_name = "${local.prefix}${local.workspace}${local.suffix}"
}