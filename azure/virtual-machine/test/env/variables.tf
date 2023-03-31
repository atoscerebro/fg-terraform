variable "id" {
  description = "A unique string to identify the environment"
  type        = string
}

variable "location" {
  description = "The location to set up this environment"
  type        = string
  default     = "westeurope"
}
