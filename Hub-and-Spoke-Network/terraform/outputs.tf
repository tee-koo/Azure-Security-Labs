output "firewall_public_ip" {
  description = "Public IP address assigned to Azure Firewall"
  value       = module.hub.firewall_public_ip
}

output "bastion_name" {
  description = "Azure Bastion resource name"
  value       = module.hub.bastion_name
}

output "vm_app_name" {
  description = "Application VM name"
  value       = module.spoke.vm_app_name
}

output "vm_db_name" {
  description = "Database VM name"
  value       = module.spoke.vm_db_name
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = module.spoke.storage_account_name
}

output "blob_private_dns_zone_name" {
  description = "Private DNS zone used by the Blob Private Endpoint"
  value       = azurerm_private_dns_zone.blob.name
}

output "vm_app_admin_password" {
  description = "Generated local administrator password for the application VM"
  value       = module.spoke.vm_app_admin_password
  sensitive   = true
}

output "vm_db_admin_password" {
  description = "Generated local administrator password for the database VM"
  value       = module.spoke.vm_db_admin_password
  sensitive   = true
}
