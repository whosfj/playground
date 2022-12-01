# The following Attributes are exported:
output "id" {
  value       = azurerm_public_ip.pip.id
  description = "The ID of this Public IP."
}

output "name" {
  value       = azurerm_public_ip.pip.name
  description = "The name of this Public IP."
}

output "ip_address" {
  value       = azurerm_public_ip.pip.ip_address
  description = "The IP address value that was allocated."
}

output "fqdn" {
  value       = var.domain_name_label != null ? azurerm_public_ip.pip.fqdn : null
  description = "Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone."
}
