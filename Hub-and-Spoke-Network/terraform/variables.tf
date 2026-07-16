variable "resource_group_name" {
  description = "Name of the shared resource group"
  type        = string
  default     = "rg-hub-spoke"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Sweden Central"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    owner   = "tee-koo"
    user    = "tee-koo"
    expiry  = "2026-12-31"
  }
}
