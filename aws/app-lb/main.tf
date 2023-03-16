## Get Private subnets from VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}

# Internal Application Load Balancer 

resource "aws_lb" "application" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.default_fg_alb.id], var.alb_security_group_ids)
  subnets            = data.aws_subnets.private.ids

  access_logs {
    bucket  = var.s3_bucket_id
    prefix  = "fg-lb"
    enabled = true
  }

  tags = var.tags
}

resource "aws_lb_listener" "internal_80" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default_internal.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.alb_name}-listener-internal-80" },
    var.tags
  )
}

resource "aws_lb_listener" "internal_443" {
  load_balancer_arn = aws_lb.application.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_internal_security_policy
  certificate_arn   = var.ssl_cert_internal_domain

  default_action {
    target_group_arn = aws_lb_target_group.default_internal.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.alb_name}-listener-internal-443" },
    var.tags
  )
}

resource "aws_lb_target_group" "default_internal" {
  name     = "${var.alb_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    matcher             = var.health_check.matcher
    unhealthy_threshold = var.health_check.unhealthy_threshold
    healthy_threshold   = var.health_check.healthy_threshold
  }

  tags = var.tags
}

# Security Group

resource "aws_security_group" "default_fg_alb" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = var.tags
}

## Ingress Rules

// Am assuming we don't need an ssh ingress rule for the alb.

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.default_fg_alb.id

  description = "HTTPS ingress"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.https_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-https" },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.default_fg_alb.id

  description = "HTTP ingress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.http_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-http" },
    var.tags
  )
}

## Egress Rule:

// allows HTTP access to target-group port 80
resource "aws_vpc_security_group_egress_rule" "out" {
  security_group_id = aws_security_group.default_fg_alb.id

  description = "Security group egress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "HTTP"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-egress" },
    var.tags
  )
}

# ACM Certificate

resource "aws_acm_certificate" "fg_alb" {
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  key_algorithm     = var.cert_key_algorithm
}

resource "aws_acm_certificate_validation" "fg_alb" {
  certificate_arn = aws_acm_certificate.fg_alb.arn
}
