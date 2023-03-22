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
| [aws_internet_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/internet_gateway) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/route_table_association) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_security_group.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_local](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_local](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_egress](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_http](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.public_https](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/security_group_rule) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/subnet) | resource |
| [aws_vpc.fg_vpc](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.default](https://registry.terraform.io/providers/hashicorp/aws/4.58.0/docs/resources/vpc_dhcp_options_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of Availability Zones to create | `number` | `1` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Geographycal Region in which to create the VPC | `string` | `"eu-west-1"` | no |
| <a name="input_dhcp_dns_servers"></a> [dhcp\_dns\_servers](#input\_dhcp\_dns\_servers) | DNS servers for the instances within the VPC | `list(any)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_dhcp_domain_name"></a> [dhcp\_domain\_name](#input\_dhcp\_domain\_name) | Suffix domain name by default | `string` | `""` | no |
| <a name="input_dhcp_netbios_name_servers"></a> [dhcp\_netbios\_name\_servers](#input\_dhcp\_netbios\_name\_servers) | For Windows Instances: The friendly name assigned to an instance | `list(any)` | `[]` | no |
| <a name="input_dhcp_netbios_node_type"></a> [dhcp\_netbios\_node\_type](#input\_dhcp\_netbios\_node\_type) | For Windows Instances: how the instance will resolve netbios names to IP addresses | `number` | `2` | no |
| <a name="input_dhcp_ntp_servers"></a> [dhcp\_ntp\_servers](#input\_dhcp\_ntp\_servers) | NTP servers for the instances within the VPC | `list(any)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable assigning DNS hostnames to instances with public IP address | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable asigning internal DNS hostnames through AWS provided DNS server | `bool` | `true` | no |
| <a name="input_enable_internet_gateway"></a> [enable\_internet\_gateway](#input\_enable\_internet\_gateway) | Allow the public subnets to have access to the internet | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment of the VPC: dev, test, stg, prod | `string` | `"dev"` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | Ensures that EC2 instances use the tenancy specified with launching | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Useful to diferentiate resources per env, team, function ... | `map(any)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC, we are starting with a /16 | `string` | `"10.10.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"test"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#output\_vpc\_instance\_tenancy) | Tenancy of instances spin up within VPC |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with fg\_vpc VPC |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC |
| <a name="output_vpc_tags"></a> [vpc\_tags](#output\_vpc\_tags) | Map with all the tags for the VPC |
<!-- END_TF_DOCS -->
