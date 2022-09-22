terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric  = false
}

resource "random_password" "cert_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

locals {
  prefix        = var.prefix
  workspace     = terraform.workspace
  suffix        = random_string.suffix.result
  cert_password = random_password.cert_password.result
  zone_name     = "${var.location}.${var.custom_domain}"
}
