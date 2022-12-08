# Manages an Application Gateway.
resource "azurerm_application_gateway" "agw" {
  name                = "agw-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool

    content {
      name = backend_address_pool.key

      // Optional attributes
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.key
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity == "Enabled" ? backend_http_settings.value.cookie_based_affinity : "Disabled" // Default value
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol == "Https" ? backend_http_settings.value.protocol : "Http"                                                             // Default value
      request_timeout       = backend_http_settings.value.request_timeout >= 1 && backend_http_settings.value.request_timeout <= 86400 ? backend_http_settings.value.request_timeout : 30 // Default value

      // Optional attributes
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      probe_name                          = backend_http_settings.value.probe_name
      host_name                           = backend_http_settings.value.pick_host_name_from_backend_address == true ? null : backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address

      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.authentication_certificate == null ? {} : backend_http_settings.value.authentication_certificate

        content {
          name = authentication_certificate.key
        }
      }

      trusted_root_certificate_names = backend_http_settings.value.trusted_root_certificate_names

      dynamic "connection_draining" {
        for_each = backend_http_settings.value.connection_draining == null ? {} : backend_http_settings.value.connection_draining

        content {
          enabled           = connection_draining.value.enabled == true ? connection_draining.value.enabled : false                  // Default value 
          drain_timeout_sec = connection_draining.value.drain_timeout_sec != null ? connection_draining.value.drain_timeout_sec : 30 // Default value
        }
      }
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration

    content {
      name = frontend_ip_configuration.key

      // Optional attributes
      subnet_id                       = frontend_ip_configuration.value.subnet_id
      private_ip_address              = frontend_ip_configuration.value.private_ip_address
      public_ip_address_id            = frontend_ip_configuration.value.public_ip_address_id
      private_ip_address_allocation   = frontend_ip_configuration.value.private_ip_address_allocation == "Static" ? frontend_ip_configuration.value.private_ip_address_allocation : "Dynamic" // Default value
      private_link_configuration_name = frontend_ip_configuration.value.private_link_configuration_name
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port

    content {
      name = frontend_port.key
      port = frontend_port.value.port
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration

    content {
      name      = gateway_ip_configuration.key
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener

    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol == "Https" ? http_listener.value.protocol : "Http" // Default value

      // Optional attributes
      host_name            = http_listener.value.host_names != null ? null : http_listener.value.host_name
      host_names           = http_listener.value.host_name != null ? null : http_listener.value.host_names
      require_sni          = http_listener.value.require_sni == true ? http_listener.value.require_sni : false // Default value
      ssl_certificate_name = http_listener.value.ssl_certificate_name

      dynamic "custom_error_configuration" {
        for_each = http_listener.value.custom_error_configuration == null ? {} : http_listener.value.custom_error_configuration

        content {
          status_code           = custom_error_configuration.value.status_code == "HttpStatus502" ? custom_error_configuration.value.status_code : "HttpStatus403" // Default value
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
        }
      }

      firewall_policy_id = http_listener.value.firewall_policy_id
      ssl_profile_name   = http_listener.value.ssl_profile_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule

    content {
      name               = request_routing_rule.key
      rule_type          = request_routing_rule.value.rule_type == "PathBasedRouting" ? request_routing_rule.value.rule_type : "Basic" // Default value
      http_listener_name = request_routing_rule.value.http_listener_name

      // Optional attributes
      backend_address_pool_name   = request_routing_rule.value.redirect_configuration_name == null && request_routing_rule.value.rule_type == "Basic" ? request_routing_rule.value.backend_address_pool_name : null
      backend_http_settings_name  = request_routing_rule.value.redirect_configuration_name == null && request_routing_rule.value.rule_type == "Basic" ? request_routing_rule.value.backend_http_settings_name : null
      redirect_configuration_name = request_routing_rule.value.backend_address_pool_name == null && request_routing_rule.value.backend_http_settings_name == null && request_routing_rule.value.rule_type == "Basic" ? request_routing_rule.value.redirect_configuration_name : null
      rewrite_rule_set_name       = request_routing_rule.value.rule_type == "Basic" && var.sku_name == "Standard_v2" || var.sku_name == "WAF_v2" ? request_routing_rule.value.rewrite_rule_set_name : null
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      priority                    = request_routing_rule.value.priority
    }
  }

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.autoscale_configuration_min_capacity == null && var.autoscale_configuration_max_capacity == null ? null : var.sku_capacity
  }

  // Optional attributes
  fips_enabled = var.fips_enabled

  global {
    request_buffering_enabled  = var.global_request_buffering_enabled
    response_buffering_enabled = var.global_response_buffering_enabled
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  dynamic "private_link_configuration" {
    for_each = var.private_link_configuration

    content {
      name = private_link_configuration.key

      dynamic "ip_configuration" {
        for_each = private_link_configuration.value.ip_configuration

        content {
          name                          = ip_configuration.key
          subnet_id                     = ip_configuration.value.subnet_id
          private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation == "Static" ? ip_configuration.value.private_ip_address_allocation : "Dynamic" // Default value
          primary                       = ip_configuration.value.primary

          // Optional attributes
          private_ip_address = ip_configuration.value.private_ip_address
        }
      }
    }
  }

  zones = var.zones

  dynamic "trusted_client_certificate" {
    for_each = var.trusted_client_certificate

    content {
      name = trusted_client_certificate.key
      data = trusted_client_certificate.value.data
    }
  }

  dynamic "ssl_profile" {
    for_each = var.ssl_profile

    content {
      name = ssl_profile.key

      // Optional attributes
      trusted_client_certificate_names = ssl_profile.value.trusted_client_certificate_names
      verify_client_cert_issuer_dn     = ssl_profile.value.verify_client_cert_issuer_dn == true ? ssl_profile.value.verify_client_cert_issuer_dn : false // Default value

      dynamic "ssl_policy" {
        for_each = ssl_profile.value.ssl_policy

        content {
          disabled_protocols   = ssl_policy.value.policy_type == null && ssl_policy.value.policy_name == null && ssl_policy.value.disabled_protocols == "TLSv1_0" || ssl_policy.value.disabled_protocols == "TLSv1_1" || ssl_policy.value.disabled_protocols == "TLSv1_2" ? ssl_policy.value.disabled_protocols : null
          policy_type          = ssl_policy.value.disabled_protocols == null && ssl_policy.value.policy_type == "Predefined" || ssl_policy.value.policy_type == "Custom" ? ssl_policy.value.policy_type : null
          policy_name          = ssl_policy.value.disabled_protocols == null && ssl_policy.value.policy_type == "Predefined" ? ssl_policy.value.policy_name : null
          cipher_suites        = ssl_policy.value.disabled_protocols == null && ssl_policy.value.policy_type == "Custom" ? ssl_policy.value.cipher_suites : null
          min_protocol_version = ssl_policy.value.disabled_protocols == null && ssl_policy.value.policy_type == "Custom" && ssl_policy.value.min_protocol_version == "TLSv1_0" || ssl_policy.value.min_protocol_version == "TLSv1_1" || ssl_policy.value.min_protocol_version == "TLSv1_2" ? ssl_policy.value.min_protocol_version : null
        }
      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificate

    content {
      name = authentication_certificate.key
      data = authentication_certificate.value.data
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificate

    content {
      name = trusted_root_certificate.key

      // Optional attributes
      data                = trusted_root_certificate.value.data
      key_vault_secret_id = trusted_root_certificate.value.key_vault_secret_id
    }
  }

  ssl_policy {
    disabled_protocols   = var.ssl_policy_policy_type == null && var.ssl_policy_policy_name == null ? var.ssl_policy_disabled_protocols : null
    policy_type          = var.ssl_policy_disabled_protocols == null ? var.ssl_policy_policy_type : null
    policy_name          = var.ssl_policy_disabled_protocols == null ? var.ssl_policy_policy_name : null
    cipher_suites        = var.ssl_policy_cipher_suites
    min_protocol_version = var.ssl_policy_min_protocol_version
  }

  enable_http2                      = var.enable_http2
  force_firewall_policy_association = var.force_firewall_policy_association

  dynamic "probe" {
    for_each = var.probe

    content {
      interval            = probe.value.interval != null ? probe.value.interval : 1 // Default value
      name                = probe.key
      protocol            = probe.value.protocol == "Https" ? probe.value.protocol : "Http" // Default value
      path                = probe.value.path
      timeout             = probe.value.timeout != null ? probe.value.timeout : 1                         // Default value
      unhealthy_threshold = probe.value.unhealthy_threshold != null ? probe.value.unhealthy_threshold : 1 // Default value

      // Optional attributes
      host                                      = probe.value.pick_host_name_from_backend_http_settings != null ? null : probe.value.host
      port                                      = var.sku_name == "Standard_v2" || var.sku_name == "WAF_v2" && probe.value.port != null ? probe.value.port : backend_http_settings.value.port // Default value
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings

      dynamic "match" {
        for_each = probe.value.match

        content {
          body        = match.value.body
          status_code = match.value.status_code
        }
      }

      minimum_servers = probe.value.minimum_servers
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate

    content {
      name = ssl_certificate.key

      // Optional attributes
      data                = ssl_certificate.value.data
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  tags = var.tags

  dynamic "url_path_map" {
    for_each = var.url_path_map

    content {
      name = url_path_map.key

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule

        content {
          name  = path_rule.key
          paths = path_rule.value.paths

          // Optional attributes
          backend_address_pool_name   = path_rule.value.redirect_configuration_name == null ? path_rule.value.backend_address_pool_name : null
          backend_http_settings_name  = path_rule.value.redirect_configuration_name == null ? path_rule.value.backend_http_settings_name : null
          redirect_configuration_name = path_rule.value.backend_address_pool_name == null && path_rule.value.backend_http_settings_name == null ? path_rule.value.redirect_configuration_name : null
          rewrite_rule_set_name       = var.sku_name == "Standard_v2" || var.sku_name == "WAF_v2" ? path_rule.value.rewrite_rule_set_name : null
          firewall_policy_id          = path_rule.value.firewall_policy_id
        }
      }

      // Optional attributes
      default_backend_address_pool_name   = url_path_map.value.default_redirect_configuration_name == null ? url_path_map.value.default_backend_address_pool_name : null
      default_backend_http_settings_name  = url_path_map.value.default_redirect_configuration_name == null ? url_path_map.value.default_backend_http_settings_name : null
      default_redirect_configuration_name = url_path_map.value.default_backend_address_pool_name == null && url_path_map.value.default_backend_http_settings_name == null ? url_path_map.value.default_redirect_configuration_name : null
      default_rewrite_rule_set_name       = var.sku_name == "Standard_v2" || var.sku_name == "WAF_v2" ? url_path_map.value.default_rewrite_rule_set_name : null
    }
  }

  waf_configuration {
    enabled          = var.waf_configuration_enabled
    firewall_mode    = var.waf_configuration_firewall_mode
    rule_set_type    = var.waf_configuration_rule_set_type
    rule_set_version = var.waf_configuration_rule_set_version

    // Optional attributes
    dynamic "disabled_rule_group" {
      for_each = var.waf_configuration_disabled_rule_group

      content {
        rule_group_name = waf_configuration_disabled_rule_group.value.rule_group_name
        rules           = waf_configuration_disabled_rule_group.value.rules
      }
    }

    file_upload_limit_mb     = var.waf_configuration_file_upload_limit_mb
    request_body_check       = var.waf_configuration_request_body_check
    max_request_body_size_kb = var.waf_configuration_max_request_body_size_kb

    dynamic "exclusion" {
      for_each = var.waf_configuration_exclusion

      content {
        match_variable          = waf_configuration_exclusion.value.match_variable == "RequestArgKeys" || waf_configuration_exclusion.value.match_variable == "RequestArgNames" || waf_configuration_exclusion.value.match_variable == "RequestArgValues" || waf_configuration_exclusion.value.match_variable == "RequestCookieKeys" || waf_configuration_exclusion.value.match_variable == "RequestCookieNames" || waf_configuration_exclusion.value.match_variable == "RequestCookieValues" || waf_configuration_exclusion.value.match_variable == "RequestHeaderKeys" || waf_configuration_exclusion.value.match_variable == "RequestHeaderNames" || waf_configuration_exclusion.value.match_variable == "RequestHeaderValues" ? waf_configuration_exclusion.value.match_variable : null
        selector_match_operator = waf_configuration_exclusion.value.selector_match_operator == "Contains" || waf_configuration_exclusion.value.selector_match_operator == "EndsWith" || waf_configuration_exclusion.value.selector_match_operator == "Equals" || waf_configuration_exclusion.value.selector_match_operator == "EqualsAny" || waf_configuration_exclusion.value.selector_match_operator == "StartsWith" ? waf_configuration_exclusion.value.selector_match_operator : null
        selector                = waf_configuration_exclusion.value.selector
      }
    }
  }

  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration

    content {
      status_code           = custom_error_configuration.value.status_code == "HttpStatus502" ? custom_error_configuration.value.status_code : "HttpStatus403" // Default value
      custom_error_page_url = custom_error_configuration.value.custom_error_page_url
    }
  }

  firewall_policy_id = var.firewall_policy_id

  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration

    content {
      name          = redirect_configuration.key
      redirect_type = redirect_configuration.value.redirect_type == "Permanent" || redirect_configuration.value.redirect_type == "Temporary" || redirect_configuration.value.redirect_type == "Found" || redirect_configuration.value.redirect_type == "SeeOther" ? redirect_configuration.value.redirect_type : null

      // Optional attributes
      target_listener_name = redirect_configuration.value.target_url == null ? redirect_configuration.value.target_listener_name : null
      target_url           = redirect_configuration.value.target_listener_name == null ? redirect_configuration.value.target_url : null
      include_path         = redirect_configuration.value.include_path == true ? redirect_configuration.value.include_path : false                 // Default value
      include_query_string = redirect_configuration.value.include_query_string == true ? redirect_configuration.value.include_query_string : false // Default value
    }
  }

  autoscale_configuration {
    min_capacity = var.autoscale_configuration_min_capacity
    max_capacity = var.autoscale_configuration_max_capacity
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_set

    content {
      name = rewrite_rule_set.key

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rule

        content {
          name          = rewrite_rule.key
          rule_sequence = rewrite_rule.value.rule_sequence

          // Optional attributes
          dynamic "condition" {
            for_each = rewrite_rule.value.condition

            content {
              variable = condition.value.variable
              pattern  = condition.value.pattern

              // Optional attributes
              ignore_case = condition.value.ignore_case == true ? condition.value.ignore_case : false // Default value
              negate      = condition.value.negate == true ? condition.value.negate : false           // Default value
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configuration

            content {
              header_name  = request_header_configuration.key
              header_value = request_header_configuration.value.header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configuration

            content {
              header_name  = response_header_configuration.key
              header_value = response_header_configuration.value.header_value
            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value.url

            content {
              // Optional attributes
              path         = url.value.path
              query_string = url.value.query_string
              components   = url.value.components
              reroute      = url.value.reroute
            }
          }
        }
      }
    }
  }
}
