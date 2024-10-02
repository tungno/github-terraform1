

# 0 random generated key
resource "random_string" "random_string" {
  length  = 10
  special = false
  upper   = false
}

# 1. resource group
resource "azurerm_resource_group" "tn-rg-backend" {
  name     = var.rg_name
  location = var.rg_location
}

# 2. storage account
resource "azurerm_storage_account" "tn_sa_web" {
  name                     = "${lower(var.sa_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.tn-rg-backend.name
  location                 = azurerm_resource_group.tn-rg-backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.index_document
  }
}

# Add a index.html file to the storage account
resource "azurerm_storage_blob" "index_html" {
  name                   = var.index_document
  storage_account_name   = azurerm_storage_account.tn_sa_web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = var.source_content
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.tn_sa_web.primary_web_endpoint
}