resource "azurerm_application_gateway" "application_gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.scale.capacity
  }

  dynamic "autoscale_configuration" {
    for_each = var.scale.min_capacity == null ? [] : [1]

    content {
      min_capacity = var.scale.min_capacity
      max_capacity = var.scale.max_capcaity
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations

    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  # Firewall

  firewall_policy_id                = var.firewall.firewall_policy_id
  force_firewall_policy_association = var.firewall.force_firewall_policy_association

  waf_configuration {
    enabled          = true
    firewall_mode    = var.firewall.firewall_mode
    rule_set_version = var.firewall.rule_set_version

    dynamic "disabled_rule_group" {
      for_each = coalesce(var.firewall.disabled_rule_groups, [])

      content {
        rule_group_name = disabled_rule_group.value.rule_group_name
        rules           = disabled_rule_group.value.rules
      }
    }

    dynamic "exclusion" {
      for_each = coalesce(var.firewall.exclusions, [])

      content {
        match_variable          = exclusion.value.match_variable
        selector                = exclusion.value.selector
        selector_match_operator = exclusion.value.selector_match_operator
      }
    }
  }

  # Frontend

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name                 = frontend_ip_configuration.value.name
      subnet_id            = frontend_ip_configuration.value.subnet_id
      private_ip_address   = frontend_ip_configuration.value.private_ip_address
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      firewall_policy_id             = http_listener.value.firewall_policy_id
    }
  }

  # Backend

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools

    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name  = backend_http_settings.value.affinity_cookie_name
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps

    content {
      name                               = url_path_map.value.name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules

        content {
          name                       = path_rule.value.name
          paths                      = path_rule.value.paths
          backend_address_pool_name  = path_rule.value.backend_address_pool_name
          backend_http_settings_name = path_rule.value.backend_http_settings_name
          firewall_policy_id         = path_rule.value.firewall_policy_id
        }
      }
    }
  }

  # Routing

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      url_path_map_name          = request_routing_rule.value.url_path_map_name
    }
  }

  tags = var.tags
}
