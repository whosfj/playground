# Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
resource "azurerm_subnet" "snet" {

  name                 = "snet-${var.name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes

  // Optional attributes
  dynamic "delegation" {
    for_each = var.delegation

    content {
      name = delegation.key

      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation

        content {
          name = service_delegation.value.name

          // Optional attributes
          actions = service_delegation.value.actions != null ? service_delegation.value.actions : null
        }
      }
    }
  }

  private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  service_endpoints                             = var.service_endpoints
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
}
