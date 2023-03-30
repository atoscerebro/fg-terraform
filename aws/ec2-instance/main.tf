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
    { "Name" = "${var.security_group_name}-ingress-https-${var.env}" },
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
  from_port   = -1
  to_port     = -1
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

data "aws_iam_instance_profile" "ssm_managed" {
  name = var.iam_instance_profile
}

## Get available availability zones using region configured in provider
data "aws_availability_zones" "available" {
  state = "available"
}

## Get Private subnets from VPC
data "aws_subnet" "private" {
  count = var.ec2_count

  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.available.names[count.index % var.az_count]

  tags = {
    Name = "*private*"
  }
}

resource "aws_instance" "fg" {
  count = var.ec2_count
  // Uses modulo operator to spread ec2 instances through configured number of subnets.
  subnet_id                   = data.aws_subnet.private[count.index % var.az_count].id
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  iam_instance_profile        = data.aws_iam_instance_profile.ssm_managed.id
  // Uses modulo operator to spread ec2 instances through configured number of AZs.
  availability_zone       = data.aws_subnet.private[count.index % var.az_count].availability_zone
  disable_api_termination = false
  monitoring              = true
  user_data               = var.user_data
  vpc_security_group_ids  = [aws_security_group.fg.id]
  key_name                = aws_key_pair.deployer.key_name

  tags = merge(
    { "Name" = "${var.vpc_name}-ec2-instance-${count.index + 1}-${var.env}", },
    var.tags
  )

  // TODO - Create Network Interface here or create separately and assign here?
}
