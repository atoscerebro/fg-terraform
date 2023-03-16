# Application Load Balancer 

output "alb_arn" {
  description = "The Amazon Resource Name (ARN) or ID of the Application Load Balancer."
  value       = try(aws_lb.application.arn, "")
}

output "alb_arn_suffix" {
  description = "The ALB's ARN suffix for use with CloudWatch Metrics."
  value       = try(aws_lb.application.arn_suffix, "")
}

output "alb_dns_name" {
  description = "The ALB's DNS name."
  value       = try(aws_lb.application.dns_name, "")
}

output "alb_outpost_id" {
  description = "D of the Outpost containing the load balancer."
  value       = try(aws_lb.application.subnet_mapping.*.outpost_id, "")
}

output "alb_tags" {
  description = "Map with all tags for Application Load Balancer."
  value       = try(aws_lb.application.tags_all, {})
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = try(aws_lb.application.zone_id, {})
}

## Default Security Group

output "default_alb_security_group_id" {
  description = "The ID of the security group created by default with the Application Load Balancer."
  value       = try(aws_security_group.default_fg_alb.id, "")
}

output "default_alb_security_group_arn" {
  description = "The ARN of the security group created by default with the Application Load Balancer."
  value       = try(aws_security_group.default_fg_alb.arn, "")
}

output "default_alb_security_group_owner_id" {
  description = "The owner ID of the security group created by default with the Application Load Balancer."
  value       = try(aws_security_group.default_fg_alb.owner_id, "")
}

output "default_alb_security_group_tags" {
  description = "Map with all tags for the default security group."
  value       = try(aws_security_group.default_fg_alb.tags_all, {})
}

### Default Security Group Rules

output "default_alb_security_group_egress_http_arn" {
  value       = try(aws_vpc_security_group_egress_rule.http.arn, "")
  description = "The default security group HTTP egress rule ARN."
}

output "default_alb_security_group_egress_http_tags" {
  value       = try(aws_vpc_security_group_egress_rule.http.tags_all, "")
  description = "Map of all tags for the HTTP egress rule."
}

output "default_alb_security_group_egress_https_arn" {
  value       = try(aws_vpc_security_group_egress_rule.https[0].arn, "")
  description = "The default security group HTTPS egress rule ARN."
}

output "default_alb_security_group_egress_https_tags" {
  value       = try(aws_vpc_security_group_egress_rule.https[0].tags_all, "")
  description = "Map of all tags for the HTTPS egress rule."
}

output "default_alb_security_group_ingress_internet_http_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_http[0].arn, "")
  description = "The default security group internet http ingress rule ARN."
}

output "default_alb_security_group_ingress_internet_http_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_http[0].tags_all, "")
  description = "Map of all tags for the internet http ingress rule."
}

output "default_alb_security_group_ingress_internet_https_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_https[0].arn, "")
  description = "The default security group internet https ingress rule ARN."
}

output "default_alb_security_group_ingress_internet_https_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.internet_https[0].tags_all, "")
  description = "Map of all tags for the internet https ingress rule."
}

output "default_alb_security_group_ingress_http_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.http[0].arn, "")
  description = "The default security group http ingress rule ARN."
}

output "default_alb_security_group_ingress_http_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.http[0].tags_all, "")
  description = "Map of all tags for the HTTP ingress rule."
}

output "default_alb_security_group_ingress_https_arn" {
  value       = try(aws_vpc_security_group_ingress_rule.https[0].arn, "")
  description = "The default security group https ingress rule ARN."
}

output "default_alb_security_group_ingress_https_tags" {
  value       = try(aws_vpc_security_group_ingress_rule.https[0].tags_all, "")
  description = "Map of all tags for the HTTPS ingress rule."
}

## Default Target Group

output "default_alb_target_group_arn" {
  description = "The Amazon Resource Name (ARN) or ID of the default Target Group for the Application Load Balancer."
  value       = try(aws_lb_target_group.default.arn, "")
}

output "default_alb_target_group_arn_suffix" {
  description = "The ARN suffix of the default Target Group for the Application Load Balancer."
  value       = try(aws_lb_target_group.default.arn_suffix, "")
}

output "default_alb_target_group_name" {
  description = "The name of the default Target Group for the Application Load Balancer."
  value       = try(aws_lb_target_group.default.name, "")
}

output "default_alb_target_group_tags" {
  description = "Map with all tags for the default Target Group."
  value       = try(aws_lb_target_group.default.tags_all, {})
}

### Default Listeners

output "alb_listener_http_arn" {
  description = "ARN or ID of the Application Load Balancer's HTTP listener."
  value       = try(aws_lb_listener.http.arn, "")
}

output "alb_listener_http_tags" {
  description = "Map with all tags for the HTTP listener."
  value       = try(aws_lb_listener.http.tags_all, "")
}

output "alb_listener_https_arn" {
  description = "ARN or ID of the Application Load Balancer's HTTPS listener."
  value       = try(aws_lb_listener.https[0].arn, "")
}

output "alb_listener_https_tags" {
  description = "Map with all tags for the HTTPS listener."
  value       = try(aws_lb_listener.https[0].tags_all, "")
}

# ACM Certificate

output "cert_validation_id" {
  description = "The id of the certificate validation resource."
  value       = try(aws_acm_certificate_validation.fg_alb[0].id, "")
}

output "certificate_arn" {
  description = "The Amazon Resource Name (ARN) of the ACM certificate."
  value       = try(aws_acm_certificate.fg_alb[0].arn, "")
}

output "certificate_domain_name" {
  description = "The domain name for which the ACM certificate is issued."
  value       = try(aws_acm_certificate.fg_alb[0].domain_name, "")
}

output "certificate_start_date" {
  description = "Start of the validity period of the certificate."
  value       = try(aws_acm_certificate.fg_alb[0].not_before, "")
}

output "certificate_expiry_date" {
  description = "Expiration date and time of the certificate."
  value       = try(aws_acm_certificate.fg_alb[0].not_after, "")
}

output "certificate_status" {
  description = "Status of ACM certificate."
  value       = try(aws_acm_certificate.fg_alb[0].status, "")
}

output "certificate_type" {
  description = "Source of ACM certificate."
  value       = try(aws_acm_certificate.fg_alb[0].type, "")
}

output "certificate_tags" {
  description = "Map with all tags for ACM certificate."
  value       = try(aws_acm_certificate.fg_alb[0].tags_all, {})
}
