variable "prefix" {
  type = string
}

variable "suffix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "resource_group" {
}

variable "vpn_sku" {
  type    = string
  default = "VpnGw1AZ"
}

variable "zone_name" {
  type = string
}