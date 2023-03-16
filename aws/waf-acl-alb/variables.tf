variable "name" {
  description = "Name of the WEB ACL"
  type        = string
}

variable "description" {
  description = "Something meaningful to describe this ACL"
  type        = string
}

variable "default_action" {
  description = "Action to apply if no rules match"
  type        = string
  default     = "allow"
}

variable "alb_arn" {
  description = "ARN of the Application LB to associate with"
  type        = string
}

variable "enable_logging" {
  description = "Log all traffic through the ACL"
  type        = bool
  default     = false
}

variable "enable_cloudwatch" {
  description = "Enable metrics for the ACL"
  type        = bool
  default     = false
}

variable "enable_sampled_requests" {
  description = "Enable sampled requests for the ACL"
  type        = bool
  default     = false
}

variable "metric_name" {
  description = "The name of the metric to create, if we are enabling CloudWatch"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Useful to diferentiate resources per env, team, function ..."
  type        = map(any)
  default     = {}
}

variable "custom_responses" {
  description = "The custom response behaviour for the default web ACL action"
  type = list(object({
    key          = string
    content      = string
    content_type = string
  }))
  default = []
}

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
    vendor_name     = string
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
      vendor_name     = "AWS"
    }
  ]
}

