# Network Load Balancer 

output "nlb_arn" {
  description = "The Amazon Resource Name (ARN) or ID of the Network Load Balancer."
  value       = try(aws_lb.network.arn, "")
}

output "nlb_arn_suffix" {
  description = "The NLB's ARN suffix for use with CloudWatch Metrics."
  value       = try(aws_lb.network.arn_suffix, "")
}

output "nlb_dns_name" {
  description = "The NLB's DNS name."
  value       = try(aws_lb.network.dns_name, "")
}

output "nlb_outpost_id" {
  description = "Description of the Outpost containing the load balancer."
  value       = try(aws_lb.network.subnet_mapping.*.outpost_id, "")
}

output "nlb_tags" {
  description = "Map with all tags for Network Load Balancer."
  value       = try(aws_lb.network.tags_all, {})
}

output "nlb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = try(aws_lb.network.zone_id, {})
}

## NLB Access Logs

output "access_logs_bucket_name" {
  description = "Name of the s3 bucket used to store access logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].id, "")
}

output "access_logs_bucket_arn" {
  description = "ARN of the s3 bucket used to store access logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].arn, "")
}

output "access_logs_bucket_domain_name" {
  description = "Domain name of the s3 bucket used to store access logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].bucket_domain_name, "")
}

output "access_logs_bucket_regional_domain_name" {
  description = "Regional domain name of the s3 bucket used to store access logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].bucket_regional_domain_name, "")
}

output "access_logs_bucket_region" {
  description = "Region of the s3 bucket used to store access logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].region, "")
}

output "access_logs_bucket_tags" {
  description = "Map with all tags for S3 buckets used to store ALB logs."
  value       = try(aws_s3_bucket.fg_nlb_access_logs[0].tags_all, {})
}

## Default Security Group

output "default_nlb_security_group_id" {
  description = "The ID of the security group created by default with the Network Load Balancer."
  value       = try(aws_security_group.default_fg_nlb.id, "")
}

output "default_nlb_security_group_arn" {
  description = "The ARN of the security group created by default with the Network Load Balancer."
  value       = try(aws_security_group.default_fg_nlb.arn, "")
}

output "default_nlb_security_group_owner_id" {
  description = "The owner ID of the security group created by default with the Network Load Balancer."
  value       = try(aws_security_group.default_fg_nlb.owner_id, "")
}

output "default_nlb_security_group_tags" {
  description = "Map with all tags for the default security group."
  value       = try(aws_security_group.default_fg_nlb.tags_all, {})
}

### Default Security Group Rules

output "default_nlb_security_group_egress_http_arn" {
  value       = try(aws_vpc_security_group_egress_rule.http.arn, "")
  description = "The default security group HTTP egress rule ARN."
}

output "default_nlb_security_group_egress_http_tags" {
  value       = try(aws_vpc_security_group_egress_rule.http.tags_all, "")
  description = "Map of all tags for the HTTP egress rule."
}

output "default_nlb_security_group_egress_https_arn" {
  value       = try(aws_vpc_security_group_egress_rule.https[0].arn, "")
  description = "The default security group HTTPS egress rule ARN."
}

output "default_nlb_security_group_egress_https_tags" {
  value       = try(aws_vpc_security_group_egress_rule.https[0].tags_all, "")
  description = "Map of all tags for the HTTPS egress rule."
}

output "default_nlb_security_group_ingress_internet_http_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_http[0].arn, "")
  description = "The default security group internet http ingress rule ARN."
}

output "default_nlb_security_group_ingress_internet_http_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_http[0].tags_all, "")
  description = "Map of all tags for the internet http ingress rule."
}

output "default_nlb_security_group_ingress_internet_https_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_https[0].arn, "")
  description = "The default security group internet https ingress rule ARN."
}

output "default_nlb_security_group_ingress_internet_https_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_https[0].tags_all, "")
  description = "Map of all tags for the internet https ingress rule."
}

output "default_nlb_security_group_ingress_http_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.http[0].arn, "")
  description = "The default security group http ingress rule ARN."
}

output "default_nlb_security_group_ingress_http_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.http[0].tags_all, "")
  description = "Map of all tags for the HTTP ingress rule."
}

output "default_nlb_security_group_ingress_https_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.https[0].arn, "")
  description = "The default security group https ingress rule ARN."
}

output "default_nlb_security_group_ingress_https_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.https[0].tags_all, "")
  description = "Map of all tags for the HTTPS ingress rule."
}

## Default Target Group

output "default_nlb_target_group_arn" {
  description = "The Amazon Resource Name (ARN) or ID of the default Target Group for the Network Load Balancer."
  value       = try(aws_lb_target_group.default.arn, "")
}

output "default_nlb_target_group_arn_suffix" {
  description = "The ARN suffix of the default Target Group for the Network Load Balancer."
  value       = try(aws_lb_target_group.default.arn_suffix, "")
}

output "default_nlb_target_group_name" {
  description = "The name of the default Target Group for the Network Load Balancer."
  value       = try(aws_lb_target_group.default.name, "")
}

output "default_nlb_target_group_tags" {
  description = "Map with all tags for the default Target Group."
  value       = try(aws_lb_target_group.default.tags_all, {})
}

### Default Listeners

output "nlb_listener_http_arn" {
  description = "ARN or ID of the Network Load Balancer's HTTP listener."
  value       = try(aws_lb_listener.http.arn, "")
}

output "nlb_listener_http_tags" {
  description = "Map with all tags for the HTTP listener."
  value       = try(aws_lb_listener.http.tags_all, "")
}

output "nlb_listener_https_arn" {
  description = "ARN or ID of the Network Load Balancer's HTTPS listener."
  value       = try(aws_lb_listener.https[0].arn, "")
}

output "nlb_listener_https_tags" {
  description = "Map with all tags for the HTTPS listener."
  value       = try(aws_lb_listener.https[0].tags_all, "")
}

# ACM Certificate

output "cert_validation_id" {
  description = "The id of the certificate validation resource."
  value       = try(aws_acm_certificate_validation.fg_nlb[0].id, "")
}

output "certificate_arn" {
  description = "The Amazon Resource Name (ARN) of the ACM certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].arn, "")
}

output "certificate_domain_name" {
  description = "The domain name for which the ACM certificate is issued."
  value       = try(aws_acm_certificate.fg_nlb[0].domain_name, "")
}

output "certificate_start_date" {
  description = "Start of the validity period of the certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].not_before, "")
}

output "certificate_expiry_date" {
  description = "Expiration date and time of the certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].not_after, "")
}

output "certificate_status" {
  description = "Status of ACM certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].status, "")
}

output "certificate_type" {
  description = "Source of ACM certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].type, "")
}

output "certificate_tags" {
  description = "Map with all tags for ACM certificate."
  value       = try(aws_acm_certificate.fg_nlb[0].tags_all, {})
}
