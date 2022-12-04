# Deploys a Resource Group.
module "resource_group" {
  source = "../resource_group"
  count  = var.deploy_resource_group == true ? 1 : 0

  name = var.name
}

# Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}"
  resource_group_name = var.deploy_resource_group == true ? module.resource_group[0].name : var.resource_group_name
  address_space       = var.address_space
  location            = var.location

  // Optional attributes
  bgp_community = var.bgp_community

  dynamic "ddos_protection_plan" {
    for_each = var.deploy_ddos_protection_plan == true ? [1] : []

    content {
      id     = var.ddos_protection_plan_id
      enable = var.ddos_protection_plan_id != null ? var.ddos_protection_plan_enable : null
    }
  }

  dns_servers             = var.dns_servers
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  tags                    = var.tags
}
