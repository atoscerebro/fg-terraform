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

variable "size" {
  type        = string
  description = "The SKU which should be used for this VM."

  validation {
    condition     = can(regex("^(Basic|Standard)_([A-Z]){1,2}(\\d){1,2}[\\d|_|-|a-zA-Z]*$", var.size))
    error_message = "Size must match the Azure SKU format."
  }
}

variable "network_interface_ids" {
  type        = list(string)
  description = "The list of network interface ids this VM belongs to."
}

# Authentication

variable "admin_username" {
  type        = string
  description = "The username of the admin on the VM."
}

variable "admin_password" {
  type        = string
  description = "The password of the admin user of the VM."
  sensitive   = true
}

variable "output_admin_private_key" {
  type        = bool
  description = "Indicate whether the private ssh key for the VM should be outputted by Terraform."
  default     = false
}

# OS Disk

variable "os_disk_caching" {
  type        = string
  description = "The type of caching which should be used for the internal OS disk."

  validation {
    condition = contains([
      "None",
      "ReadOnly",
      "ReadWrite"
    ], var.os_disk_caching)
    error_message = "OS disk caching type must match option from provided list."
  }
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "The type of storage account which should be used for the internal OS disk."

  validation {
    condition = contains([
      "Standard_LRS",
      "StandardSSD_LRS",
      "Premium_LRS",
      "StandardSSD_ZRS",
      "Premium_ZRS"
    ], var.os_disk_storage_account_type)
    error_message = "OS disk storage account type must match option from provided list."
  }
}

# Source Image Reference

variable "source_image_reference_sku" {
  type        = string
  description = "The SKU of the RHEL image offer used to create the VM."

  validation {
    condition = contains([
      "8.7",
      "9.1"
    ], var.source_image_reference_sku)
    error_message = "RHEL SKU must match option from provided list."
  }
}
