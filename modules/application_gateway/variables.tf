# The following arguments are supported:
variable "name" {
  type        = string
  description = "(Required) The name of the Application Gateway. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "(Required/Optional) The name of the resource group in which to the Application Gateway should exist. Changing this forces a new resource to be created. Required if deploy_resource_group is false."
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "(Required) The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created."
}

variable "backend_address_pool" {
  type = map(object({
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
  description = "(Required) One or more backend_address_pool blocks as defined above."
}

variable "backend_http_settings" {
  type = map(object({
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    request_timeout                     = number
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    probe_name                          = optional(string)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    authentication_certificate          = optional(map(object({})))
    trusted_root_certificate_names      = optional(list(string))
    connection_draining = optional(map(object({
      enabled           = bool
      drain_timeout_sec = number
    })))
  }))
  description = "(Required) One or more backend_http_settings blocks as defined above."
}

variable "frontend_ip_configuration" {
  type = map(object({
    subnet_id                       = optional(string)
    private_ip_address              = optional(string)
    public_ip_address_id            = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
  }))
  description = "(Required) One or more frontend_ip_configuration blocks as defined above."
}

variable "frontend_port" {
  type = map(object({
    port = number
  }))
  description = "(Required) One or more frontend_port blocks as defined above."
}

variable "gateway_ip_configuration" {
  type = map(object({
    subnet_id = string
  }))
  description = "(Required) One or more gateway_ip_configuration blocks as defined above."
}

variable "http_listener" {
  type = map(object({
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
    custom_error_configuration = optional(map(object({
      status_code           = string
      custom_error_page_url = string
    })))
    firewall_policy_id = optional(string)
    ssl_profile_name   = optional(string)
  }))
  description = "(Required) One or more http_listener blocks as defined above."
}

variable "request_routing_rule" {
  type = map(object({
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
    priority                    = optional(number)
  }))
  description = "(Required) One or more request_routing_rule blocks as defined above."
}

variable "sku_name" {
  type = string
  validation {
    condition     = var.sku_name == "Standard_Small" || var.sku_name == "Standard_Medium" || var.sku_name == "Standard_Large" || var.sku_name == "WAF_Medium" || var.sku_name == "WAF_Large" || var.sku_name == "Standard_v2" || var.sku_name == "WAF_v2"
    error_message = "The value of sku_name must be one of the following: Standard_Small, Standard_Medium, Standard_Large, WAF_Medium, WAF_Large, Standard_v2, WAF_v2."
  }
  description = "(Required) The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
}

variable "sku_tier" {
  type = string
  validation {
    condition     = var.sku_tier == "Standard" || var.sku_tier == "WAF" || var.sku_tier == "Standard_v2" || var.sku_tier == "WAF_v2"
    error_message = "The value of sku_tier must be one of the following: Standard, WAF, Standard_v2, WAF_v2."
  }
  description = "(Required) The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2."
}

variable "sku_capacity" {
  type        = number
  description = "(Required/Optional) The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set."
}

variable "fips_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Is FIPS enabled on this Application Gateway?"
}

variable "global_request_buffering_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether Application Gateway's Request buffer is enabled. By default, both Request and Response buffers are enabled on your Application Gateway."
}

variable "global_response_buffering_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether Application Gateway's Response buffer is enabled. By default, both Request and Response buffers are enabled on your Application Gateway."
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Optional) Specifies the type of Managed Service Identity that should be configured on this Application Gateway. Only possible value is UserAssigned."
}

variable "identity_ids" {
  type        = list(string)
  default     = []
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Application Gateway."
}

variable "private_link_configuration" {
  type = map(object({
    ip_configuration = map(object({
      subnet_id                     = string
      private_ip_address_allocation = string
      primary                       = bool
      private_ip_address            = optional(string)
    }))
  }))
  default     = {}
  description = "(Optional) One or more private_link_configuration blocks as defined above."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "(Optional) Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created."
}

variable "trusted_client_certificate" {
  type = map(object({
    data = string
  }))
  default     = {}
  description = "(Optional) One or more trusted_client_certificate blocks as defined above."
}

variable "ssl_profile" {
  type = map(object({
    trusted_root_certificate_names = optional(string)
    verify_client_cert_issuer_dn   = optional(bool)
    ssl_policy = optional(map(object({
      disabled_protocols   = optional(list(string))
      policy_type          = optional(string)
      policy_name          = optional(string)
      cipher_suites        = optional(list(string))
      min_protocol_version = optional(string)
    })))
  }))
  default     = {}
  description = "(Optional) One or more ssl_profile blocks as defined above."
}

variable "authentication_certificate" {
  type = map(object({
    data = string
  }))
  default     = {}
  description = "(Optional) One or more authentication_certificate blocks as defined above."
}

variable "trusted_root_certificate" {
  type = map(object({
    data                = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default     = {}
  description = "(Optional) One or more trusted_root_certificate blocks as defined above."
}

variable "ssl_policy_disabled_protocols" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2."
}

variable "ssl_policy_policy_type" {
  type        = string
  default     = null
  description = "(Optional) The Type of the Policy. Possible values are Predefined and Custom."
}

variable "ssl_policy_policy_name" {
  type        = string
  default     = null
  description = "(Optional) The Name of the Policy e.g AppGwSslPolicy20170401S. Required if policy_type is set to Predefined. Possible values can change over time and are published here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview. Not compatible with disabled_protocols."
}

variable "ssl_policy_cipher_suites" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of Cipher Suites which should be enabled on this Application Gateway. Possible values can change over time and are published here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview."
}

variable "ssl_policy_min_protocol_version" {
  type        = string
  default     = null
  description = "(Optional) The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2."
}

variable "enable_http2" {
  type        = bool
  default     = false
  description = "(Optional) Is HTTP2 enabled on the application gateway resource? Defaults to false."
}

variable "force_firewall_policy_association" {
  type        = bool
  default     = null
  description = "(Optional) Is the Firewall Policy associated with the Application Gateway?"
}

variable "probe" {
  type = map(object({
    interval                                  = number
    name                                      = string
    protocol                                  = string
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    host                                      = optional(string)
    port                                      = optional(number)
    pick_host_name_from_backend_http_settings = optional(bool)
    match = optional(map(object({
      body        = string
      status_code = list(string)
    })))
    minimum_servers = optional(number)
  }))
  default     = {}
  description = "(Optional) One or more probe blocks as defined above."
}

variable "ssl_certificate" {
  type = map(object({
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default     = {}
  description = "(Optional) One or more ssl_certificate blocks as defined above."
}

variable "tags" {
  type = object({
    ci          = string
    environment = string
  })
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "url_path_map" {
  type = map(object({
    path_rule = map(object({
      paths                       = list(string)
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      firewall_policy_id          = optional(string)
    }))
    default_backend_address_pool_name   = optional(string)
    default_backend_http_settings_name  = optional(string)
    default_redirect_configuration_name = optional(string)
    default_rewrite_rule_set_name       = optional(string)
  }))
  default     = {}
  description = "(Optional) One or more url_path_map blocks as defined above."
}

variable "waf_configuration" {
  type = map(object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = string
    rule_set_version = string
    disabled_rule_group = optional(map(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    exclusion = optional(map(object({
      match_variable          = string
      selector_match_operator = optional(string)
      selector                = optional(string)
    })))
  }))
  default     = {}
  description = "(Optional) One Web Application Firewall configuration block as defined above."
}

variable "custom_error_configuration" {
  type = map(object({
    status_code           = string
    custom_error_page_url = string
  }))
  default     = {}
  description = "(Optional) One or more custom_error_configuration blocks as defined above."
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Web Application Firewall Policy."
}

variable "redirect_configuration" {
  type = map(object({
    redirect_type        = string
    target_listener_name = optional(string)
    target_url           = optional(string)
    include_path         = optional(bool)
    include_query_string = optional(bool)
  }))
  default     = {}
  description = "(Optional) One or more redirect_configuration blocks as defined above."
}

variable "autoscale_configuration" {
  type = map(object({
    min_capacity = number
    max_capacity = number
  }))
  default     = {}
  description = "(Optional) Minimum and maximum capacity for autoscaling. Accepted values are in the range 0 to 100 for min_capacity and 2 to 125 for max_capacity."
}

variable "rewrite_rule_set" {
  type = map(object({
    rewrite_rule = map(object({
      rule_sequence = number
      condition = optional(map(object({
        variable    = string
        pattern     = string
        ignore_case = optional(bool)
        negate      = optional(bool)
      })))
      request_header_configuration = optional(map(object({
        header_value = string
      })))
      response_header_configuration = optional(map(object({
        header_value = string
      })))
      url = optional(map(object({
        path         = optional(string)
        query_string = optional(string)
        components   = optional(string)
        reroute      = optional(string)
      })))
    }))
  }))
  default     = {}
  description = "(Optional) One or more rewrite_rule_set blocks as defined above. Only valid for v2 SKUs"
}
