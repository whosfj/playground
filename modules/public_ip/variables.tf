# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created."
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "(Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created."
}

variable "allocation_method" {
  type = string
  validation {
    condition     = var.allocation_method == "Static" || var.allocation_method == "Dynamic"
    error_message = "The value of allocation_method must be Static or Dynamic."
  }
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in."
}

# Below variables are not supported by the module.
# variable "ddos_protection_mode" {
#   type    = string
#   default = "VirtualNetworkInherited"
#   validation {
#     condition     = var.ddos_protection_mode == "Disabled" || var.ddos_protection_mode == "Enabled" || var.ddos_protection_mode == "VirtualNetworkInherited"
#     error_message = "The value of ddos_protection_mode must be Disabled, Enabled or VirtualNetworkInherited."
#   }
#   description = "(Optional) The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited."
# }

# variable "ddos_protection_plan_id" {
#   type        = string
#   default     = null
#   description = "(Optional) The ID of DDoS protection plan associated with the public IP."
# }
# Above variables are not supported by the module.

variable "domain_name_label" {
  type        = string
  default     = null
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP should exist. Changing this forces a new Public IP to be created."
}

variable "idle_timeout_in_minutes" {
  type    = number
  default = 4
  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 30
    error_message = "idle_timeout_in_minutes must be between 4 and 30."
  }
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes."
}

variable "ip_tags" {
  type = object({
    ip_tag_type = string
    tag         = string
  })
  default     = null
  description = "(Optional) A mapping of IP tags to assign to the public IP."
}

variable "ip_version" {
  type        = string
  default     = null
  description = "(Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4."
}

variable "public_ip_prefix_id" {
  type        = string
  default     = null
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource."
}

variable "reverse_fqdn" {
  type        = string
  default     = null
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
}

variable "sku" {
  type    = string
  default = "Basic"
  validation {
    condition     = var.sku == "Basic" || var.sku == "Standard"
    error_message = "sku must be either Basic or Standard."
  }
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
}

variable "sku_tier" {
  type    = string
  default = "Regional"
  validation {
    condition     = var.sku_tier == "Regional" || var.sku_tier == "Global"
    error_message = "sku_tier must be either Regional or Global."
  }
  description = "(Optional) The SKU Tier that should be used for the Public IP. Possible values are Regional and Global. Defaults to Regional."
}

variable "tags" {
  type = object({
    ci          = string
    environment = string
  })
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}
