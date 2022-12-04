# Manages a Public IP Address.
resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method

  // Optional attributes
  zones = var.sku == "Standard" ? var.zones : null
  # ddos_protection_mode    = var.ddos_protection_mode
  # ddos_protection_plan_id = var.ddos_protection_mode == "Enabled" ? var.ddos_protection_plan_id : null
  domain_name_label       = var.domain_name_label
  edge_zone               = var.edge_zone
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  ip_tags                 = var.ip_tags
  ip_version              = var.ip_version == "IPv6" && var.allocation_method == "Static" ? var.ip_version : "IPv4"
  public_ip_prefix_id     = var.public_ip_prefix_id
  reverse_fqdn            = var.reverse_fqdn
  sku                     = var.sku == "Standard" && var.allocation_method == "Static" ? var.sku : "Basic"
  sku_tier                = var.sku_tier == "Global" && var.sku == "Standard" ? var.sku_tier : "Regional"
  tags                    = var.tags
}
