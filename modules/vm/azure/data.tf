data "azurerm_platform_image" "vm_storage_image" {
  location  = var.location
  publisher = "redhat"
  offer     = "rh-rhel"
  sku       = var.vm_storage_image_sku
}
