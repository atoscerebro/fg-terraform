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

          dynamic "excluded_rule" {
            for_each = rule.value.excluded_rules
            content {
              name = excluded_rule.value
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
    for_each = var.custom_rules
    content {
      name = rule.value.name
      priority = rule.value.priority
      visibility_config {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = rule.value.visibility_config_metric_name
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch
    sampled_requests_enabled   = var.enable_sampled_requests
    metric_name                = var.metric_name
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
