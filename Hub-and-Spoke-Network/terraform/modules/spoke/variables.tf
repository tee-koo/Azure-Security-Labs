variable "resource_group_name" {
  description = "Resource group for Spoke resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}

variable "private_dns_zone_id" {
  description = "Resource ID of the Blob Private DNS zone"
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "CIDR prefix of AzureBastionSubnet, used to scope VM management access"
  type        = string
}
