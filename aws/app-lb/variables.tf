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

variable "s3_bucket_id" {
  // Is this needed? Used for access logs.
  type        = string
  description = "ID of the S3 bucket used to store the logs in."
}

variable "vpc_id" {
  type        = string
  description = "VPC id for us in target group and to retrieve subnets."
}

variable "tags" {
  description = ""
  default     = {}
}

