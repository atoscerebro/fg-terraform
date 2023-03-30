# Key Pair

variable "public_key" {
  type        = string
  description = "A user-provided public ssh key for use in the aws_key_pair resource."
}

# Security Group

variable "security_group_name" {
  type        = string
  description = "Name of aws security group."
}

variable "security_group_description" {
  type        = string
  description = "Description of aws security group."
}

variable "vpc_id" {
  type        = string
  description = "VPC id for use in security group."
}

## Ingress rules

variable "https_ingress_ip_address" {
  type        = string
  description = "IP address to allow HTTPS access from"
  default     = "10.10.0.0/16"
}

variable "http_ingress_ip_address" {
  type        = string
  description = "IP address to allow HTTP access from"
  default     = "10.10.0.0/16"
}

variable "ssh_ingress_ip_address" {
  type        = string
  description = "IP address to allow SSH access from"
  default     = "0.0.0.0/0"
}

## Egress rules

variable "egress_ip_address" {
  type        = string
  description = "Allow outgoing traffic from the ec2 to anywhere"
  default     = "0.0.0.0/0"
}

# EC2 Instance

variable "ec2_count" {
  type        = number
  description = "The number of requested EC2 instances."
  default     = 1
}

// Hard-coded arbitrary ami image details for now - could provide user with a map of defaults?
variable "instance_ami_name" {
  type        = string
  description = "AMI name to use for the instance."
  default     = "al2023-ami-2023.0.20230315.0-kernel-6.1-x86_64"
}

variable "instance_ami_image_id" {
  type        = string
  description = "AMI image id to use for the instance."
  default     = "ami-0779c326801d5a843"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for the instance."
  // Hard-coded arbitrary value for now - update with more appropriate default.
  default = "t2.micro"
}

variable "user_data" {
  type        = string
  description = "User data to provide as a bash script when launching the instance. Default value null."
  default     = null
}

# Availability Zones

variable "az_count" {
  type        = number
  description = "The number of requested Availability Zones"
  default     = 1
}

# Tags

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "test"
}

variable "tags" {
  type        = map(any)
  description = ""
  default     = {}
}

variable "env" {
  description = "Environment: dev, test, stg, prod"
  type        = string
  default     = "dev"
}
