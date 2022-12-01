# The following Attributes are exported:
output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The virtual NetworkConfiguration ID."
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}

output "resource_group_name" {
  value       = azurerm_virtual_network.vnet.resource_group_name
  description = "The name of the resource group in which to create the virtual network."
}

output "location" {
  value       = azurerm_virtual_network.vnet.location
  description = "The location/region where the virtual network is created."
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "The list of address spaces used by the virtual network."
}

output "guid" {
  value       = azurerm_virtual_network.vnet.guid
  description = "The GUID of the virtual network."
}

output "subnet_ids" {
  value = tomap({
    for id, subnet in azurerm_virtual_network.vnet.subnet : id => subnet.id
  })
  description = "A list of subnet IDs."
}
