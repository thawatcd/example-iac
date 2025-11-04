output "resource_name" {
  description = "The name of the resource group created by this module"
  value       = azurerm_resource_group.this.name
}

output "resource_id" {
  description = "The id of the resource group created by this module"
  value       = azurerm_resource_group.this.id
}
