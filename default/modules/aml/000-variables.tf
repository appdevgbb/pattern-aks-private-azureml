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

variable acr_subnet_id {
  type = string
}

variable "acr_private_dns_zone_ids" {
  type = list
}

variable "aml_private_dns_zone_ids" {
  type = list
}

variable "amlnotebook_private_dns_zone_ids" {
  type = list
}