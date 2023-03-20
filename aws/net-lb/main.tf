## Get Private subnets from VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*private*"
  }
}

## Get Public subnets from VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*public*"
  }
}

# Network Load Balancer 

resource "aws_lb" "network" {
  name                             = var.nlb_name
  internal                         = var.nlb_type_internal
  load_balancer_type               = "network"
  security_groups                  = concat([aws_security_group.default_fg_nlb.id], var.nlb_security_group_ids)
  subnets                          = var.nlb_type_internal ? data.aws_subnets.private.ids : data.aws_subnets.public.ids
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  # access_logs {
  #   bucket  = var.s3_bucket.id
  #   prefix  = "fg-lb"
  #   enabled = true
  # }

  tags = var.tags
}

## Default Security Group
resource "aws_security_group" "default_fg_nlb" {
  name        = var.security_group_name
  description = "Default Network Load Balancer Security Group: ${var.security_group_name}"
  vpc_id      = var.vpc_id

  tags = var.tags
}

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.default_fg_nlb.id

  description = "Security group http egress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-egress-http" },
    var.tags
  )
}

## Default Target Group
resource "aws_lb_target_group" "default" {
  name     = "${var.nlb_name}-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    unhealthy_threshold = var.health_check.unhealthy_threshold
    healthy_threshold   = var.health_check.healthy_threshold
  }

  tags = var.tags
}

## Listeners
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.network.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.nlb_name}-listener-http" },
    var.tags
  )
}

# nlb is external:

## Ingress Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "internet_http" {
  count = !var.nlb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_nlb.id

  description = "Internet ingress http"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.external_internet_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-internet-http" },
    var.tags
  )
}

## Ingress Rule - HTTPS
resource "aws_vpc_security_group_ingress_rule" "internet_https" {
  count = !var.nlb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_nlb.id

  description = "Internet ingress https"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.external_internet_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-internet-https" },
    var.tags
  )
}

# nlb is internal:

## Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "http" {
  count = var.nlb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_nlb.id

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

# nlb is internal, and TLS enabled, OR nlb is external:

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "https" {
  count = ((var.nlb_type_internal && var.enable_internal_nlb_tls) || (!var.nlb_type_internal)) ? 1 : 0

  security_group_id = aws_security_group.default_fg_nlb.id

  description = "Security group https egress"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-egress-https" },
    var.tags
  )
}

## Additional Listeners
resource "aws_lb_listener" "https" {
  count = ((var.nlb_type_internal && var.enable_internal_nlb_tls) || (!var.nlb_type_internal)) ? 1 : 0

  load_balancer_arn = aws_lb.network.arn
  port              = "443"
  protocol          = "TCP"
  ssl_policy        = var.ssl_security_policy
  certificate_arn   = var.ssl_cert != null ? var.ssl_cert : aws_acm_certificate.fg_nlb[count.index].arn

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.nlb_name}-listener-https" },
    var.tags
  )
}

# nlb is internal, and TLS enabled:

## Additional Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "https" {
  count = (var.nlb_type_internal && var.enable_internal_nlb_tls) ? 1 : 0

  security_group_id = aws_security_group.default_fg_nlb.id

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

# nlb is internal, and TLS enabled:

## ACM Certificate
resource "aws_acm_certificate" "fg_nlb" {
  count = ((var.nlb_type_internal && var.enable_internal_nlb_tls) || (!var.nlb_type_internal && var.ssl_cert == null)) ? 1 : 0

  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  key_algorithm     = var.cert_key_algorithm


  tags = merge(
    { "Name" = "${var.nlb_name}-acm-certificate" },
    var.tags
  )
}

resource "aws_acm_certificate_validation" "fg_nlb" {
  count = ((var.nlb_type_internal && var.enable_internal_nlb_tls) || (!var.nlb_type_internal && var.ssl_cert == null)) ? 1 : 0

  certificate_arn = aws_acm_certificate.fg_nlb[count.index].arn
}
