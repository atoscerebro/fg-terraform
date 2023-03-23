terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.41.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  env_name = "virtual-machine-test-${var.id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.env_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.env_name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.env_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
