data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "tls_private_key" "github_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = data.azurerm_resource_group.resource_group.location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled     = true
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = trimspace(tls_private_key.github_ssh_key.public_key_openssh)
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}
