output "cognitive_account_name" {
  description = "The name of the cognitive services account created by this module"
  value       = azurerm_cognitive_account.this.name
}

output "cognitive_account_id" {
  description = "The id of the cognitive services account created by this module"
  value       = azurerm_cognitive_account.this.id
}
