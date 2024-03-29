<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.fg_alb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.fg_alb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/acm_certificate_validation) | resource |
| [aws_lb.application](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_target_group) | resource |
| [aws_route53_record.fg_alb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.fg_alb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.fg_alb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.fg_alb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.default_fg_alb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.internet_https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.allow_alb_write_to_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the Application Load Balancer. | `string` | n/a | yes |
| <a name="input_alb_security_group_ids"></a> [alb\_security\_group\_ids](#input\_alb\_security\_group\_ids) | List of additional Security Group IDs for ALB. | `list(string)` | `[]` | no |
| <a name="input_alb_type_internal"></a> [alb\_type\_internal](#input\_alb\_type\_internal) | Boolean to specify whether type of ALB is internal. True == internal; false == external. | `bool` | `true` | no |
| <a name="input_cert_domain_name"></a> [cert\_domain\_name](#input\_cert\_domain\_name) | Domain name for which the certificate should be issued. | `string` | `"*.fg-aws.atos-cerebro.net"` | no |
| <a name="input_cert_key_algorithm"></a> [cert\_key\_algorithm](#input\_cert\_key\_algorithm) | The algorithm of the public and private key pair that the Amazon-issued certificate uses to encrypt data. | `string` | `"RSA_2048"` | no |
| <a name="input_cert_validation_method"></a> [cert\_validation\_method](#input\_cert\_validation\_method) | The validation method used to approve ACM certificate used in ALB - DNS, EMAIL, or NONE are valid values. | `string` | `"DNS"` | no |
| <a name="input_default_target_type"></a> [default\_target\_type](#input\_default\_target\_type) | Type of ALB's default target group's targets. | `string` | `"instance"` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | The ID of the DNS zone for the Route 53 record. | `string` | n/a | yes |
| <a name="input_egress_ip_address"></a> [egress\_ip\_address](#input\_egress\_ip\_address) | IP address to allow HTTP access to. | `string` | `"10.10.0.0/16"` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Boolean to specify whether to store access logs for the ALB. | `bool` | n/a | yes |
| <a name="input_enable_internal_alb_tls"></a> [enable\_internal\_alb\_tls](#input\_enable\_internal\_alb\_tls) | Boolean to specify whether to enable TLS for the Internal Application Load Balancer. (External ALB has TLS enabled by default.) | `bool` | `false` | no |
| <a name="input_external_internet_ingress_ip_address"></a> [external\_internet\_ingress\_ip\_address](#input\_external\_internet\_ingress\_ip\_address) | IP address to allow external ALB HTTPS access from. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_force_destroy_alb_access_logs"></a> [force\_destroy\_alb\_access\_logs](#input\_force\_destroy\_alb\_access\_logs) | Boolean to specify whether to force destroy access\_logs when s3 bucket is destroyed - when false, s3 bucket cannot be destroyed without error. | `bool` | `true` | no |
| <a name="input_http_health_check"></a> [http\_health\_check](#input\_http\_health\_check) | Map describing HTTP Health Check settings - including endpoint (default /) and port (default 80). Applied for internal LBs. | `map(string)` | <pre>{<br>  "healthy_threshold": "3",<br>  "interval": "20",<br>  "matcher": "200",<br>  "path": "/",<br>  "port": "80",<br>  "protocol": "HTTP",<br>  "timeout": "10",<br>  "unhealthy_threshold": "2"<br>}</pre> | no |
| <a name="input_internal_ingress_ip_address"></a> [internal\_ingress\_ip\_address](#input\_internal\_ingress\_ip\_address) | IP address to allow internal ALB access from. | `string` | `"10.10.0.0/16"` | no |
| <a name="input_s3_bucket_id"></a> [s3\_bucket\_id](#input\_s3\_bucket\_id) | Name/ID of the S3 bucket to store the logs in. If none is passed in by user, a new S3 bucket will be created. | `string` | `""` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of aws security group. | `string` | n/a | yes |
| <a name="input_ssl_cert"></a> [ssl\_cert](#input\_ssl\_cert) | Optional ARN of custom SSL server certificate. If this field is not specified module will create an Amazon-issued ACM certificate. | `string` | `null` | no |
| <a name="input_ssl_security_policy"></a> [ssl\_security\_policy](#input\_ssl\_security\_policy) | Name of SSL Policy for internal HTTPS listener. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for use in target group, security group and to retrieve subnets. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_logs_bucket_arn"></a> [access\_logs\_bucket\_arn](#output\_access\_logs\_bucket\_arn) | ARN of the s3 bucket used to store access logs. |
| <a name="output_access_logs_bucket_domain_name"></a> [access\_logs\_bucket\_domain\_name](#output\_access\_logs\_bucket\_domain\_name) | Domain name of the s3 bucket used to store access logs. |
| <a name="output_access_logs_bucket_name"></a> [access\_logs\_bucket\_name](#output\_access\_logs\_bucket\_name) | Name of the s3 bucket used to store access logs. |
| <a name="output_access_logs_bucket_region"></a> [access\_logs\_bucket\_region](#output\_access\_logs\_bucket\_region) | Region of the s3 bucket used to store access logs. |
| <a name="output_access_logs_bucket_regional_domain_name"></a> [access\_logs\_bucket\_regional\_domain\_name](#output\_access\_logs\_bucket\_regional\_domain\_name) | Regional domain name of the s3 bucket used to store access logs. |
| <a name="output_access_logs_bucket_tags"></a> [access\_logs\_bucket\_tags](#output\_access\_logs\_bucket\_tags) | Map with all tags for S3 buckets used to store ALB logs. |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The Amazon Resource Name (ARN) or ID of the Application Load Balancer. |
| <a name="output_alb_arn_suffix"></a> [alb\_arn\_suffix](#output\_alb\_arn\_suffix) | The ALB's ARN suffix for use with CloudWatch Metrics. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The ALB's DNS name. |
| <a name="output_alb_listener_http_arn"></a> [alb\_listener\_http\_arn](#output\_alb\_listener\_http\_arn) | ARN or ID of the Application Load Balancer's HTTP listener. |
| <a name="output_alb_listener_http_tags"></a> [alb\_listener\_http\_tags](#output\_alb\_listener\_http\_tags) | Map with all tags for the HTTP listener. |
| <a name="output_alb_listener_https_arn"></a> [alb\_listener\_https\_arn](#output\_alb\_listener\_https\_arn) | ARN or ID of the Application Load Balancer's HTTPS listener. |
| <a name="output_alb_listener_https_tags"></a> [alb\_listener\_https\_tags](#output\_alb\_listener\_https\_tags) | Map with all tags for the HTTPS listener. |
| <a name="output_alb_outpost_id"></a> [alb\_outpost\_id](#output\_alb\_outpost\_id) | D of the Outpost containing the load balancer. |
| <a name="output_alb_tags"></a> [alb\_tags](#output\_alb\_tags) | Map with all tags for Application Load Balancer. |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| <a name="output_cert_validation_id"></a> [cert\_validation\_id](#output\_cert\_validation\_id) | The id of the certificate validation resource. |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | The Amazon Resource Name (ARN) of the ACM certificate. |
| <a name="output_certificate_domain_name"></a> [certificate\_domain\_name](#output\_certificate\_domain\_name) | The domain name for which the ACM certificate is issued. |
| <a name="output_certificate_expiry_date"></a> [certificate\_expiry\_date](#output\_certificate\_expiry\_date) | Expiration date and time of the certificate. |
| <a name="output_certificate_start_date"></a> [certificate\_start\_date](#output\_certificate\_start\_date) | Start of the validity period of the certificate. |
| <a name="output_certificate_status"></a> [certificate\_status](#output\_certificate\_status) | Status of ACM certificate. |
| <a name="output_certificate_tags"></a> [certificate\_tags](#output\_certificate\_tags) | Map with all tags for ACM certificate. |
| <a name="output_certificate_type"></a> [certificate\_type](#output\_certificate\_type) | Source of ACM certificate. |
| <a name="output_default_alb_security_group_arn"></a> [default\_alb\_security\_group\_arn](#output\_default\_alb\_security\_group\_arn) | The ARN of the security group created by default with the Application Load Balancer. |
| <a name="output_default_alb_security_group_egress_arn"></a> [default\_alb\_security\_group\_egress\_arn](#output\_default\_alb\_security\_group\_egress\_arn) | The default security group egress rule ARN. |
| <a name="output_default_alb_security_group_egress_https_arn"></a> [default\_alb\_security\_group\_egress\_https\_arn](#output\_default\_alb\_security\_group\_egress\_https\_arn) | The default security group HTTPS egress rule ARN. |
| <a name="output_default_alb_security_group_egress_https_tags"></a> [default\_alb\_security\_group\_egress\_https\_tags](#output\_default\_alb\_security\_group\_egress\_https\_tags) | Map of all tags for the HTTPS egress rule. |
| <a name="output_default_alb_security_group_egress_tags"></a> [default\_alb\_security\_group\_egress\_tags](#output\_default\_alb\_security\_group\_egress\_tags) | Map of all tags for the default egress rule. |
| <a name="output_default_alb_security_group_id"></a> [default\_alb\_security\_group\_id](#output\_default\_alb\_security\_group\_id) | The ID of the security group created by default with the Application Load Balancer. |
| <a name="output_default_alb_security_group_ingress_http_arn"></a> [default\_alb\_security\_group\_ingress\_http\_arn](#output\_default\_alb\_security\_group\_ingress\_http\_arn) | The default security group http ingress rule ARN. |
| <a name="output_default_alb_security_group_ingress_http_tags"></a> [default\_alb\_security\_group\_ingress\_http\_tags](#output\_default\_alb\_security\_group\_ingress\_http\_tags) | Map of all tags for the HTTP ingress rule. |
| <a name="output_default_alb_security_group_ingress_https_arn"></a> [default\_alb\_security\_group\_ingress\_https\_arn](#output\_default\_alb\_security\_group\_ingress\_https\_arn) | The default security group https ingress rule ARN. |
| <a name="output_default_alb_security_group_ingress_https_tags"></a> [default\_alb\_security\_group\_ingress\_https\_tags](#output\_default\_alb\_security\_group\_ingress\_https\_tags) | Map of all tags for the HTTPS ingress rule. |
| <a name="output_default_alb_security_group_ingress_internet_https_arn"></a> [default\_alb\_security\_group\_ingress\_internet\_https\_arn](#output\_default\_alb\_security\_group\_ingress\_internet\_https\_arn) | The default security group internet https ingress rule ARN. |
| <a name="output_default_alb_security_group_ingress_internet_https_tags"></a> [default\_alb\_security\_group\_ingress\_internet\_https\_tags](#output\_default\_alb\_security\_group\_ingress\_internet\_https\_tags) | Map of all tags for the internet https ingress rule. |
| <a name="output_default_alb_security_group_owner_id"></a> [default\_alb\_security\_group\_owner\_id](#output\_default\_alb\_security\_group\_owner\_id) | The owner ID of the security group created by default with the Application Load Balancer. |
| <a name="output_default_alb_security_group_tags"></a> [default\_alb\_security\_group\_tags](#output\_default\_alb\_security\_group\_tags) | Map with all tags for the default security group. |
| <a name="output_default_alb_target_group_arn"></a> [default\_alb\_target\_group\_arn](#output\_default\_alb\_target\_group\_arn) | The Amazon Resource Name (ARN) or ID of the default Target Group for the Application Load Balancer. |
| <a name="output_default_alb_target_group_arn_suffix"></a> [default\_alb\_target\_group\_arn\_suffix](#output\_default\_alb\_target\_group\_arn\_suffix) | The ARN suffix of the default Target Group for the Application Load Balancer. |
| <a name="output_default_alb_target_group_name"></a> [default\_alb\_target\_group\_name](#output\_default\_alb\_target\_group\_name) | The name of the default Target Group for the Application Load Balancer. |
| <a name="output_default_alb_target_group_tags"></a> [default\_alb\_target\_group\_tags](#output\_default\_alb\_target\_group\_tags) | Map with all tags for the default Target Group. |
<!-- END_TF_DOCS -->
