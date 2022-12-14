resource "random_password" "admin_password" {
  length  = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric  = 1
  min_special = 1
}


locals {
  prefix    = var.prefix
  suffix    = var.suffix
  hostname = "${local.prefix}win11${local.suffix}"
  admin_password = var.admin_password != "" ? var.admin_password : random_password.admin_password.result
}