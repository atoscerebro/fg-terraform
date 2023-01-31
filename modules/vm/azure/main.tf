resource "azurerm_virtual_machine" "vm" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_size               = var.vm_size
  network_interface_ids = var.network_interface_ids

  storage_image_reference {
    id = data.azurerm_platform_image.vm_storage_image.id
  }

  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.storage_os_disk_caching
    managed_disk_type = var.storage_os_disk_managed_disk_type
    create_option     = "FromImage"
    os_type           = "Linux"
  }

  # a comment

  os_profile {
    computer_name  = var.name
    admin_username = var.os_profile_admin_username
    admin_password = var.os_profile_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      key_data = tls_private_key.vm_private_key.public_key_pem
      path     = "/home/${var.os_profile_admin_username}/.ssh/authorized_keys"
    }
  }

  tags = var.tags
}

resource "tls_private_key" "vm_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
