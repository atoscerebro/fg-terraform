<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
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
| [aws_acm_certificate.fg_nlb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.fg_nlb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/acm_certificate_validation) | resource |
| [aws_lb.network](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/lb_target_group) | resource |
| [aws_s3_bucket.fg_nlb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.fg_nlb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.fg_nlb_access_logs](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.default_fg_nlb](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.internet_http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.internet_https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.allow_nlb_write_to_bucket](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_domain_name"></a> [cert\_domain\_name](#input\_cert\_domain\_name) | Domain name for which the certificate should be issued. | `string` | `"test.com"` | no |
| <a name="input_cert_key_algorithm"></a> [cert\_key\_algorithm](#input\_cert\_key\_algorithm) | The algorithm of the public and private key pair that the Amazon-issued certificate uses to encrypt data. | `string` | `"RSA_2048"` | no |
| <a name="input_cert_validation_method"></a> [cert\_validation\_method](#input\_cert\_validation\_method) | The validation method used to approve ACM certificate used in NLB - DNS, EMAIL, or NONE are valid values. | `string` | `"EMAIL"` | no |
| <a name="input_egress_ip_address"></a> [egress\_ip\_address](#input\_egress\_ip\_address) | IP address to allow HTTP access to. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Boolean to specify whether to store access logs for the NLB. | `bool` | n/a | yes |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Boolean to enable cross zone load balancing. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_internal_nlb_tls"></a> [enable\_internal\_nlb\_tls](#input\_enable\_internal\_nlb\_tls) | Boolean to specify whether to enable TLS for the Internal Network Load Balancer. (External NLB has TLS enabled by default.) | `bool` | `false` | no |
| <a name="input_external_internet_ingress_ip_address"></a> [external\_internet\_ingress\_ip\_address](#input\_external\_internet\_ingress\_ip\_address) | IP address to allow external NLB HTTPS access from. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_force_destroy_nlb_access_logs"></a> [force\_destroy\_nlb\_access\_logs](#input\_force\_destroy\_nlb\_access\_logs) | Boolean to specify whether to force destroy access\_logs when s3 bucket is destroyed - when false, s3 bucket cannot be destroyed without error. | `bool` | `true` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Map describing Health Check settings - including endpoint (default /) and port (default 80). | `map(string)` | <pre>{<br>  "healthy_threshold": "3",<br>  "interval": "20",<br>  "port": "80",<br>  "protocol": "TCP",<br>  "timeout": "10",<br>  "unhealthy_threshold": "2"<br>}</pre> | no |
| <a name="input_internal_ingress_ip_address"></a> [internal\_ingress\_ip\_address](#input\_internal\_ingress\_ip\_address) | IP address to allow internal NLB access from. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | Name of the Network Load Balancer. | `string` | n/a | yes |
| <a name="input_nlb_security_group_ids"></a> [nlb\_security\_group\_ids](#input\_nlb\_security\_group\_ids) | List of additional Security Group IDs for NLB. | `list(string)` | `[]` | no |
| <a name="input_nlb_type_internal"></a> [nlb\_type\_internal](#input\_nlb\_type\_internal) | Boolean to specify whether type of NLB is internal. True == internal; false == external. | `bool` | `true` | no |
| <a name="input_s3_bucket_id"></a> [s3\_bucket\_id](#input\_s3\_bucket\_id) | Name/ID of the S3 bucket to store the logs in. If none is passed in by user, a new S3 bucket will be created. | `string` | `""` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of aws security group. | `string` | n/a | yes |
| <a name="input_ssl_cert"></a> [ssl\_cert](#input\_ssl\_cert) | Optional ARN of custom SSL server certificate. If this field is not specified module will create an Amazon-issued ACM certificate. | `string` | `null` | no |
| <a name="input_ssl_security_policy"></a> [ssl\_security\_policy](#input\_ssl\_security\_policy) | Name of SSL Policy for internal HTTPS listener. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of NLB's default target group's targets. | `string` | `"instance"` | no |
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
| <a name="output_cert_validation_id"></a> [cert\_validation\_id](#output\_cert\_validation\_id) | The id of the certificate validation resource. |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | The Amazon Resource Name (ARN) of the ACM certificate. |
| <a name="output_certificate_domain_name"></a> [certificate\_domain\_name](#output\_certificate\_domain\_name) | The domain name for which the ACM certificate is issued. |
| <a name="output_certificate_expiry_date"></a> [certificate\_expiry\_date](#output\_certificate\_expiry\_date) | Expiration date and time of the certificate. |
| <a name="output_certificate_start_date"></a> [certificate\_start\_date](#output\_certificate\_start\_date) | Start of the validity period of the certificate. |
| <a name="output_certificate_status"></a> [certificate\_status](#output\_certificate\_status) | Status of ACM certificate. |
| <a name="output_certificate_tags"></a> [certificate\_tags](#output\_certificate\_tags) | Map with all tags for ACM certificate. |
| <a name="output_certificate_type"></a> [certificate\_type](#output\_certificate\_type) | Source of ACM certificate. |
| <a name="output_default_nlb_security_group_arn"></a> [default\_nlb\_security\_group\_arn](#output\_default\_nlb\_security\_group\_arn) | The ARN of the security group created by default with the Network Load Balancer. |
| <a name="output_default_nlb_security_group_egress_http_arn"></a> [default\_nlb\_security\_group\_egress\_http\_arn](#output\_default\_nlb\_security\_group\_egress\_http\_arn) | The default security group HTTP egress rule ARN. |
| <a name="output_default_nlb_security_group_egress_http_tags"></a> [default\_nlb\_security\_group\_egress\_http\_tags](#output\_default\_nlb\_security\_group\_egress\_http\_tags) | Map of all tags for the HTTP egress rule. |
| <a name="output_default_nlb_security_group_egress_https_arn"></a> [default\_nlb\_security\_group\_egress\_https\_arn](#output\_default\_nlb\_security\_group\_egress\_https\_arn) | The default security group HTTPS egress rule ARN. |
| <a name="output_default_nlb_security_group_egress_https_tags"></a> [default\_nlb\_security\_group\_egress\_https\_tags](#output\_default\_nlb\_security\_group\_egress\_https\_tags) | Map of all tags for the HTTPS egress rule. |
| <a name="output_default_nlb_security_group_id"></a> [default\_nlb\_security\_group\_id](#output\_default\_nlb\_security\_group\_id) | The ID of the security group created by default with the Network Load Balancer. |
| <a name="output_default_nlb_security_group_ingress_http_arn"></a> [default\_nlb\_security\_group\_ingress\_http\_arn](#output\_default\_nlb\_security\_group\_ingress\_http\_arn) | The default security group http ingress rule ARN. |
| <a name="output_default_nlb_security_group_ingress_http_tags"></a> [default\_nlb\_security\_group\_ingress\_http\_tags](#output\_default\_nlb\_security\_group\_ingress\_http\_tags) | Map of all tags for the HTTP ingress rule. |
| <a name="output_default_nlb_security_group_ingress_https_arn"></a> [default\_nlb\_security\_group\_ingress\_https\_arn](#output\_default\_nlb\_security\_group\_ingress\_https\_arn) | The default security group https ingress rule ARN. |
| <a name="output_default_nlb_security_group_ingress_https_tags"></a> [default\_nlb\_security\_group\_ingress\_https\_tags](#output\_default\_nlb\_security\_group\_ingress\_https\_tags) | Map of all tags for the HTTPS ingress rule. |
| <a name="output_default_nlb_security_group_ingress_internet_http_arn"></a> [default\_nlb\_security\_group\_ingress\_internet\_http\_arn](#output\_default\_nlb\_security\_group\_ingress\_internet\_http\_arn) | The default security group internet http ingress rule ARN. |
| <a name="output_default_nlb_security_group_ingress_internet_http_tags"></a> [default\_nlb\_security\_group\_ingress\_internet\_http\_tags](#output\_default\_nlb\_security\_group\_ingress\_internet\_http\_tags) | Map of all tags for the internet http ingress rule. |
| <a name="output_default_nlb_security_group_ingress_internet_https_arn"></a> [default\_nlb\_security\_group\_ingress\_internet\_https\_arn](#output\_default\_nlb\_security\_group\_ingress\_internet\_https\_arn) | The default security group internet https ingress rule ARN. |
| <a name="output_default_nlb_security_group_ingress_internet_https_tags"></a> [default\_nlb\_security\_group\_ingress\_internet\_https\_tags](#output\_default\_nlb\_security\_group\_ingress\_internet\_https\_tags) | Map of all tags for the internet https ingress rule. |
| <a name="output_default_nlb_security_group_owner_id"></a> [default\_nlb\_security\_group\_owner\_id](#output\_default\_nlb\_security\_group\_owner\_id) | The owner ID of the security group created by default with the Network Load Balancer. |
| <a name="output_default_nlb_security_group_tags"></a> [default\_nlb\_security\_group\_tags](#output\_default\_nlb\_security\_group\_tags) | Map with all tags for the default security group. |
| <a name="output_default_nlb_target_group_arn"></a> [default\_nlb\_target\_group\_arn](#output\_default\_nlb\_target\_group\_arn) | The Amazon Resource Name (ARN) or ID of the default Target Group for the Network Load Balancer. |
| <a name="output_default_nlb_target_group_arn_suffix"></a> [default\_nlb\_target\_group\_arn\_suffix](#output\_default\_nlb\_target\_group\_arn\_suffix) | The ARN suffix of the default Target Group for the Network Load Balancer. |
| <a name="output_default_nlb_target_group_name"></a> [default\_nlb\_target\_group\_name](#output\_default\_nlb\_target\_group\_name) | The name of the default Target Group for the Network Load Balancer. |
| <a name="output_default_nlb_target_group_tags"></a> [default\_nlb\_target\_group\_tags](#output\_default\_nlb\_target\_group\_tags) | Map with all tags for the default Target Group. |
| <a name="output_nlb_arn"></a> [nlb\_arn](#output\_nlb\_arn) | The Amazon Resource Name (ARN) or ID of the Network Load Balancer. |
| <a name="output_nlb_arn_suffix"></a> [nlb\_arn\_suffix](#output\_nlb\_arn\_suffix) | The NLB's ARN suffix for use with CloudWatch Metrics. |
| <a name="output_nlb_dns_name"></a> [nlb\_dns\_name](#output\_nlb\_dns\_name) | The NLB's DNS name. |
| <a name="output_nlb_listener_http_arn"></a> [nlb\_listener\_http\_arn](#output\_nlb\_listener\_http\_arn) | ARN or ID of the Network Load Balancer's HTTP listener. |
| <a name="output_nlb_listener_http_tags"></a> [nlb\_listener\_http\_tags](#output\_nlb\_listener\_http\_tags) | Map with all tags for the HTTP listener. |
| <a name="output_nlb_listener_https_arn"></a> [nlb\_listener\_https\_arn](#output\_nlb\_listener\_https\_arn) | ARN or ID of the Network Load Balancer's HTTPS listener. |
| <a name="output_nlb_listener_https_tags"></a> [nlb\_listener\_https\_tags](#output\_nlb\_listener\_https\_tags) | Map with all tags for the HTTPS listener. |
| <a name="output_nlb_outpost_id"></a> [nlb\_outpost\_id](#output\_nlb\_outpost\_id) | Description of the Outpost containing the load balancer. |
| <a name="output_nlb_tags"></a> [nlb\_tags](#output\_nlb\_tags) | Map with all tags for Network Load Balancer. |
| <a name="output_nlb_zone_id"></a> [nlb\_zone\_id](#output\_nlb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
<!-- END_TF_DOCS -->