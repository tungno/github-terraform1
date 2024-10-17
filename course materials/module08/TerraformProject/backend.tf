terraform {
  backend "azurerm" {
    resource_group_name  = "rg-backend-tn3"
    storage_account_name = "sabeftstn3kx9neua2l7"
    container_name       = "tfstate-tn3"
    key                  = "terraform.tfstate"
  }
} 