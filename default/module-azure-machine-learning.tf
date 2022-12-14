module "aml" {
  source = "./modules/aml"

  prefix = local.prefix
  suffix = local.suffix

  subnet_id      = azurerm_subnet.aml.id
  resource_group = azurerm_resource_group.default

  acr_subnet_id = azurerm_subnet.acr.id

  acr_private_dns_zone_ids = [
    azurerm_private_dns_zone.acr.id
  ]

  aml_private_dns_zone_ids = [
    azurerm_private_dns_zone.aml.id,
    azurerm_private_dns_zone.amlnotebook.id
  ]

  akv_private_dns_zone_ids = [
    azurerm_private_dns_zone.akv.id
  ]

  storageblob_private_dns_zone_ids = [
    azurerm_private_dns_zone.storageblob.id
  ]

  storagefile_private_dns_zone_ids = [
    azurerm_private_dns_zone.storagefile.id
  ]
}