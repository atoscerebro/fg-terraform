data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "private_subnet" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.resource_group.name

  name             = "private"
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-nsg"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
}

resource "azurerm_network_security_rule" "private_disallow_inbound_internet" {
  resource_group_name         = data.azurerm_resource_group.resource_group.name
  name                        = "Disallow inbound internet access"
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  priority                    = 500
  destination_port_range      = "*"
  source_port_range           = "*"
  source_address_prefix = "*"
    destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "private_allow_loadbalancers" {
  resource_group_name         = data.azurerm_resource_group.resource_group.name
  name                        = "Allow inbound internet access from ALB"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "AzureLoadBalancer"
  network_security_group_name = azurerm_network_security_group.private_nsg.name
  priority                    = 400
  destination_port_range      = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_subnet" "public_subnet" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.resource_group.name

  name             = "public"
  address_prefixes = ["10.0.1.0/24"]
}