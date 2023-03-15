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
