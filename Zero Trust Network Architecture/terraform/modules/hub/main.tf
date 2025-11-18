resource "azurerm_resource_group" "core" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-central"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  address_space       = ["10.100.0.0/16"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.2.0/27"]
}
