# The following Attributes are exported:
output "id" {
  value       = azurerm_subnet.snet.id
  description = "The subnet ID."
}

output "name" {
  value       = azurerm_subnet.snet.name
  description = "The name of the subnet."
}

output "resource_group_name" {
  value       = azurerm_subnet.snet.resource_group_name
  description = "The name of the resource group in which the subnet is created."
}

output "virtual_network_name" {
  value       = azurerm_subnet.snet.virtual_network_name
  description = "The name of the virtual network in which the subnet is created."
}

output "address_prefixes" {
  value       = azurerm_subnet.snet.address_prefixes
  description = "The address prefixes of the subnet."
}
