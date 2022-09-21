variable "prefix" {
  type = string
}

variable "suffix" {
  type = string
}

variable "kv_name" {
  type    = string
  default = ""
}

variable "resource_group" {
}

variable "kv_settings" {
  type = object({
    enabled_for_disk_encryption = bool
    soft_delete_retention_days  = number
    purge_protection_enabled    = bool
    sku_name = string
  })
  default = {
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name = "standard"
  }
}
