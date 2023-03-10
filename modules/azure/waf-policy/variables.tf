# Base Setup

variable "name" {
  type        = string
  description = "The name of the web application firewall policy."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group the web application firewall policy belongs to."
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

# Rules

variable "managed_rules" {
  type = list(object({
    exclusions = optional(list(object({
      match_variable          = string
      selector                = string
      selector_match_operator = string
    })))
    managed_rule_sets = list(object({
      type    = optional(string)
      version = string
    }))
  }))
  description = "A list of (at least one) managed rules, including managed rule sets and exclusions owned by the policy."
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this applicationg gateway."
  default     = null
}
