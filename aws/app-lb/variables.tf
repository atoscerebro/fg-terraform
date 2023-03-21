# Application Load Balancer 

variable "alb_type_internal" {
  type        = bool
  description = "Boolean to specify whether type of ALB is internal. True == internal; false == external."
  default     = true
}

variable "alb_name" {
  type        = string
  description = "Name of the Application Load Balancer."
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "List of additional Security Group IDs for ALB."
  default     = []
}

variable "enable_access_logging" {
  type        = bool
  description = "Boolean to specify whether to store access logs for the ALB."
}

variable "s3_bucket_id" {
  type        = string
  description = "Name/ID of the S3 bucket to store the logs in. If none is passed in by user, a new S3 bucket will be created."
  default     = ""
}

variable "force_destroy_alb_access_logs" {
  type        = bool
  description = "Boolean to specify whether to force destroy access_logs when s3 bucket is destroyed - when false, s3 bucket cannot be destroyed without error."
  default     = true
}

## Health Check

variable "health_check" {
  type        = map(string)
  description = "Map describing Health Check settings - including endpoint (default /) and port (default 80)."
  default = {
    timeout             = "10"
    interval            = "20"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    matcher             = "200"
    unhealthy_threshold = "2"
    healthy_threshold   = "3"
  }
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

## Ingress rule

variable "internal_ingress_ip_address" {
  type        = string
  description = "IP address to allow internal ALB access from."
  default     = "10.0.0.0/16"
}

variable "external_internet_ingress_ip_address" {
  type        = string
  description = "IP address to allow external ALB HTTPS access from."
  default     = "0.0.0.0/0"
}

## Egress rules

variable "egress_ip_address" {
  type        = string
  description = "IP address to allow HTTP access to."
  default     = "10.0.0.0/16"
}

# Internal TLS enabled:

variable "enable_internal_alb_tls" {
  type        = bool
  description = "Boolean to specify whether to enable TLS for the Internal Application Load Balancer. (External ALB has TLS enabled by default.)"
  default     = false
}

## SSL parameters

variable "ssl_security_policy" {
  type        = string
  description = "Name of SSL Policy for internal HTTPS listener."
  default     = "ELBSecurityPolicy-2016-08"
}

variable "ssl_cert" {
  type        = string
  description = "Optional ARN of custom SSL server certificate. If this field is not specified module will create an Amazon-issued ACM certificate."
  default     = null
}

## ACM Certificate

variable "cert_validation_method" {
  type        = string
  description = "The validation method used to approve ACM certificate used in ALB - DNS, EMAIL, or NONE are valid values."
  default     = "EMAIL"
}

variable "cert_domain_name" {
  type        = string
  description = "Domain name for which the certificate should be issued."
  default     = "test.com"
}

variable "cert_key_algorithm" {
  type        = string
  description = "The algorithm of the public and private key pair that the Amazon-issued certificate uses to encrypt data."
  default     = "RSA_2048"
}
