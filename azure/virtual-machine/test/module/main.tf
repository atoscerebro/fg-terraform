terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.41.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0.4"
    }
  }
}

provider "azurerm" {
  features {
  }
}

module "vm" {
  source                            = "./../.."
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  vm_size                           = var.vm_size
  virtual_network_name              = var.virtual_network_name
  subnet_name                       = var.subnet_name
  storage_os_disk_name              = var.storage_os_disk_name
  storage_os_disk_managed_disk_type = var.storage_os_disk_managed_disk_type
  admin_username                    = var.admin_username
  os_profile_admin_password         = var.os_profile_admin_password
  output_admin_private_key          = var.output_admin_private_key
  vm_storage_image_sku              = var.vm_storage_image_sku
  tags                              = var.tags
}
