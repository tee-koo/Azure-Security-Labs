variable "resource_group_name" {
  description = "Name of the resource group used by this lab"
  type        = string
  default     = "rg-hub-spoke-lab"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Sweden Central"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    environment = "lab"
    managed_by  = "terraform"
    purpose     = "azure-network-security-learning"
  }
}

variable "bastion_subnet_prefix" {
  description = "Address prefix reserved for AzureBastionSubnet; keep in sync with the Hub module"
  type        = string
  default     = "10.100.100.64/26"
}

variable "allowed_outbound_fqdns" {
  description = "FQDNs allowed for outbound HTTP/HTTPS through Azure Firewall. Customize for the workloads."
  type        = list(string)
  default     = ["www.microsoft.com"]

  validation {
    condition     = length(var.allowed_outbound_fqdns) > 0
    error_message = "At least one outbound FQDN must be provided."
  }
}
