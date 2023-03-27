variable "aws_region" {
  description = "The AWS Geographycal Region in which to create the VPC"
  type        = string
  default     = "eu-west-1"
}
variable "env" {
  description = "Environment of the VPC: dev, test, stg, prod"
  type        = string
  default     = "dev"
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "test"
}
variable "vpc_cidr" {
  description = "CIDR of the VPC, we are starting with a /16"
  type        = string
  default     = "10.10.0.0/16"
}
variable "availability_zones" {
  description = "The number of Availability Zones to create"
  type        = number
  default     = 1
}
variable "enable_dns_hostnames" {
  description = "Enable assigning DNS hostnames to instances with public IP address"
  type        = bool
  default     = false
}
variable "enable_dns_support" {
  description = "Enable asigning internal DNS hostnames through AWS provided DNS server"
  type        = bool
  default     = true
}
variable "enable_internet_gateway" {
  description = "Allow the public subnets to have access to the internet"
  type        = bool
  default     = false
}
variable "enable_nat_gateway" {
  description = "Allow the public subnets to have access to the internet"
  type        = bool
  default     = false
}
variable "instance_tenancy" {
  description = "Ensures that EC2 instances use the tenancy specified with launching"
  type        = string
  default     = "default"
}
variable "dhcp_domain_name" {
  description = "Suffix domain name by default"
  type        = string
  default     = ""
}
variable "dhcp_dns_servers" {
  description = "DNS servers for the instances within the VPC"
  type        = list(any)
  default     = ["AmazonProvidedDNS"]
}
variable "dhcp_ntp_servers" {
  description = "NTP servers for the instances within the VPC"
  type        = list(any)
  default     = []
}
variable "dhcp_netbios_name_servers" {
  description = "For Windows Instances: The friendly name assigned to an instance"
  type        = list(any)
  default     = []
}
variable "dhcp_netbios_node_type" {
  description = "For Windows Instances: how the instance will resolve netbios names to IP addresses"
  type        = number
  default     = 2
}
variable "tags" {
  description = "Useful to diferentiate resources per env, team, function ..."
  type        = map(any)
  default     = {}
}
