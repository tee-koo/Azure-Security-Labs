terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.53.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "xxxx-xxxx-xxxx-xxxx-xxxx"
  features {}

}
