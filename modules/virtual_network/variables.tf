# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "deploy_resource_group" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether to deploy a Resource Group. Defaults to false."
}

variable "deploy_network_security_group" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether to deploy a Network Security Group. Defaults to false."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "(Required) The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "address_space" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
}

variable "bgp_community" {
  type        = string
  default     = null
  description = "(Optional) The BGP community attribute in format <as-number>:<community-value>."
}

variable "ddos_protection_plans" {
  type = map(object({
    ddos_protection_plan_enable = string
  }))
  default     = {}
  description = "(Optional) Can be specified to define the ID of DDoS Protection Plan and Enable/disable DDoS Protection Plan on Virtual Network."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "(Optional) List of IP addresses of DNS servers."
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
}

variable "flow_timeout_in_minutes" {
  type    = number
  default = 4
  validation {
    condition     = var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30
    error_message = "The value of flow_timeout_in_minutes must be between 4 and 30."
  }
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
}

variable "subnets" {
  type = map(object({
    address_prefix = string
    security_group = string
  }))
  default     = {}
  description = "(Optional) Can be specified multiple times to define multiple subnets. Each subnet block supports fields documented below."
}

variable "tags" {
  type = object({
    ci          = string
    environment = string
  })
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}
