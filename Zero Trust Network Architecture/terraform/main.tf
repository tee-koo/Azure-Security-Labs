# Create RG
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hub and Spoke moodeles
module "hub" {
  source              = "./modules/hub"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags
}

module "spoke" {
  source              = "./modules/spoke"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags
}

# VNet Peering: Hub <-> Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.spoke.vnet_name
  remote_virtual_network_id = module.hub.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# One Route Table: All traffic through firewall
resource "azurerm_route_table" "to_firewall" {
  name                = "rt-all-to-firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.hub.firewall_private_ip
  }
}

# Connect UDR for both spoke subnets
resource "azurerm_subnet_route_table_association" "app_to_fw" {
  subnet_id      = module.spoke.app_subnet_id
  route_table_id = azurerm_route_table.to_firewall.id
}

resource "azurerm_subnet_route_table_association" "db_to_fw" {
  subnet_id      = module.spoke.db_subnet_id
  route_table_id = azurerm_route_table.to_firewall.id
}
