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
| [aws_instance.test_instance](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/key_pair) | resource |
| [aws_security_group.test_group](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.out](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ssh](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/ami) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Geographical Region in which to create the VPC | `string` | `"eu-west-1"` | no |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | The number of requested Availability Zones | `number` | `1` | no |
| <a name="input_ec2_count"></a> [ec2\_count](#input\_ec2\_count) | The number of requested EC2 instances. | `number` | `1` | no |
| <a name="input_egress_ip_address"></a> [egress\_ip\_address](#input\_egress\_ip\_address) | IP address to allow HTTPS access to | `string` | `"10.0.0.0/16"` | no |
| <a name="input_http_ingress_ip_address"></a> [http\_ingress\_ip\_address](#input\_http\_ingress\_ip\_address) | IP address to allow HTTP access from | `string` | `"10.0.0.0/16"` | no |
| <a name="input_https_ingress_ip_address"></a> [https\_ingress\_ip\_address](#input\_https\_ingress\_ip\_address) | IP address to allow HTTPS access from | `string` | `"10.0.0.0/16"` | no |
| <a name="input_instance_ami_image_id"></a> [instance\_ami\_image\_id](#input\_instance\_ami\_image\_id) | AMI image id to use for the instance. | `string` | `"ami-09e34b2574f465af6"` | no |
| <a name="input_instance_ami_name"></a> [instance\_ami\_name](#input\_instance\_ami\_name) | AMI name to use for the instance. | `string` | `"amzn2-ami-minimal-hvm-2.0.20211001.1-arm64-ebs"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance. | `string` | `"t2.micro"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | A user-provided public ssh key for use in the aws\_key\_pair resource. | `string` | n/a | yes |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description of aws security group. | `string` | n/a | yes |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of aws security group. | `string` | n/a | yes |
| <a name="input_ssh_ingress_ip_address"></a> [ssh\_ingress\_ip\_address](#input\_ssh\_ingress\_ip\_address) | IP address to allow SSH access from | `string` | `"0.0.0.0/0"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data to provide as a bash script when launching the instance. Default value null. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id for use in security group. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_instance_ids"></a> [aws\_instance\_ids](#output\_aws\_instance\_ids) | The ids of the aws ec2 instances. |
<!-- END_TF_DOCS -->