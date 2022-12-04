# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  type = list(string)
  validation {
    condition     = length(var.address_prefixes) <= 1
    error_message = "Currently only a single address prefix can be set as the Multiple Subnet Address Prefixes Feature is not yet in public preview or general availability."
  }
  description = "(Required) The address prefixes to use for the subnet."
}

variable "delegation" {
  type = map(object({
    service_delegation = set(object({
      name    = string
      actions = list(string)
    }))
  }))
  default     = {}
  description = "(Optional) One or more delegation blocks as defined below."
}

variable "private_endpoint_network_policies_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
}

variable "service_endpoints" {
  type        = list(string)
  default     = null
  description = "(Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web."
}

variable "service_endpoint_policy_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
}
