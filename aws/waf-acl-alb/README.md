<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl.fg_web_acl_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.fg_waf_to_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.fg_logging_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the Application LB to associate with | `string` | n/a | yes |
| <a name="input_custom_responses"></a> [custom\_responses](#input\_custom\_responses) | The custom response behaviour for the default web ACL action | <pre>list(object({<br>    key          = string<br>    content      = string<br>    content_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | Add here all the rules as a list of maps | `list(string)` | `[]` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Action to apply if no rules match | `string` | `"allow"` | no |
| <a name="input_description"></a> [description](#input\_description) | Something meaningful to describe this ACL | `string` | n/a | yes |
| <a name="input_enable_cloudwatch"></a> [enable\_cloudwatch](#input\_enable\_cloudwatch) | Enable metrics for the ACL | `bool` | `true` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Log all traffic through the ACL | `bool` | `false` | no |
| <a name="input_enable_sampled_requests"></a> [enable\_sampled\_requests](#input\_enable\_sampled\_requests) | Enable sampled requests for the ACL | `bool` | `true` | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | List of Managed WAF rules. | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>    vendor_name     = string<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "override_action": "none",<br>    "priority": 10,<br>    "vendor_name": "AWS"<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesAmazonIpReputationList",<br>    "override_action": "none",<br>    "priority": 20,<br>    "vendor_name": "AWS"<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br>    "override_action": "none",<br>    "priority": 30,<br>    "vendor_name": "AWS"<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesSQLiRuleSet",<br>    "override_action": "none",<br>    "priority": 40,<br>    "vendor_name": "AWS"<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesLinuxRuleSet",<br>    "override_action": "none",<br>    "priority": 50,<br>    "vendor_name": "AWS"<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesUnixRuleSet",<br>    "override_action": "none",<br>    "priority": 60,<br>    "vendor_name": "AWS"<br>  }<br>]</pre> | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | The name of the metric to create, if we are enabling CloudWatch | `string` | `"FG_WEBACL_ALB_Entityx"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the WEB ACL | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Useful to diferentiate resources per env, team, function ... | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | n/a |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | n/a |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | n/a |
| <a name="output_web_acl_tags"></a> [web\_acl\_tags](#output\_web\_acl\_tags) | n/a |
<!-- END_TF_DOCS -->