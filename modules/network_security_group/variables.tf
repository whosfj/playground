# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "deploy_resource_group" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether to deploy a Resource Group. Defaults to false."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "(Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created."
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "(Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created."
}

variable "security_rules" {
  type = map(object({
    description                                = string
    protocol                                   = string
    source_port_range                          = string
    source_port_ranges                         = list(string)
    destination_port_range                     = string
    destination_port_ranges                    = list(string)
    source_address_prefix                      = string
    source_address_prefixes                    = list(string)
    source_application_security_group_ids      = list(string)
    destination_address_prefix                 = string
    destination_address_prefixes               = list(string)
    destination_application_security_group_ids = list(string)
    access                                     = string
    priority                                   = number
    direction                                  = string
  }))
  default     = null
  description = "(Optional) List of objects representing security rules, as defined below"
}

variable "tags" {
  type = object({
    ci          = string
    environment = string
  })
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}
