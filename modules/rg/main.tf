resource "azurerm_resource_group" "default" {
  name     = var.rg_name
  location = var.location
  }