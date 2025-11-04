// Example composition: provisions a resource group using modules/resource
// NOTE: This example expects the `modules/resource` module to be implemented.
// The module path is referenced relatively for local development (replace with a versioned
// source when publishing).

module "resource" {
  source = "../../modules/resource"

  project_name   = var.project_name
  env            = var.env
  running_number = var.running_number
}

module "storage_account" {
  source = "../../modules/storage-account"

  resource_group_name = module.resource.resource_name
  project_name        = var.project_name
  env                 = var.env
  running_number      = var.running_number
}

module "ai_account" {
  source = "../../modules/ai-multiservice-account"

  resource_group_name = module.resource.resource_name
  project_name        = var.project_name
  env                 = var.env
  running_number      = var.running_number
}

module "search_service" {
  source = "../../modules/cognitive-search"

  resource_group_name = module.resource.resource_name
  project_name        = var.project_name
  env                 = var.env
  running_number      = var.running_number
}

