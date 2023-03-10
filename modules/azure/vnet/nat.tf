resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-gateway-ip"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "network-nat-gw"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_subnet_assoc" {
  subnet_id      = azurerm_subnet.private_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
