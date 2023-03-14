variable "aws_region" {
  description = "The AWS Geographycal Region in which to create the VPC"
  default     = "eu-west-1"
}
variable "env" {
  description = "Environment of the VPC: dev, test, stg, prod"
  default     = "dev"
}
variable "vpc_name" {
  description = "Name of the VPC"
  default     = "test"
}
variable "vpc_cidr" {
  description = "CIDR of the VPC, we are starting with a /16"
  default     = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "The number of Availability Zones to create"
  default     = 1
}
variable "enable_dns_hostnames" {
  description = "Enable assigning DNS hostnames to instances with public IP address"
  default     = false
}
variable "enable_dns_support" {
  description = "Enable asigning internal DNS hostnames through AWS provided DNS server"
  default     = true
}
variable "internet_gateway_enable" {
  description = "Allow the public subnets to have access to the internet"
  default     = false
}
variable "instance_tenancy" {
  description = "Ensures that EC2 instances use the tenancy specified with launching"
  default     = "default"
}
variable "dhcp_domain_name" {
  description = "Suffix domain name by default"
  default     = ""
}
variable "dhcp_dns_servers" {
  description = "DNS servers for the instances within the VPC"
  default     = ["AmazonProvidedDNS"]
}
variable "dhcp_ntp_servers" {
  description = "NTP servers for the instances within the VPC"
  default     = []
}
variable "dhcp_netbios_name_servers" {
  description = "For Windows Instances: The friendly name assigned to an instance"
  default     = []
}
variable "dhcp_netbios_node_type" {
  description = "For Windows Instances: how the instance will resolve netbios names to IP addresses"
  default     = 2
}
variable "tags" {
  description = ""
  default     = ""
}
