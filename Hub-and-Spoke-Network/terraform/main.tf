resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Centralized private DNS zone for Azure Blob Storage Private Endpoints.
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

module "hub" {
  source                 = "./modules/hub"
  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  tags                   = var.tags
  allowed_outbound_fqdns = var.allowed_outbound_fqdns
}

module "spoke" {
  source                = "./modules/spoke"
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  tags                  = var.tags
  private_dns_zone_id   = azurerm_private_dns_zone.blob.id
  bastion_subnet_prefix = module.hub.bastion_subnet_prefix
}

# Link the Blob Private DNS zone to the workload VNet so workloads can
# resolve the normal Storage endpoint name to its private endpoint address.
resource "azurerm_private_dns_zone_virtual_network_link" "blob_spoke" {
  name                  = "link-blob-spoke"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = module.spoke.vnet_id
  registration_enabled  = false
  tags                  = var.tags
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

# Default outbound route from workload subnets to Azure Firewall.
# This does not, by itself, force same-VNet east-west or Private Endpoint
# traffic through the firewall; see the README for the routing limitations.
resource "azurerm_route_table" "spoke_egress" {
  name                = "rt-spoke-egress"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  route {
    name                   = "default-route-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.hub.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "app_to_firewall" {
  subnet_id      = module.spoke.app_subnet_id
  route_table_id = azurerm_route_table.spoke_egress.id
}

resource "azurerm_subnet_route_table_association" "db_to_firewall" {
  subnet_id      = module.spoke.db_subnet_id
  route_table_id = azurerm_route_table.spoke_egress.id
}
