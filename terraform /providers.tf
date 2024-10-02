terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-backend-tn3"
    storage_account_name = "sabeftstn3kx9neua2l7"
    container_name       = "tfstate-tn3"
    key                  = "rg.terraform.tfstate-tn3"
  }
}


provider "azurerm" {
  subscription_id = "8fe266af-9a8d-40b0-bcb6-08d23e112c60"
  features {
  }
}