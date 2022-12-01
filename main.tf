# Deploys a Resource Group.
module "resource_group" {
  source = "./modules/resource_group"

  name = local.name
}

# Deploys a Public IP Address.
module "public_ip" {
  source = "./modules/public_ip"

  name                = local.name
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Deploys a Virtual Network.
module "virtual_network" {
  source = "./modules/virtual_network"

  name                = local.name
  resource_group_name = module.resource_group.name
  address_space       = ["10.255.254.0/23"]
}
