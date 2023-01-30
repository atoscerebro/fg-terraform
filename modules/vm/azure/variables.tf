# Base Setup

variable "name" {
  type        = string
  description = "The name of the VM."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group this VM belongs to."
}

variable "location" {
  type        = string
  description = "The location of the VM."

  validation {
    condition = contains([
      "westeurope"
    ], var.location)
    error_message = "VM location must match option from provided list."
  }
}

variable "vm_size" {
  type        = string
  description = "The SKU which should be used for this VM."
}

variable "network_interface_ids" {
  type        = list(string)
  description = "The list of network interface ids this VM belongs to."
}

# Storage OS Disk

variable "storage_os_disk_name" {
  type        = string
  description = "The name of the internal OS disk."
}

variable "storage_os_disk_caching" {
  type        = string
  description = "The type of caching which should be used for the internal OS disk."
}

variable "storage_os_disk_managed_disk_type" {
  type        = string
  description = "The type of storage account which should be used for the internal OS disk."
}

# OS Profile

variable "os_profile_admin_username" {
  type        = string
  description = "The username of the admin on the VM."
}

variable "os_profile_admin_password" {
  type        = string
  description = "The password of the admin user of the VM."
  sensitive   = true
}

variable "output_admin_private_key" {
  type        = bool
  description = "Indicate whether the private ssh key for the VM should be outputted by Terraform."
  default     = false
}

# Source Image Reference

variable "vm_storage_image_sku" {
  type        = string
  description = "The SKU of the rh-rhel image offer used to create the VM."

  validation {
    condition = contains([
      "rh-rhel8",
      "rh-rhel9"
    ], var.vm_storage_image_sku)
    error_message = "RHEL SKU must match option from provided list."
  }
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this VM."
  default     = null
}
