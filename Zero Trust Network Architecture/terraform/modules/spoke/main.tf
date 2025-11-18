resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.spoke_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.spoke_cidr]
}

resource "azurerm_subnet" "app" {
  name                 = "subnet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_cidr, 8, 1)]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "subnet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [cidrsubnet(var.spoke_cidr, 8, 2)]
  private_endpoint_network_policies = "Disabled"
}

# Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-${var.spoke_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = "vnet-hub-central"
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-${var.spoke_name}-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

output "vnet_name" { value = azurerm_virtual_network.spoke.name }
