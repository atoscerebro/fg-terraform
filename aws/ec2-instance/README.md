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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.fg](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/key_pair) | resource |
| [aws_security_group.fg](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.out](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ssh](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [null_resource.test](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/availability_zones) | data source |
| [aws_iam_instance_profile.ssm_managed](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/iam_instance_profile) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | The number of requested Availability Zones | `number` | `1` | no |
| <a name="input_ec2_count"></a> [ec2\_count](#input\_ec2\_count) | The number of requested EC2 instances. | `number` | `1` | no |
| <a name="input_egress_ip_address"></a> [egress\_ip\_address](#input\_egress\_ip\_address) | Allow outgoing traffic from the ec2 to anywhere | `string` | `"0.0.0.0/0"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment: dev, test, stg, prod | `string` | `"dev"` | no |
| <a name="input_http_ingress_ip_address"></a> [http\_ingress\_ip\_address](#input\_http\_ingress\_ip\_address) | IP address to allow HTTP access from | `string` | `"10.10.0.0/16"` | no |
| <a name="input_https_ingress_ip_address"></a> [https\_ingress\_ip\_address](#input\_https\_ingress\_ip\_address) | IP address to allow HTTPS access from | `string` | `"10.10.0.0/16"` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | AMI Instance profile for SSM managed | `string` | `"FG_SystemsManagerEC2InstanceManagementRole"` | no |
| <a name="input_instance_ami_image_id"></a> [instance\_ami\_image\_id](#input\_instance\_ami\_image\_id) | AMI image id to use for the instance. | `string` | `"ami-0779c326801d5a843"` | no |
| <a name="input_instance_ami_name"></a> [instance\_ami\_name](#input\_instance\_ami\_name) | AMI name to use for the instance. | `string` | `"al2023-ami-2023.0.20230315.0-kernel-6.1-x86_64"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance. | `string` | `"t2.micro"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | A user-provided public ssh key for use in the aws\_key\_pair resource. | `string` | n/a | yes |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description of aws security group. | `string` | n/a | yes |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of aws security group. | `string` | n/a | yes |
| <a name="input_ssh_ingress_ip_address"></a> [ssh\_ingress\_ip\_address](#input\_ssh\_ingress\_ip\_address) | IP address to allow SSH access from | `string` | `"0.0.0.0/0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data to provide as a bash script when launching the instance. Default value null. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for use in security group. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"test"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_instance_arns"></a> [aws\_instance\_arns](#output\_aws\_instance\_arns) | The ARNs of the aws ec2 instances. |
| <a name="output_aws_instance_names"></a> [aws\_instance\_names](#output\_aws\_instance\_names) | A list of the aws ec2 instance names. |
| <a name="output_key_pair_arn"></a> [key\_pair\_arn](#output\_key\_pair\_arn) | The deployer key pair ARN. |
| <a name="output_key_pair_id"></a> [key\_pair\_id](#output\_key\_pair\_id) | The deployer key pair ID. |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | The deployer key pair name. |
| <a name="output_key_pair_tags"></a> [key\_pair\_tags](#output\_key\_pair\_tags) | A map of the key pair's tags, including those inherited from the provider. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The security group ARN. |
| <a name="output_security_group_egress_arn"></a> [security\_group\_egress\_arn](#output\_security\_group\_egress\_arn) | The security group egress rule ARN. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID. |
| <a name="output_security_group_ingress_http_arn"></a> [security\_group\_ingress\_http\_arn](#output\_security\_group\_ingress\_http\_arn) | The security group ingress http rule ARN. |
| <a name="output_security_group_ingress_https_arn"></a> [security\_group\_ingress\_https\_arn](#output\_security\_group\_ingress\_https\_arn) | The security group ingress https rule ARN. |
| <a name="output_security_group_ingress_https_ssh"></a> [security\_group\_ingress\_https\_ssh](#output\_security\_group\_ingress\_https\_ssh) | The security group ingress ssh rule ARN. |
| <a name="output_security_group_owner_id"></a> [security\_group\_owner\_id](#output\_security\_group\_owner\_id) | The security group owner id. |
| <a name="output_security_group_tags"></a> [security\_group\_tags](#output\_security\_group\_tags) | A map of the security group's tags, including those inherited from the provider. |
<!-- END_TF_DOCS -->