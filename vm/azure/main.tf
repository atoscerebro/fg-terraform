resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  network_interface_ids = var.network_interface_ids

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  admin_ssh_key {
    public_key = tls_private_key.vm_private_key.public_key_pem
    username   = var.admin_username
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "Redhat"
    offer     = "RHEL"
    sku       = var.source_image_reference_sku
    version   = "latest"
  }
}

resource "tls_private_key" "vm_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
