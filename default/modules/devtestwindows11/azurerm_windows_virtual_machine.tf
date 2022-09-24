resource "azurerm_network_interface" "example" {
  name                = "${local.prefix}-win11-nic-${local.suffix}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  size                = var.sku
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  allow_extension_operations = true

  enable_automatic_updates = true

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
    disk_size_gb = var.disk_size_gb
  }

  source_image_reference {
    offer     = "windows-11"
    publisher = "microsoftwindowsdesktop"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }

  identity {
   type = "SystemAssigned"  
  }

  license_type = "Windows_Client"
}

resource "azurerm_virtual_machine_extension" "aad" {
  name                 = "AADLoginForWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.example.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForWindows"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "mdmId": ""
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "attestation" {
  name                 = "GuestAttestation"
  virtual_machine_id   = azurerm_windows_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Security.WindowsAttestation"
  type                 = "GuestAttestation"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "AttestationConfig": {
        "MaaSettings": {
          "maaEndpoint": "",
          "maaTenantName": "GuestAttestation"
        },
        "AscSettings": {
          "ascReportingEndpoint": "",
          "ascReportingFrequency": ""
        },
        "useCustomToken": "false",
        "disableAlerts": "false"
      }
    }
SETTINGS
}


resource "azurerm_role_assignment" "jumpbox-contributor" {
  scope                = var.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_windows_virtual_machine.example.identity[0].principal_id
}