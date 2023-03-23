output "web_acl_id" {
  value = try(aws_wafv2_web_acl.fg_web_acl_alb.id, "")
}

output "web_acl_arn" {
  value = try(aws_wafv2_web_acl.fg_web_acl_alb.arn, "")
}

output "web_acl_capacity" {
  value = try(aws_wafv2_web_acl.fg_web_acl_alb.capacity, "")
}

output "web_acl_tags" {
  value = try(aws_wafv2_web_acl.fg_web_acl_alb.tags_all, "")
}
