resource "azurerm_search_service" "this" {
  name                = "search${var.project_name}${var.env}${format("%03d", var.running_number)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  partition_count     = 1
}
