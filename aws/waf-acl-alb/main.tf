resource "aws_wafv2_web_acl" "fg_web_acl_alb" {
  name        = var.name
  description = var.description
  scope       = "REGIONAL"

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "custom_response_body" {
    for_each = var.custom_responses
    content {
      key          = custom_responses.value.key
      content      = custom_responses.value.content
      content_type = custom_responses.value.content_type
    }
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name

          dynamic "rule_action_override" {
            for_each = rule.value.override_action
            content {
              name = rule.value.name
              action_to_use = rule.value.override_action
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value.name
      }
    }
  }

dynamic "rule" {
    for_each = var.ip_sets_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        ip_set_reference_statement {
          arn = rule.value.ip_set_arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value.name
      }
    }
  }

  dynamic "rule" {
    for_each = var.ip_rate_based_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value.name
      }
    }
  }

  dynamic "rule" {
    for_each = var.ip_rate_url_based_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
          scope_down_statement {
            byte_match_statement {
              positional_constraint = rule.value.positional_constraint
              search_string         = rule.value.search_string
              field_to_match {
                uri_path {}
              }
              text_transformation {
                priority = 0
                type     = "URL_DECODE"
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value.name
      }
    }
  }

  dynamic "rule" {
    for_each = var.group_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rule_group_reference_statement {
          arn = rule.value.group_rule_arn

          dynamic "rule_action_override" {
            for_each = rule.value.override_action
            content {
              name = rule.value.name
              action_to_use = rule.value.override_action
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = true
        metric_name                = rule.value.name
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch
    sampled_requests_enabled   = var.enable_sampled_requests
    metric_name                = "${var.metric_name}_${var.name}"
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "fg_waf_to_alb" {
  web_acl_arn  = aws_wafv2_web_acl.fg_web_acl_alb.arn
  resource_arn = var.alb_arn
}

resource "aws_wafv2_web_acl_logging_configuration" "fg_logging_waf" {
  count = var.enable_logging ? 1 : 0

  log_destination_configs = [var.storage_logs_arn]
  resource_arn            = aws_wafv2_web_acl.fg_web_acl_alb.arn
}
