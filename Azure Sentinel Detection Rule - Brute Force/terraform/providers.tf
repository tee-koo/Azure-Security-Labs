terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "e3f5904d-b551-4e68-b266-c9d6f003ad9d"
  features {}
}
