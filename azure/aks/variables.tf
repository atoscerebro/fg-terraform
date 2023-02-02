variable "agent_count" {
  type    = number
  default = 3
}

# The following two variable declarations are placeholder references.
# Set the values for these variable in terraform.tfvars
variable "aks_service_principal_app_id" {
  type = string
}

variable "aks_service_principal_client_secret" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  default = "k8stest"
}

variable "aks_admin_group_object_ids" {
  type        = list(string)
  description = "The AAD object IDs to give administrative permissions to the cluster."
  default     = []
}
