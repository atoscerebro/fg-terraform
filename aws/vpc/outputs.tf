output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.fg_vpc.id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.fg_vpc.arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.fg_vpc.cidr_block, "")
}

output "vpc_tags" {
  description = "Map with all the tags for the VPC"
  value       = try(aws_vpc.fg_vpc.tags_all, "")
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.fg_vpc.default_security_group_id, "")
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_vpc.fg_vpc.default_network_acl_id, "")
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_vpc.fg_vpc.default_route_table_id, "")
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = try(aws_vpc.fg_vpc.instance_tenancy, "")
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = try(aws_vpc.fg_vpc.enable_dns_support, "")
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = try(aws_vpc.fg_vpc.enable_dns_hostnames, "")
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with fg_vpc VPC"
  value       = try(aws_vpc.fg_vpc.main_route_table_id, "")
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.fg_vpc.owner_id, "")
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = compact(aws_subnet.private[*].id)
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = compact(aws_subnet.private[*].arn)
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private[*].cidr_block)
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = compact(aws_subnet.public[*].id)
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = compact(aws_subnet.public[*].arn)
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public[*].cidr_block)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = compact(aws_route_table.public[*].id)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = compact(aws_route_table.private[*].id)
}
