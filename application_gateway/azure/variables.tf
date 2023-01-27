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
    condition     = var.scale.capacity != null || var.scale.min_capacity != null
    error_message = "Either scale capacity or min_capacity must be set."
  }
}

# Firewall

variable "firewall" {
  type = object({
    firewall_mode                     = string
    rule_set_version                  = optional(string)
    firewall_policy_id                = optional(string)
    force_firewall_policy_association = optional(bool)
  })
  description = "The web application firewall configuration for the application gateway."
}


# Gateway Ip Configuration

variable "gateway_ip_configurations" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
  description = "A list of gateway ip configurations for the application gateway."

  validation {
    condition     = length(var.gateway_ip_configurations) > 0
    error_message = "At least one gateway ip configuration must be provided."
  }
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

  validation {
    condition     = length(var.frontend_ip_configurations) > 0
    error_message = "At least one frontend ip configuration must be provided."
  }
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  description = "A list of ports used by http listeners to listen for frontend traffic."

  validation {
    condition     = length(var.frontend_ports) > 0
    error_message = "At least one frontend port must be provided."
  }
}

variable "http_listeners" {
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    firewall_policy_id             = optional(string)
  }))
  description = "A list of http listeners used on the frontend of the application gateway."

  validation {
    condition     = length(var.http_listeners) > 0
    error_message = "At least one http listener must be provided."
  }
}

# Backend

variable "backend_address_pools" {
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
  description = "A list of backend address pools used by the application gateway."

  validation {
    condition     = length(var.backend_address_pools) > 0
    error_message = "At least one backend address pool must be provided."
  }
}

variable "backend_http_settings" {
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    affinity_cookie_name  = optional(string)
    protocol              = string
    port                  = number
  }))
  description = "A list of backend http settings used by the application gateway."

  validation {
    condition = alltrue([
      length(var.backend_http_settings) > 0,
      alltrue([for settings in var.backend_http_settings : (
        settings.cookie_based_affinity == "Enabled" ? settings.affinity_cookie_name != "" : true
      )])
    ])
    error_message = "At least one backend http settings must be provided. An affinity cookie name must be provided when cookie based affinity is enabled."
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
  description = "A list of request routing rules that match http listeners to backend address pools and settings, optionally via path rules."

  validation {
    condition = alltrue([
      length(var.request_routing_rules) > 0,
      alltrue(([for rule in var.request_routing_rules : (
        rule.backend_address_pool_name == null || rule.url_path_map_name == null
      )]))
    ])
    error_message = "At least one request routing rule must be provided. Request routing rule cannot contain both a backend address pool and url path mapping."
  }
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this applicationg gateway."
  default     = null
}
