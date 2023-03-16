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

# Application Load Balancer 

resource "aws_lb" "application" {
  name               = var.alb_name
  internal           = var.alb_type_internal
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

## Default Security Group
resource "aws_security_group" "default_fg_alb" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = var.tags
}

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.default_fg_alb.id

  description = "Security group http egress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "HTTP"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-http-egress" },
    var.tags
  )
}

## Default Target Group
resource "aws_lb_target_group" "default" {
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

## Listeners
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.alb_name}-listener-http" },
    var.tags
  )
}

# ALB is external:

## Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "internet" {
  count = !var.alb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

  description = "Internet ingress"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = var.external_internet_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-internet" },
    var.tags
  )
}

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "https" {
  count = !var.alb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

  description = "Security group https egress"
  from_port   = 443
  to_port     = 443
  ip_protocol = "HTTPS"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-https-egress" },
    var.tags
  )
}

# ALB is internal:

## Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "http" {
  count = var.alb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

  description = "HTTP ingress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.internal_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-http" },
    var.tags
  )
}

# ALB is internal, and TLS enabled, OR ALB is external:

## Additional Listeners
resource "aws_lb_listener" "https" {
  count = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal)) ? 1 : 0

  load_balancer_arn = aws_lb.application.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_security_policy
  certificate_arn   = var.ssl_cert != null ? var.ssl_cert : aws_acm_certificate.fg_alb[count.index].arn

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.alb_name}-listener-https" },
    var.tags
  )
}

# ALB is internal, and TLS enabled:

## Additional Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "https" {
  count = (var.alb_type_internal && var.enable_internal_alb_tls) ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

  description = "HTTPS ingress"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.internal_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-https" },
    var.tags
  )
}

# ALB is internal, and TLS enabled:

## ACM Certificate
resource "aws_acm_certificate" "fg_alb" {
  count = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal && var.ssl_cert == null)) ? 1 : 0

  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  key_algorithm     = var.cert_key_algorithm
}

resource "aws_acm_certificate_validation" "fg_alb" {
  count = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal && var.ssl_cert == null)) ? 1 : 0

  certificate_arn = aws_acm_certificate.fg_alb[count.index].arn
}
