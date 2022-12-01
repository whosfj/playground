# Deploys a Resource Group.
module "resource_group" {
  source = "../resource_group"
  count  = var.deploy_resource_group == true ? 1 : 0

  name = var.name
}

# Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied.
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.name}"
  resource_group_name = var.deploy_resource_group == true ? module.resource_group[0].name : var.resource_group_name
  location            = var.location

  dynamic "security_rule" {
    for_each = var.security_rules
    
    content {
      name                                       = "nsgsr-${each.key}-${var.name}"
      description                                = each.value.description
      protocol                                   = each.value.protocol == "Tcp" ? "Tcp" : each.value.protocol == "Udp" ? "Udp" : each.value.protocol == "Icmp" ? "Icmp" : each.value.protocol == "Esp" ? "Esp" : each.value.protocol == "Ah" ? "Ah" : each.value.protocol == "*" ? "*" : null
      source_port_range                          = each.value.source_port_ranges == null && each.value.source_port_range >= "0" && each.value.source_port_range <= "65535" || each.value.source_port_range == "*" ? each.value.source_port_range : null
      source_port_ranges                         = each.value.source_port_range == null ? each.value.source_port_ranges : null
      destination_port_range                     = each.value.destination_port_ranges == null && each.value.destination_port_range >= "0" && each.value.destination_port_range <= "65535" || each.value.destination_port_range == "*" ? each.value.destination_port_range : null
      destination_port_ranges                    = each.value.destination_port_range == null ? each.value.destination_port_ranges : null
      source_address_prefix                      = each.value.source_address_prefixes == null ? each.value.source_address_prefix : null
      source_address_prefixes                    = each.value.source_address_prefix == null ? each.value.source_address_prefixes : null
      source_application_security_group_ids      = each.value.source_application_security_group_ids
      destination_address_prefix                 = each.value.destination_address_prefixes == null ? each.value.destination_address_prefix : null
      destination_address_prefixes               = each.value.destination_address_prefix == null ? each.value.destination_address_prefixes : null
      destination_application_security_group_ids = each.value.destination_application_security_group_ids
      access                                     = each.value.access == "Allow" ? "Allow" : each.value.access == "Deny" ? "Deny" : null
      priority                                   = each.value.priority >= 100 && each.value.priority <= 4096 ? each.value.priority : null
      direction                                  = each.value.direction == "Inbound" ? "Inbound" : each.value.direction == "Outbound" ? "Outbound" : null
    }
  }

  tags = var.tags
}
