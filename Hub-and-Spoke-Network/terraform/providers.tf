terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Authentication and subscription context are supplied through the Azure CLI
# and ARM_* environment variables. Do not hardcode subscription IDs or secrets.
provider "azurerm" {
  features {}
}

provider "random" {}
