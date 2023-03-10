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
  default     = "Standard_DS1_v2"
  description = "The SKU which should be used for this VM."
}

variable "virtual_network_name" {
  type        = string
  description = "The vnet to place the VM into."
}

variable "subnet_name" {
  type        = string
  description = "The subnet to place the VM into."
}

# Storage OS Disk

variable "storage_os_disk_name" {
  type        = string
  description = "The name of the internal OS disk."
}

variable "storage_os_disk_managed_disk_type" {
  type        = string
  description = "The type of storage account which should be used for the internal OS disk."
  default     = "Standard_LRS"
}

# OS Profile

variable "admin_username" {
  type        = string
  description = "The username of the admin on the VM."
}

variable "os_profile_admin_password" {
  type        = string
  description = "The password of the admin user of the VM."
  sensitive   = true
  default     = null
}

variable "output_admin_private_key" {
  type        = bool
  description = "Indicate whether the private ssh key for the VM should be outputted by Terraform."
  default     = true
}

# Source Image Reference

variable "vm_storage_image_sku" {
  type        = string
  description = "The SKU of the rh-rhel image offer used to create the VM."
  default     = "9-lvm"

  validation {
    condition     = startswith(var.vm_storage_image_sku, "9") || startswith(var.vm_storage_image_sku, "8")
    error_message = "RHEL SKU must match option from provided list."
  }
}

# Tags

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to apply to this VM."
  default     = null
}
