# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created."
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
}

variable "tags" {
  type = object({
    ci          = string
    environment = string
    owner       = string
    costcenter  = string
  })
  default     = null
  description = "(Optional) A mapping of tags which should be assigned to the Resource Group."
}
