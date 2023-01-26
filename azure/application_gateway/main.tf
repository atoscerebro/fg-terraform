resource "azurerm_application_gateway" "application_gateway" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  firewall_policy_id                = var.firewall != null ? var.firewall.firewall_policy_id : null
  force_firewall_policy_association = var.firewall != null ? var.firewall.force_firewall_policy_association : null

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.scale.capacity
  }

  dynamic "autoscale_configuration" {
    for_each = var.scale.min_capacity ? tolist([1]) : tolist([])

    content {
      min_capacity = var.scale.min_capacity
      max_capcaity = var.scale.max_capcaity
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations

    content {
      name      = gateway_ip_configuration.name
      subnet_id = gateway_ip_configuration.subnet_id
    }
  }

  # Web Application Firewall

  waf_configuration {
    enabled          = true
    firewall_mode    = var.waf_configuration.firewall_mode
    rule_set_version = var.waf_configuration.rule_set_version
  }

  # Frontend

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name                 = frontend_ip_configuration.name
      subnet_id            = frontend_ip_configuration.subnet_id
      private_ip_address   = frontend_ip_configuration.private_ip_address
      public_ip_address_id = frontend_ip_configuration.public_ip_address_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports

    content {
      name = frontend_port.name
      port = frontend_port.port
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.name
      frontend_ip_configuration_name = http_listener.frontend_ip_configuration_name
      frontend_port_name             = http_listener.frontend_port_name
      firewall_policy_id             = http_listener.firewall_policy_id
    }
  }

  # Backend

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools

    content {
      name         = backend_address_pool.name
      fqdns        = backend_address_pool.fqdns
      ip_addresses = backend_address_pool.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.name
      cookie_based_affinity = backend_http_settings.cookie_based_affinity
      affinity_cookie_name  = backend_http_settings.affinity_cookie_name
      port                  = backend_http_settings.port
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps

    content {
      name                               = url_path_map.name
      default_backend_address_pool_name  = url_path_map.default_backend_address_pool_name
      default_backend_http_settings_name = url_path_map.default_backend_http_settings_name

      dynamic "path_rule" {
        for_each = url_path_map.path_rules

        content {
          name                       = path_rule.name
          paths                      = path_rule.paths
          backend_address_pool_name  = path_rule.backend_address_pool_name
          backend_http_settings_name = path_rule.backend_http_settings_name
          firewall_policy_id         = path_rule.firewall_policy_id
        }
      }
    }
  }

  # Routing

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                       = request_routing_rule.name
      rule_type                  = request_routing_rule.rule_type
      http_listener_name         = request_routing_rule.http_listener_name
      backend_address_pool_name  = request_routing_rule.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.backend_http_settings_name
      url_path_map_name          = request_routing_rule.url_path_map_name
    }
  }
}
