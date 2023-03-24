## Conditions for different use-cases
locals {
  ### Access logging is enabled, but no S3 Bucket is provided to store the logs:
  access_logs_new_bucket = (var.enable_access_logging && (var.s3_bucket_id == "")) ? 1 : 0

  ### Network Load Balancer is internal:
  nlb_internal = var.nlb_type_internal ? 1 : 0

  ### NLB is internal and TLS is enabled, OR NLB is external:
  nlb_internal_tls_or_external = ((var.nlb_type_internal && var.enable_internal_nlb_tls) || (!var.nlb_type_internal)) ? 1 : 0

  ### NLB is internal, TLS is enabled, and no SSL certificate is provided, OR NLB is external and no SSL cert provided:
  nlb_internal_tls_no_cert_or_external_no_cert = ((var.nlb_type_internal && var.enable_internal_nlb_tls && var.ssl_cert == null) || (!var.nlb_type_internal && var.ssl_cert == null)) ? 1 : 0
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

# Network Load Balancer 

resource "aws_lb" "network" {
  name                             = var.nlb_name
  internal                         = var.nlb_type_internal
  load_balancer_type               = "network"
  subnets                          = var.nlb_type_internal ? data.aws_subnets.private.ids : data.aws_subnets.public.ids
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  dynamic "access_logs" {
    for_each = var.enable_access_logging ? { enabled = true } : {}
    content {
      bucket  = var.s3_bucket_id != "" ? var.s3_bucket_id : aws_s3_bucket.fg_nlb_access_logs[0].id
      enabled = var.enable_access_logging
    }
  }

  tags = var.tags
}

## Optional S3 Bucket Resources for Access Logs

resource "aws_s3_bucket" "fg_nlb_access_logs" {
  count         = local.access_logs_new_bucket
  bucket        = "${var.nlb_name}-access-logs"
  force_destroy = var.force_destroy_nlb_access_logs
}

resource "aws_s3_bucket_acl" "fg_nlb_access_logs" {
  count  = local.access_logs_new_bucket
  bucket = aws_s3_bucket.fg_nlb_access_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "fg_nlb_access_logs" {
  count  = local.access_logs_new_bucket
  bucket = aws_s3_bucket.fg_nlb_access_logs[0].id
  policy = data.aws_iam_policy_document.allow_nlb_write_to_bucket[0].json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_nlb_write_to_bucket" {
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
      "${aws_s3_bucket.fg_nlb_access_logs[0].arn}/*"
    ]
  }
}

## Default Target Group
resource "aws_lb_target_group" "default" {
  name        = "${var.nlb_name}-tg"
  port        = var.nlb_type_internal ? 80 : 443
  protocol    = var.default_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.default_target_type

  health_check {
    timeout             = var.nlb_type_internal ? var.health_check_80.timeout : var.health_check_443.timeout
    interval            = var.nlb_type_internal ? var.health_check_80.interval : var.health_check_443.interval
    port                = var.nlb_type_internal ? var.health_check_80.port : var.health_check_443.port
    protocol            = var.nlb_type_internal ? var.health_check_80.protocol : var.health_check_443.protocol
    unhealthy_threshold = var.nlb_type_internal ? var.health_check_80.unhealthy_threshold : var.health_check_443.unhealthy_threshold
    healthy_threshold   = var.nlb_type_internal ? var.health_check_80.healthy_threshold : var.health_check_443.healthy_threshold
  }

  tags = var.tags
}


# NLB is internal:

## Listener
resource "aws_lb_listener" "http" {
  count = local.nlb_internal

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

# NLB is internal, and TLS enabled, OR NLB is external:

## Listener
resource "aws_lb_listener" "https" {
  count = local.nlb_internal_tls_or_external

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

# NLB is internal and TLS enabled and no SSL Cert provided, OR NLB is external and no Cert.

## ACM Certificate
resource "aws_acm_certificate" "fg_nlb" {
  count = local.nlb_internal_tls_no_cert_or_external_no_cert

  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  key_algorithm     = var.cert_key_algorithm


  tags = merge(
    { "Name" = "${var.nlb_name}-acm-certificate" },
    var.tags
  )
}

resource "aws_acm_certificate_validation" "fg_nlb" {
  count           = local.nlb_internal_tls_no_cert_or_external_no_cert
  certificate_arn = aws_acm_certificate.fg_nlb[count.index].arn
}
