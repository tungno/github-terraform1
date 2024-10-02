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
    key                  = "backend.terraform.tfstate-tn3"
  }
}


provider "azurerm" {
  subscription_id = "8fe266af-9a8d-40b0-bcb6-08d23e112c60"
  tenant_id       = "06fec4e0-87df-4f76-894d-7c5595a731bd"
  client_id       = "c653048c-5743-4557-8e00-0e92230a3a14"
  client_secret   = "Ssi8Q~rA4zEm_5AH~Bf1pMx60ut8ehcdErTiBdan"
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# 0 random generated key
resource "random_string" "random_string" {
  length  = 10
  special = false
  upper   = false
}

# 1. resource group
resource "azurerm_resource_group" "tn-rg-backend" {
  name     = var.rg_backend_name
  location = var.rg_backend_location
}

# 2. storage account
resource "azurerm_storage_account" "tn_sa_backend" {
  name                     = "${lower(var.sa_backend_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.tn-rg-backend.name
  location                 = azurerm_resource_group.tn-rg-backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 3. storage container
resource "azurerm_storage_container" "name" {
  name                  = var.sc_backend_name
  storage_account_name  = azurerm_storage_account.tn_sa_backend.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}
# 4. key-vault 
resource "azurerm_key_vault" "tn_kv_backend" {
  name                        = "${lower(var.kv_backend_name)}${random_string.random_string.result}"
  location                    = azurerm_resource_group.tn-rg-backend.location
  resource_group_name         = azurerm_resource_group.tn-rg-backend.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore",
    ]

    storage_permissions = [
      "Get", "List", "Set", "Delete",
    ]
  }
}

resource "azurerm_key_vault_secret" "tn_sa_backend_accesskey" {
  name         = var.sa_backend_accesskey_name
  value        = azurerm_storage_account.tn_sa_backend.primary_access_key
  key_vault_id = azurerm_key_vault.tn_kv_backend.id
}
