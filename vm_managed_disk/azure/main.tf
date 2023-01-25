resource "azurerm_managed_disk" "vm_managed_disk" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  source_resource_id   = var.source_resource_id
  image_reference_id   = var.image_reference_id
  disk_size_gb         = var.disk_size_gb

  tags       = var.tags
  depends_on = [var.dependencies]
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_managed_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.vm_managed_disk.id
  virtual_machine_id = var.virtual_machine_id
  lun                = var.lun
  caching            = var.caching
}
