locals {
  running_str = format("%03d", var.running_number)
  cloud_tag   = "az"
  project_norm = lower(replace(trimspace(var.project_name), " ", "-"))
  env_norm     = lower(trimspace(var.env))
  resource_name = "rg-${local.project_norm}-${local.cloud_tag}-${local.env_norm}-${local.running_str}"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_name
  location = var.location

  tags = {
    project     = var.project_name
    environment = var.env
  }
}
