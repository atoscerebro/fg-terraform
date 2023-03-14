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
  security_groups    = var.alb_security_group_ids
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
    target_group_arn = aws_lb_target_group.internal.arn
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
    target_group_arn = aws_lb_target_group.internal.arn
    type             = "forward"
  }

  tags = merge(
    { "Name" = "${var.alb_name}-listener-internal-443" },
    var.tags
  )
}

resource "aws_lb_target_group" "internal" {
  name     = "${var.alb_name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 10
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }

  tags = var.tags
}

// Do we need to create security group here as well, or will we pass in an existing one e.g. as defined in EC2 module?

