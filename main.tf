# # Deploys a Resource Group.
# module "resource_group" {
#   source = "./modules/resource_group"

#   name = local.name
# }

# # Deploys a Virtual Network.
# module "virtual_network" {
#   source = "./modules/virtual_network"

#   name                = local.name
#   resource_group_name = module.resource_group.name
#   address_space       = ["10.255.254.0/23"]
# }

# # Deploys a Subnet(s).
# module "subnet" {
#   source   = "./modules/subnet"
#   for_each = local.subnets

#   name                 = each.key
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.virtual_network.name

#   address_prefixes = each.value.address_prefixes
# }

# # Deploys a Public IP Address.
# module "public_ip" {
#   source = "./modules/public_ip"

#   name                = local.name
#   resource_group_name = module.resource_group.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# # Deploys a Application Gateway.
# module "application_gateway" {
#   source = "./modules/application_gateway"

#   name                = local.name
#   resource_group_name = module.resource_group.name

#   sku_name     = "Standard_Small"
#   sku_tier     = "Standard"
#   sku_capacity = 2

#   gateway_ip_configuration = {
#     "my-gateway-ip-configuration" = {
#       subnet_id = module.subnet["ApplicationGatewaySubnet"].id
#     }
#   }

#   frontend_port = {
#     "my-frontend-port" = {
#       port = 80
#     }
#   }

#   frontend_ip_configuration = {
#     "my-frontend-ip-configuration" = {
#       public_ip_address_id = module.public_ip.id
#     }
#   }

#   backend_address_pool = {
#     "my-backend-address-pool" = {}
#   }

#   backend_http_settings = {
#     "my-backend-http-settings" = {
#       cookie_based_affinity = "Disabled"
#       path                  = "/path1/"
#       port                  = 80
#       protocol              = "Http"
#       request_timeout       = 60
#     }
#   }

#   http_listener = {
#     "my-http-listener" = {
#       frontend_ip_configuration_name = "my-frontend-ip-configuration"
#       frontend_port_name             = "my-frontend-port"
#       protocol                       = "Http"
#     }
#   }

#   request_routing_rule = {
#     "my-request-routing-rule" = {
#       rule_type                  = "Basic"
#       http_listener_name         = "my-http-listener"
#       backend_address_pool_name  = "my-backend-address-pool"
#       backend_http_settings_name = "my-backend-http-settings"
#     }
#   }
# }
