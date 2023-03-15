# Internal Application Load Balancer 

variable "alb_name" {
  type        = string
  description = "Name of the Application Load Balancer"
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs for ALB."
  default     = [""]
}

variable "ssl_internal_security_policy" {
  type        = string
  description = "Name of SSL Policy for internal HTTPS listener."
}

variable "ssl_cert_internal_domain" {
  type        = string
  description = "ARN of the default SSL server certificate."
}

variable "s3_bucket_id" {
  // Is this needed? Used for access logs.
  type        = string
  description = "ID of the S3 bucket used to store the logs in."
}

variable "vpc_id" {
  type        = string
  description = "VPC id for use in target group, security group and to retrieve subnets."
}

variable "tags" {
  description = ""
  default     = {}
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

## Ingress rules

variable "https_ingress_ip_address" {
  type        = string
  description = "IP address to allow HTTPS access from"
  default     = "10.0.0.0/16"
}

variable "http_ingress_ip_address" {
  type        = string
  description = "IP address to allow HTTP access from"
  default     = "10.0.0.0/16"
}

## Egress rules

variable "egress_ip_address" {
  type        = string
  description = "IP address to allow HTTPS access to"
  default     = "10.0.0.0/16"
}
