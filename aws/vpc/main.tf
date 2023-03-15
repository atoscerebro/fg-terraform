locals {
  az = ["a", "b", "c", "d"]
}

resource "aws_vpc" "fg_vpc" {
  cidr_block = var.vpc_cidr

  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    { "Name" = var.vpc_name },
    var.tags
  )
}

/* Public subnets */
resource "aws_subnet" "public" {
  count = var.availability_zones

  vpc_id                  = aws_vpc.fg_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = format("${var.aws_region}%s", element(local.az, count.index))
  map_public_ip_on_launch = false

  tags = merge(
    { "Name" = "${var.vpc_name}-public-${count.index + 1}" },
    var.tags
  )
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "default" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.fg_vpc.id

  tags = merge(
    { "Name" = "${var.vpc_name}-igw" },
    var.tags
  )
}

/* Routing table for public subnets */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.fg_vpc.id

  tags = merge(
    { "Name" = "${var.vpc_name}-public" },
    var.tags
  )
}

/* Add a route to the internet via the IG, if requested */
resource "aws_route" "public" {
  count = var.enable_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default[0].id
}

/* Associate the routing table to public subnets */
resource "aws_route_table_association" "public" {
  count = var.availability_zones

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

/* Private subnets */
resource "aws_subnet" "private" {
  count = var.availability_zones

  vpc_id                  = aws_vpc.fg_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1 + 10)
  availability_zone       = format("${var.aws_region}%s", element(local.az, count.index))
  map_public_ip_on_launch = false

  tags = merge(
    { "Name" = "${var.vpc_name}-private-${count.index + 1}" },
    var.tags
  )
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  count = var.availability_zones

  vpc_id = aws_vpc.fg_vpc.id

  tags = merge(
    { "Name" = "${var.vpc_name}-private-${count.index + 1}" },
    var.tags
  )
}

/* Associate the routing table to private subnets */
resource "aws_route_table_association" "private" {
  count = var.availability_zones

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name          = var.dhcp_domain_name
  domain_name_servers  = var.dhcp_dns_servers
  ntp_servers          = var.dhcp_ntp_servers
  netbios_name_servers = var.dhcp_netbios_name_servers
  netbios_node_type    = var.dhcp_netbios_node_type

  tags = var.tags
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = aws_vpc.fg_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.default.id
}

/* Default security group */
resource "aws_security_group" "default" {
  name        = "${var.vpc_name}-${var.env}-default"
  description = "Default security group that allows inbound and outbound traffic within the VPC"
  vpc_id      = aws_vpc.fg_vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "ingress_local" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress_local" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.default.id
}

/* Public security group */
resource "aws_security_group" "public" {
  name        = "${var.vpc_name}-${var.env}-public"
  description = "Security group for the public instances in the VPC"
  vpc_id      = aws_vpc.fg_vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "public_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
