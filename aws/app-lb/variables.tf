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

}

variable "ssl_cert_internal_domain" {

}

variable "s3_bucket" {
  // Is this needed? Used for access logs. If so, what type? ID?
}

variable "vpc_id" {
  type        = string
  description = "VPC id for us in target group and to retrieve subnets."
}

variable "tags" {
  description = ""
  default     = {}
}

