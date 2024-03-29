## Conditions for different use-cases
locals {
  ### Access logging is enabled, but no S3 Bucket is provided to store the logs:
  access_logs_new_bucket = (var.enable_access_logging && (var.s3_bucket_id == "")) ? 1 : 0

  ### Application Load Balancer is internal:
  alb_internal = var.alb_type_internal ? 1 : 0

  ### Application Load Balancer is external:
  alb_external = !var.alb_type_internal ? 1 : 0

  ### ALB is internal and TLS is enabled:
  alb_internal_tls = (var.alb_type_internal && var.enable_internal_alb_tls) ? 1 : 0

  ### ALB is internal and TLS is enabled, OR ALB is external:
  alb_internal_tls_or_external = ((var.alb_type_internal && var.enable_internal_alb_tls) || (!var.alb_type_internal)) ? 1 : 0

  ### ALB is internal, TLS is enabled, and no SSL certificate is provided, OR ALB is external and no SSL cert provided:
  alb_internal_tls_no_cert_or_external_no_cert = ((var.alb_type_internal && var.enable_internal_alb_tls && var.ssl_cert == null) || (!var.alb_type_internal && var.ssl_cert == null)) ? 1 : 0
}

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

  dynamic "access_logs" {
    for_each = var.enable_access_logging ? { enabled = true } : {}
    content {
      bucket  = var.s3_bucket_id != "" ? var.s3_bucket_id : aws_s3_bucket.fg_alb_access_logs[0].id
      enabled = var.enable_access_logging
    }

  }

  tags = var.tags
}

## Optional S3 Bucket Resources for Access Logs

resource "aws_s3_bucket" "fg_alb_access_logs" {
  count         = local.access_logs_new_bucket
  bucket        = "${var.alb_name}-access-logs"
  force_destroy = var.force_destroy_alb_access_logs
}

resource "aws_s3_bucket_acl" "fg_alb_access_logs" {
  count  = local.access_logs_new_bucket
  bucket = aws_s3_bucket.fg_alb_access_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "fg_alb_access_logs" {
  count  = local.access_logs_new_bucket
  bucket = aws_s3_bucket.fg_alb_access_logs[0].id
  policy = data.aws_iam_policy_document.allow_alb_write_to_bucket[0].json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_alb_write_to_bucket" {
  count = local.access_logs_new_bucket

  version = "2012-10-17"
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.fg_alb_access_logs[0].arn}/*"
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
resource "aws_vpc_security_group_egress_rule" "default" {
  security_group_id = aws_security_group.default_fg_alb.id

  description = "Security group default egress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-egress-default" },
    var.tags
  )
}

## Default Target Group
resource "aws_lb_target_group" "default" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.default_target_type

  health_check {
    timeout             = var.http_health_check.timeout
    interval            = var.http_health_check.interval
    path                = var.http_health_check.path
    port                = var.http_health_check.port
    protocol            = var.http_health_check.protocol
    matcher             = var.http_health_check.matcher
    unhealthy_threshold = var.http_health_check.unhealthy_threshold
    healthy_threshold   = var.http_health_check.healthy_threshold
  }

  tags = var.tags
}

# ALB is internal:

## Listener
resource "aws_lb_listener" "http" {
  count = local.alb_internal

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

## Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "http" {
  count = local.alb_internal

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

# ALB is external:

## Ingress Rule - HTTPS
resource "aws_vpc_security_group_ingress_rule" "internet_https" {
  count = local.alb_external

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

# ALB is internal, and TLS enabled, OR ALB is external:

## Additional Listeners
resource "aws_lb_listener" "https" {
  count = local.alb_internal_tls_or_external

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

## Egress Rule:
resource "aws_vpc_security_group_egress_rule" "https" {
  count = local.alb_internal_tls

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

## Additional Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "https" {
  count = local.alb_internal_tls

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

# ALB is internal and TLS enabled and no SSL Cert provided, OR ALB is external and no Cert.

## Route53

resource "aws_route53_record" "fg_alb" {
  count = local.alb_internal_tls_no_cert_or_external_no_cert

  allow_overwrite = true
  name            = tolist(aws_acm_certificate.fg_alb[0].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.fg_alb[0].domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.fg_alb[0].domain_validation_options)[0].resource_record_type
  zone_id         = var.dns_zone_id
  ttl             = 60
}

## ACM Certificate
resource "aws_acm_certificate" "fg_alb" {
  count = local.alb_internal_tls_no_cert_or_external_no_cert

  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  key_algorithm     = var.cert_key_algorithm

  tags = merge(
    { "Name" = "${var.alb_name}-acm-certificate" },
    var.tags
  )
}

resource "aws_acm_certificate_validation" "fg_alb" {
  count = local.alb_internal_tls_no_cert_or_external_no_cert

  certificate_arn         = aws_acm_certificate.fg_alb[0].arn
  validation_record_fqdns = [aws_route53_record.fg_alb[0].fqdn]
}
