output "firewall_public_ip" {
  value       = module.hub.firewall_public_ip
  description = "Julk. IP – tämä näkyy curl ifconfig.me -komennossa!"
}

output "bastion_name" {
  value = module.hub.bastion_name
}

output "vm_app_name" {
  value = module.spoke.vm_app_name
}

output "vm_db_name" {
  value = module.spoke.vm_db_name
}

output "vm_admin_password" {
  value     = module.spoke.vm_admin_password
  sensitive = true
}
