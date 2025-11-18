resource "azurerm_route_table" "forced" {
  name                          = "rt-${var.spoke_name}-forced"
  location                      = var.location
  resource_group_name           = var.resource_group_name
}

resource "azurerm_route" "default" {
  name                   = "default-to-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.forced.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.forced.id
}
