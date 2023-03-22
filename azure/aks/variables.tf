variable "agent_count" {
  type    = number
  default = 3
}

variable "cluster_name" {
  type = string
}

variable "dns_prefix" {
  type    = string
  default = "k8stest"
}

variable "aks_admin_group_object_ids" {
  type        = list(string)
  description = "The AAD object IDs to give administrative permissions to the cluster."
  default     = []
}

variable "resource_group_name" {
  type = string
}
