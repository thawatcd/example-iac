resource "azurerm_storage_account" "this" {
  name                     = lower("st${var.project_name}${var.env}${format("%03d", var.running_number)}")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    project = var.project_name
    env     = var.env
  }
}
