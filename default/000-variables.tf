variable "prefix" {
  type        = string
  description = "Value to prefix resource names with."
  default     = "gbb"
}

variable "location" {
  type        = string
  description = "Default Azure Region"
  default     = "westus3"
}

variable "vpn_sku" {
  type    = string
  default = "VpnGw1AZ"
}

variable "domain" {
  type    = string
  default = "azuregbb.com"
}
