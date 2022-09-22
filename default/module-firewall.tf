module "firewall" {
  source         = "./modules/firewall"
  prefix         = local.prefix
  suffix         = local.suffix
  subnet_id      = azurerm_subnet.firewall.id
  resource_group = azurerm_resource_group.default
}

resource "azurerm_firewall_network_rule_collection" "jumpbox" {
  name                = "testcollection"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "defaultRule"

    source_addresses = azurerm_subnet.jumpbox.address_prefixes

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "Any",
    ]
  }
}

resource "azurerm_firewall_network_rule_collection" "dnsForwarder" {
  name                = "dnsForwarderCollection"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 200
  action              = "Allow"

  rule {
    name = "dnsForwarderRule"

    source_addresses = azurerm_subnet.dnsForwarder.address_prefixes

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}

resource "azurerm_firewall_network_rule_collection" "vpn" {
  name                = "vpnForwarderCollection"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 300
  action              = "Allow"

  rule {
    name = "vpnClientAllowRule"

    source_addresses = concat(["172.16.201.0/24"], azurerm_subnet.dnsForwarder.address_prefixes)

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "Any",
    ]
  }
}

resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = "aksRequiredRules${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 120
  action              = "Allow"

  rule {
    name = "updateInfraRules"

    source_addresses = concat([], azurerm_virtual_network.aks-1-vnet.address_space)

    target_fqdns = [
      "*.hcp.${module.firewall.resource_group.location}.azmk8s.io",
      "mcr.microsoft.com",
      "*.cdn.mcr.io",
      "*.data.mcr.microsoft.com",
      "management.azure.com",
      "login.microsoftonline.com",
      "dc.services.visualstudio.com",
      "*.ods.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.monitoring.azure.com",
      "packages.microsoft.com",
      "acs-mirror.azureedge.net",
      "azure.archive.ubuntu.com",
      "security.ubuntu.com",
      "changelogs.ubuntu.com",
      "launchpad.net",
      "ppa.launchpad.net",
      "keyserver.ubuntu.com",
      "*.docker.com",
      "*.docker.io"
    ]

    protocol {
      port = "443"
      type = "Https"
    }

    protocol {
      port = "80"
      type = "Http"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "azureMonitor" {
  name                = "azureMonitorRequiredRules${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 110
  action              = "Allow"

  rule {
    name = "azureMonitorRules"

    source_addresses = concat([], azurerm_virtual_network.default.address_space)

    target_fqdns = [
      "dc.services.visualstudio.com",
      "*.ods.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.monitoring.azure.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "ntp" {
  name                = "ntpRule${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 150
  action              = "Allow"

  rule {
    name = "ubuntuNTP"

    source_addresses = concat([], azurerm_virtual_network.aks-1-vnet.address_space)

    destination_ports = [
      "123",
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "UDP",
    ]
  }
}

resource "azurerm_firewall_network_rule_collection" "aml" {
  name                = "amlOutRules${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 160
  action              = "Allow"


  rule {
    name = "allowAadOut"

    source_addresses = ["*"]

    destination_ports = [
      "80",
      "443"
    ]

    destination_addresses = [
      "AzureActiveDirectory"
    ]

    protocols = [
      "TCP",
    ]
  }
  
  rule {
    name = "allowAmlOut"

    source_addresses = ["*"]

    destination_ports = [
      "80",
      "443",
      "18881"
    ]

    destination_addresses = [
      "AzureMachineLearning"
    ]

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "allowVariousOut"

    source_addresses = ["*"]

    destination_ports = [
      "443",
    ]

    destination_addresses = [
      "AzureResourceManager",
      "Storage.${var.location}",
      "AzureFrontDoor.FrontEnd",
      "AzureContainerRegistry.${var.location}",
      "MicrosoftContainerRegistry.${var.location}",
      "AzureKeyVault.${var.location}"
    ]

    protocols = [
      "TCP",
    ]
  }
}

resource "azurerm_firewall_application_rule_collection" "updates" {
  name                = "ubuntuUpdateInfrastructure${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 400
  action              = "Allow"

  rule {
    name = "updateInfraRules"

    source_addresses = concat([], azurerm_virtual_network.default.address_space)

    target_fqdns = [
      "azure.archive.ubuntu.com",
      "security.ubuntu.com",
      "changelogs.ubuntu.com",
      "launchpad.net",
      "ppa.launchpad.net",
      "keyserver.ubuntu.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }

    protocol {
      port = "80"
      type = "Http"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "azureML" {
  name                = "azureML${local.suffix}"
  azure_firewall_name = module.firewall.name
  resource_group_name = module.firewall.resource_group.name
  priority            = 500
  action              = "Allow"

  rule {
    name = "allowAmlOut"

    source_addresses = ["*"]

    target_fqdns = [
      "graph.windows.net",
      "*.anaconda.com",
      "pypi.org",
      "cloud.r-project.org",
      "*pytorch.org",
      "*.tensorflow.org",
      "*vscode.dev",
      "*vscode-unpkg.net",
      "*vscode-cdn.net",
      "*vscodeexperiments.azureedge.net",
      "default.exp-tas.com",
      "code.visualstudio.com",
      "update.code.visualstudio.com",
      "*.vo.msecnd.net",
      "marketplace.visualstudio.com",
      "vscode.blob.core.windows.net",
      "*.gallerycdn.vsassets.io",
      "raw.githubusercontent.com",
      "dc.applicationinsights.azure.com",
      "dc.applicationinsights.microsoft.com",
      "dc.services.visualstudio.com",
      "*.kusto.windows.net",
      "*.table.core.windows.net",
      "*.queue.core.windows.net",
      "*.blob.core.windows.net",
      "*.api.azureml.ms",
      "*.experiments.azureml.net",
      "*.azurecr.io",
      "*.workspace.${var.location}.api.azureml.ms",
      "${var.location}.experiments.azureml.net",
      "${var.location}.api.azureml.ms",
      "pypi.org",
      "archive.ubuntu.com",
      "security.ubuntu.com",
      "ppa.launchpad.net",
    ]

    protocol {
      port = "443"
      type = "Https"
    }

    protocol {
      port = "80"
      type = "Http"
    }
  }
}