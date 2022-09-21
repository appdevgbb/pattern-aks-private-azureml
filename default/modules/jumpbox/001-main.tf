locals {
  prefix    = var.prefix
  suffix    = var.suffix
  workspace = terraform.workspace

  hostname = "${local.prefix}${local.workspace}${local.suffix}"
}