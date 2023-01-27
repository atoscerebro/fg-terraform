# Base Setup

variable "name" {
  type        = string
  description = "The name of the application gateway."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group the application gateway belongs to."
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

variable "sku" {
  type = object({
    name = string
    tier = string
  })
  description = "SKU configuration for the application gateway."

  validation {
    condition = alltrue([
      can(regex("^WAF.+$", var.sku.name)),
      can(regex("^WAF.*$", var.sku.tier))
    ])
    error_message = "SKU name and tier must match the WAF prefix pattern."
  }
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
    condition     = can(coalesce(var.scale.capacity, var.scale.min_capacity))
    error_message = "Either capacity or min_capacity must be set."
  }
}

# Firewall

variable "firewall" {
  type = object({
    firewall_policy_id                = optional(string)
    force_firewall_policy_association = optional(bool)
    firewall_mode                     = string
    rule_set_type                     = optional(string)
    rule_set_version                  = string
    disabled_rule_groups = optional(list(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    exclusions = optional(list(object({
      match_variable          = string
      selector                = optional(string)
      selector_match_operator = optional(string)
    })))
  })
  description = "The web application firewall configuration for the application gateway."
}

# Gateway Ip Configuration

variable "gateway_ip_configurations" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
  description = "A list of (at least one) gateway ip configurations for the application gateway."
}

# Frontend

variable "frontend_ip_configurations" {
  type = list(object({
    name                 = string
    subnet_id            = optional(string)
    private_ip_address   = optional(string)
    public_ip_address_id = optional(string)
  }))
  description = "A list of (at least one) ip configurations used by http listeners to listen for frontend traffic."
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  description = "A list of (at least one) ports used by http listeners to listen for frontend traffic."
}

variable "http_listeners" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    firewall_policy_id             = optional(string)
  }))
  description = "A list of (at least one) http listeners used on the frontend of the application gateway."
}

# Backend

variable "backend_address_pools" {
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
  description = "A list of (at least one) backend address pools used by the application gateway."
}

variable "backend_http_settings" {
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    affinity_cookie_name  = optional(string)
    protocol              = string
    port                  = number
  }))
  description = "A list of (at least one) backend http settings used by the application gateway."
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
  default     = []
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
  description = "A list of (at least one) request routing rules that match http listeners to backend address pools and settings, optionally via path rules."

  validation {
    condition = alltrue(([for rule in var.request_routing_rules : (
      (rule.backend_address_pool_name != null && rule.backend_http_settings_name != null && rule.url_path_map_name == null) ||
      (rule.backend_address_pool_name == null && rule.backend_http_settings_name == null && rule.url_path_map_name != null)
    )]))
    error_message = "Request routing rule must contain either a backend address pool and http settings, or an url path mapping."
  }
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this applicationg gateway."
  default     = null
}
