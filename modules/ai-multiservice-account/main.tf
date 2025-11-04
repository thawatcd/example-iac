resource "azurerm_cognitive_account" "this" {
  name                = "cog${var.project_name}${var.env}${format("%03d", var.running_number)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "CognitiveServices"
  sku_name            = var.sku

  tags = {
    project = var.project_name
    env     = var.env
  }
}
