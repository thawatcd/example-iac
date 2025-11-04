output "storage_account_name" {
  description = "The name of the storage account created by this module"
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "The id of the storage account created by this module"
  value       = azurerm_storage_account.this.id
}
