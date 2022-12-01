# Deploys a Resource Group.
module "resource_group" {
  source = "../resource_group"
  count  = var.deploy_resource_group == true ? 1 : 0

  name = var.name
}

# Manages a Public IP Address.
resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.name}"
  resource_group_name = var.deploy_resource_group == true ? module.resource_group[0].name : var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method

  zones                   = var.sku == "Standard" ? var.zones : null
  domain_name_label       = var.domain_name_label
  edge_zone               = var.edge_zone
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  ip_tags                 = var.ip_tags
  ip_version              = var.ip_version == "IPv6" && var.allocation_method == "Static" ? "IPv6" : "IPv4"
  public_ip_prefix_id     = var.public_ip_prefix_id
  reverse_fqdn            = var.reverse_fqdn
  sku                     = var.sku == "Standard" && var.allocation_method == "Static" ? "Standard" : "Basic"
  sku_tier                = var.sku_tier == "Global" && var.sku == "Standard" ? "Global" : "Regional"
  tags                    = var.tags
}
