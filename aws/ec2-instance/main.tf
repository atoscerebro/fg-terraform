locals {
  az = ["a", "b", "c", "d"]
}

# Key Pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${var.env}"
  public_key = var.public_key

  tags = var.tags
}

# Security Group

resource "aws_security_group" "fg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = var.tags
}

## Ingress Rules

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.fg.id

  description = "HTTPS ingress"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.https_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-https-${env}" },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.fg.id

  description = "HTTP ingress"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.http_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-http-${var.env}" },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.fg.id

  description = "SSH ingress"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.ssh_ingress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-ingress-ssh-${var.env}" },
    var.tags
  )
}

## Egress Rule:

resource "aws_vpc_security_group_egress_rule" "out" {
  security_group_id = aws_security_group.fg.id

  description = "Security group egress"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = var.egress_ip_address

  tags = merge(
    { "Name" = "${var.security_group_name}-egress-${var.env}" },
    var.tags
  )
}

# EC2 Instance

## Get AMI details
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "image-id"
    values = [var.instance_ami_image_id]
  }

  filter {
    name   = "name"
    values = [var.instance_ami_name]
  }
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

resource "aws_instance" "fg" {
  count = var.ec2_count
  // Uses modulo operator to spread ec2 instances through configured number of subnets.
  subnet_id                   = data.aws_subnets.private.ids[count.index % var.az_count]
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  // Uses modulo operator to spread ec2 instances through configured number of AZs.
  availability_zone       = format("${var.aws_region}%s", local.az[count.index % var.az_count])
  disable_api_termination = false
  monitoring              = true
  user_data               = var.user_data
  vpc_security_group_ids  = [aws_security_group.fg.id]

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sda"
  }


  tags = merge(
    { "Name" = "${var.vpc_name}-ec2-instance-${count.index + 1}-${var.env}", },
    var.tags
  )

  // TODO - Create Network Interface here or create separately and assign here?
}
