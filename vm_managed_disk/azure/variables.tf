# Managed Disk

variable "name" {
  type        = string
  description = "The name of the managed disk."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group this managed disk belongs to."
}

variable "location" {
  type        = string
  description = "The location of the managed disk."

  validation {
    condition = contains([
      "westeurope"
    ], var.location)
    error_message = "Managed disk location must match option from provided list."
  }
}

variable "storage_account_type" {
  type        = string
  description = "The type of storage account which should be used for the managed disk."

  validation {
    condition = contains([
      "Standard_LRS",
      "StandardSSD_ZRS",
      "Premium_LRS",
      "PremiumV2_LRS",
      "Premium_ZRS",
      "StandardSSD_LRS",
      "UltraSSD_LRS"
    ], var.storage_account_type)
    error_message = "Managed disk storage account type must match option from provided list."
  }
}

variable "create_option" {
  type        = string
  description = "The method to use when creating the managed disk."

  validation {
    condition = contains([
      "Empty",
      "Copy",
      "FromImage",
      "Restore"
    ], var.create_option)
    error_message = "Create option must match option from the provided list."
  }
}

variable "source_resource_id" {
  type        = string
  description = "The id of an existing managed disk to either copy or restore. Requires create_option to be either Copy or Restore."
  default     = null
}

variable "image_reference_id" {
  type        = string
  description = "The id of an existing platform/marketplace disk image to copy. Requires create_option to be FromImage."
  default     = null
}

variable "disk_size_gb" {
  type        = number
  description = "The size of the managed disk in GB."
}

# Managed Disk Attachment

variable "virtual_machine_id" {
  type        = string
  description = "The id of the VM to attach the managed disk to."
}

variable "lun" {
  type        = number
  description = "The logical unit number of the managed disk. Each managed disk must have a unique lun."
}

variable "caching" {
  type        = string
  description = "The type of caching which should be used for the managed disk."

  validation {
    condition = contains([
      "None",
      "ReadOnly",
      "ReadWrite"
    ], var.caching)
    error_message = "Managed disk caching type must match option from provided list."
  }
}
