# Deploys a Resource Group.
module "resource_group" {
  source = "../resource_group"
  count  = var.deploy_resource_group == true ? 1 : 0

  name = var.name
}

# Deploys a Network Security Group.
module "network_security_group" {
  source = "../network_security_group"
  count  = var.deploy_network_security_group == true ? 1 : 0

  name                = var.name
  resource_group_name = var.deploy_resource_group == true ? module.resource_group[0].name : var.resource_group_name
}

# Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}"
  resource_group_name = var.deploy_resource_group == true ? module.resource_group[0].name : var.resource_group_name
  location            = var.location
  address_space       = var.address_space

  bgp_community = var.bgp_community

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plans

    content {
      id     = each.key
      enable = each.key != null ? each.value.enable : null
    }
  }

  dns_servers             = var.dns_servers
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  dynamic "subnet" {
    for_each = var.subnets

    content {
      name           = each.key
      address_prefix = each.value.address_prefix
      security_group = var.deploy_network_security_group == true && each.value.security_group == null ? module.network_security_group[0].id : each.value.security_group
    }
  }

  tags = var.tags
}
