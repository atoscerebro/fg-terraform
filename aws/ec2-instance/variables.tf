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

variable "ssh_ip_address" {
  type        = string
  description = "IP address to allow SSH access from"
  default     = "0.0.0.0/0"
}

# EC2 Instance

// Hard-coded arbitrary ami image details for now - could provide user with a map of defaults?
variable "instance_ami_name" {
  type        = string
  description = "AMI name to use for the instance."
  default     = "amzn2-ami-minimal-hvm-2.0.20211001.1-arm64-ebs"
}

variable "instance_ami_image_id" {
  type        = string
  description = "AMI image id to use for the instance."
  default     = "ami-09e34b2574f465af6"
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
