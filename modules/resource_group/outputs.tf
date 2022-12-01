# The following Attributes are exported:
output "id" {
  value       = azurerm_resource_group.rg.id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the Resource Group."
}
