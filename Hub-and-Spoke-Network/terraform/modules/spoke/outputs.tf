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

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "vm_app_name" {
  value = azurerm_windows_virtual_machine.app_vm.name
}

output "vm_db_name" {
  value = azurerm_windows_virtual_machine.db_vm.name
}

output "storage_account_name" {
  value = azurerm_storage_account.demo.name
}

output "vm_app_admin_password" {
  value     = random_password.app_admin_password.result
  sensitive = true
}

output "vm_db_admin_password" {
  value     = random_password.db_admin_password.result
  sensitive = true
}
