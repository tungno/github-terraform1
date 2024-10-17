# List resources containing a specific string in the name
az resource list --query "[?contains(name, 'sa')]" --output table

# List resources of a specific type
az resource list --resource-type "Microsoft.Storage/storageAccounts" --output table

# Get the id of a specific resource
az resource show --resource-group rg-demo-tn-project-a --name sademo12364stn --resource-type "Microsoft.Storage/storageAccounts" --query id --output tsv
 => we get this: /subscriptions/8fe266af-9a8d-40b0-bcb6-08d23e112c60/resourceGroups/rg-demo-tn-project-a/providers/Microsoft.Storage/storageAccounts/sademo12364stn

# Creates a json file with the list of resources
az resource list --resource-group rg-demo-project-a --output json > resources.json

# to remove and move to project b
# Remove a resource from terraform state
terraform state list 
# we need to remove this one first 
terraform state rm module.storage.azurerm_storage_account.sa-demo 

# Move a resource to another resource group
az resource move --destination-group rg-demo-tn-project-b \
  --ids /subscriptions/8fe266af-9a8d-40b0-bcb6-08d23e112c60/resourceGroups/rg-demo-tn-project-a/providers/Microsoft.Storage/storageAccounts/sademo12364stn

