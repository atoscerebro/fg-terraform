locals {
  resource_group_name = "demo-rg"
  vnet_name           = "test-vnet"
}

module "vnet" {
  source              = "../azure/vnet"
  vnet_name           = local.vnet_name
  resource_group_name = local.resource_group_name
}

module "vm" {
  source                            = "../azure/virtual-machine"
  name                              = "demo-vm"
  resource_group_name               = local.resource_group_name
  location                          = "westeurope"
  storage_os_disk_name              = "osdisk"
  storage_os_disk_managed_disk_type = "Standard_LRS"
  admin_username                    = "atos"
  os_profile_admin_password         = "Drowssap123"
  subnet_name                       = "private"
  virtual_network_name              = local.vnet_name
  tags = {
    AtosManaged : true
  }

  depends_on = [
    module.vnet
  ]
}

module "aks" {
  source              = "../azure/aks"
  cluster_name        = "demo-aks"
  resource_group_name = "demo-rg"
}
