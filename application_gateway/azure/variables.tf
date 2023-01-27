# Base Setup

variable "name" {
  type        = string
  description = "The name of the application gateway."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group this application gateway belongs to."
}

variable "location" {
  type        = string
  description = "The location of the application gateway."

  validation {
    condition = contains([
      "westeurope"
    ], var.location)
    error_message = "Application gateway location must match option from provided list."
  }
}

# SKU

variable "sku_name" {
  type        = string
  description = "The name of the SKU to use for the application gateway."

  validation {
    condition     = can(regex("^WAF.+$", var.sku_name))
    error_message = "SKU name must match the WAF prefix pattern."
  }
}

variable "sku_tier" {
  type        = string
  description = "The tier of the SKU to use for the application gateway."

  validation {
    condition     = can(regex("^WAF.+$", var.sku_tier))
    error_message = "SKU tier must match the WAF prefix pattern."
  }
}

# Firewall

variable "firewall" {
  type = object({
    firewall_policy_id                = string
    force_firewall_policy_association = optional(bool)
  })
  description = "An optional firewall policy to be attached and associated with the application gateway."
  default     = null
}


# Scale

variable "scale" {
  type = object({
    capacity     = optional(number)
    min_capacity = optional(number)
    max_capcaity = optional(number)
  })
  description = "Indicate whether the application gateway should have a static capacity or auto-scale."

  validation {
    condition     = var.scale.capacity != null || var.scale.min_capacity != null
    error_message = "Either scale capacity or min_capacity must be set."
  }
}

# Gateway Ip Configuration

variable "gateway_ip_configurations" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
  description = "A list of gateway ip configurations for the applicationg gateway."

  validation {
    condition     = length(var.gateway_ip_configuration) > 0
    error_message = "At least one gateway ip configuration must be provided."
  }
}

# Web Application Firewall

variable "waf_configuration" {
  type = object({
    firewall_mode    = string
    rule_set_version = string
  })
  description = "The web application firewall configuration for the application gateway."
}

# Frontend

variable "frontend_ip_configurations" {
  type = list(object({
    name                 = string
    subnet_id            = optional(string)
    private_ip_address   = optional(string)
    public_ip_address_id = optional(string)
  }))
  description = "A list of ip configurations used by http listeners to listen for frontend traffic."
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  description = "A list of ports used by http listeners to listen for frontend traffic."
}

variable "http_listeners" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    firewall_policy_id             = optional(string)
  }))
  description = "A list of http listeners used on the frontend of the application gateway."
}

# Backend

variable "backend_address_pools" {
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
  description = "A list of backend address pools used by the application gateway."
}

variable "backend_http_settings" {
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    affinity_cookie_name  = optional(string)
    port                  = number
  }))
  description = "A list of backend http settings used by the application gateway."

  validation {
    condition = ([for settings in var.backend_http_settings : (
      settings.cookie_based_affinity == "Enabled" ? settings.affinity_cookie_name != "" : true
    )])
    error_message = "An affinity cookie name must be provided when cookie based affinity is enabled."
  }
}

variable "url_path_maps" {
  type = list(object({
    name                               = string
    default_backend_address_pool_name  = optional(string)
    default_backend_http_settings_name = optional(string)
    path_rules = list(object({
      name                       = string
      paths                      = list(string)
      backend_address_pool_name  = optional(string)
      backend_http_settings_name = optional(string)
      firewall_policy_id         = optional(string)
    }))
  }))
  description = "A list of mappings between backend address pools, http settings, and path rules."
}

# Routing

variable "request_routing_rules" {
  type = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = optional(string)
    backend_http_settings_name = optional(string)
    url_path_map_name          = optional(string)
  }))
  description = "A list of request routing rules that match http listeners to backend address pools and settings, optionally via path rules."

  validation {
    condition = ([for rule in var.request_routing_rules : (
      rule.backend_address_pool_name == null || rule.url_path_map_name == null
    )])
    error_message = "Request routing rule cannot contain both a backend address pool and url path mapping."
  }
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this applicationg gateway."
  default     = null
}
