# AWS EC2 Instance

output "aws_instance_arns" {
  value       = compact([for s in aws_instance.fg : s.arn])
  description = "The ARNs of the aws ec2 instances."
}

output "aws_instance_names" {
  value       = compact([for i in aws_instance.fg : i.tags.Name])
  description = "A list of the aws ec2 instance names."
}

# Key Pair

output "key_pair_name" {
  value       = try(aws_key_pair.deployer.key_name, "")
  description = "The deployer key pair name."
}

output "key_pair_arn" {
  value       = try(aws_key_pair.deployer.arn, "")
  description = "The deployer key pair ARN."
}

output "key_pair_id" {
  value       = try(aws_key_pair.deployer.key_pair_id, "")
  description = "The deployer key pair ID."
}

output "key_pair_tags" {
  value       = try(aws_key_pair.deployer.tags_all, {})
  description = "A map of the key pair's tags, including those inherited from the provider."
}

# Security Group


output "security_group_owner_id" {
  value       = try(aws_security_group.fg.owner_id, "")
  description = "The security group owner id."
}

output "security_group_arn" {
  value       = try(aws_security_group.fg.arn, "")
  description = "The security group ARN."
}

output "security_group_id" {
  value       = try(aws_security_group.fg.id, "")
  description = "The security group ID."
}

output "security_group_tags" {
  value       = try(aws_security_group.fg.tags_all, {})
  description = "A map of the security group's tags, including those inherited from the provider."
}

output "security_group_ingress_https_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.https.arn, "")
  description = "The security group ingress https rule ARN."
}

output "security_group_ingress_http_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.http.arn, "")
  description = "The security group ingress http rule ARN."
}

output "security_group_ingress_https_ssh" {
  value       = try(aws_vpc_security_group_ingress_rule.ssh.arn, "")
  description = "The security group ingress ssh rule ARN."
}

output "security_group_egress_arn" {
  value       = try(aws_vpc_security_group_egress_rule.out.arn, "")
  description = "The security group egress rule ARN."
}

