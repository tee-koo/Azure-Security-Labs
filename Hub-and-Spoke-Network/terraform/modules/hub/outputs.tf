output "vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "firewall_private_ip" {
  value = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.firewall_pip.ip_address
}

output "bastion_name" {
  value = azurerm_bastion_host.hub_bastion.name
}
