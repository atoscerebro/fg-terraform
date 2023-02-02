data "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "default_nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.default_nic.id]

  source_image_reference {
    publisher = "redhat"
    offer     = "RHEL"
    sku       = var.vm_storage_image_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.storage_os_disk_managed_disk_type
    caching              = "ReadOnly"
  }

  admin_username                  = var.admin_username
  admin_password                  = var.os_profile_admin_password
  disable_password_authentication = var.os_profile_admin_password == null


  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm_private_key.public_key_openssh
  }

  tags = var.tags
}

resource "tls_private_key" "vm_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

provider "azurerm" {
  features {

  }
}