# Manages a Resource Group.
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}"
  location = var.location

  tags = var.tags
}
