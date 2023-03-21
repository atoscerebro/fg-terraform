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

# Application Load Balancer 

resource "aws_lb" "application" {
  name               = var.alb_name
  internal           = var.alb_type_internal
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.default_fg_alb.id], var.alb_security_group_ids)
  subnets            = var.alb_type_internal ? data.aws_subnets.private.ids : data.aws_subnets.public.ids

  access_logs {
    bucket  = var.s3_bucket != "" ? var.s3_bucket.id : var.enable_access_logging ? aws_s3_bucket.fg_alb_access_logs[0].id : ""
    prefix  = "fg-alb"
    enabled = var.enable_access_logging
  }

  tags = var.tags
}

## Optional S3 Bucket Resources for Access Logs

resource "aws_s3_bucket" "fg_alb_access_logs" {
  count  = (var.enable_access_logging && (var.s3_bucket == "")) ? 1 : 0
  bucket = "fg-alb-access-logs"
}

resource "aws_s3_bucket_acl" "fg_alb_access_logs" {
  count  = (var.enable_access_logging && (var.s3_bucket == "")) ? 1 : 0
  bucket = aws_s3_bucket.fg_alb_access_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "fg_alb_access_logs" {
  count  = (var.enable_access_logging && (var.s3_bucket == "")) ? 1 : 0
  bucket = aws_s3_bucket.fg_alb_access_logs[0].id
  policy = data.aws_iam_policy_document.allow_alb_write_to_bucket.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_alb_write_to_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.fg_alb_access_logs.arn
    ]
  }
}


## Default Security Group
resource "aws_security_group" "default_fg_alb" {
  name        = var.security_group_name
  description = "Default Application Load Balancer Security Group: ${var.security_group_name}"
  vpc_id      = var.vpc_id

  tags = var.tags
}

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.default_fg_alb.id

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
  name     = "${var.alb_name}-tg"
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

## Ingress Rule - HTTP
resource "aws_vpc_security_group_ingress_rule" "internet_http" {
  count = !var.alb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

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
  count = !var.alb_type_internal ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

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

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "https" {
  count = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal)) ? 1 : 0

  security_group_id = aws_security_group.default_fg_alb.id

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


  tags = merge(
    { "Name" = "${var.alb_name}-acm-certificate" },
    var.tags
  )
}

resource "aws_acm_certificate_validation" "fg_alb" {
  count = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal && var.ssl_cert == null)) ? 1 : 0

  certificate_arn = aws_acm_certificate.fg_alb[count.index].arn
}
