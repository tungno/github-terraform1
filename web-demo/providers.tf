terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3"
    }
  }
}


provider "azurerm" {
  subscription_id = "8fe266af-9a8d-40b0-bcb6-08d23e112c60"
  features {
  }
}