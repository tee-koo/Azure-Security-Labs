output "vnet_id"            { value = azurerm_virtual_network.hub.id }
output "vnet_name"          { value = azurerm_virtual_network.hub.name }
output "firewall_private_ip" { 
  value = azurerm_firewall.central.ip_configuration[0].private_ip_address 
}
