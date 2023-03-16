output "internal_alb_arn" {
  description = "The Amazon Resource Name (ARN) of the internal Application Load Balancer."
  value       = try(aws_lb.application.arn, "")
}

output "alb_default_target_group_arn" {
  description = "The Amazon Resource Name (ARN) of the Target Group for the Application Load Balancer."
  value       = try(aws_lb_target_group.default_internal.arn, "")
}

output "default_alb_security_group_id" {
  description = "The ID of the security group created by default with the Application Load Balancer."
  value       = try(aws_security_group.default_fg_alb.id, "")
}

# ACM Certificate

output "cert_validation_id" {
  description = "The id of the certificate validation resource."
  value       = try(aws_acm_certificate_validation.fg_alb.id, "")
}

output "certificate_arn" {
  description = "The Amazon Resource Name (ARN) of the ACM certificate."
  value       = try(aws_acm_certificate.fg_alb.arn, "")
}

output "certificate_domain_name" {
  description = "The domain name for which the ACM certificate is issued."
  value       = try(aws_acm_certificate.fg_alb.domain_name, "")
}

output "certificate_start_date" {
  description = "Start of the validity period of the certificate."
  value       = try(aws_acm_certificate.fg_alb.not_before, "")
}

output "certificate_expiry_date" {
  description = "Expiration date and time of the certificate."
  value       = try(aws_acm_certificate.fg_alb.not_after, "")
}

output "certificate_status" {
  description = "Status of ACM certificate."
  value       = try(aws_acm_certificate.fg_alb.status, "")
}

output "certificate_type" {
  description = "Source of ACM certificate."
  value       = try(aws_acm_certificate.fg_alb.type, "")
}

output "certificate_tags" {
  description = "Map with all tags for ACM certificate."
  value       = try(aws_acm_certificate.fg_alb.tags_all, {})
}
