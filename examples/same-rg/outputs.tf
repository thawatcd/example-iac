output "resource_group_name" {
  description = "Name of the resource group created for this example"
  value       = module.resource.resource_name
}

output "resource_group_id" {
  description = "ID of the resource group created for this example"
  value       = module.resource.resource_id
}

output "storage_account_name" {
  description = "Storage account name created by the storage module"
  value       = module.storage_account.storage_account_name
}

output "ai_account_name" {
  description = "Azure Cognitive multi-service account name"
  value       = module.ai_account.cognitive_account_name
}

output "search_service_name" {
  description = "Azure Cognitive Search service name"
  value       = module.search_service.search_service_name
}
