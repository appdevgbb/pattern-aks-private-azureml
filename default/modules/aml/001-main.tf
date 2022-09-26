provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {}


resource "random_integer" "uid" {
  min = 0
  max = 99
}

locals {
  prefix    = var.prefix
  suffix    = var.suffix
}