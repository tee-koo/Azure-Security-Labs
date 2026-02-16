output "vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "vm_app_name" {
  value = azurerm_windows_virtual_machine.app_vm.name
}

output "vm_db_name" {
  value = azurerm_windows_virtual_machine.db_vm.name
}

output "vm_admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}