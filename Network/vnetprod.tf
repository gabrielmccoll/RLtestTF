resource "azurerm_resource_group" "prod" {
  name     = "prodvnet"
  location = var.location
}

resource "azurerm_virtual_network" "prod" {
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.prod.location
  name                = azurerm_resource_group.prod.name
  resource_group_name = azurerm_resource_group.prod.name

}

resource "azurerm_subnet" "prod" {
  address_prefixes                          = ["10.3.1.0/24"]
  name                                      = azurerm_resource_group.prod.name
  virtual_network_name                      = azurerm_virtual_network.prod.name
  resource_group_name                       = azurerm_resource_group.prod.name
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "prod" {
  name                = azurerm_resource_group.prod.name
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location

}

resource "azurerm_subnet_network_security_group_association" "prod" {
  subnet_id                 = azurerm_subnet.prod.id
  network_security_group_id = azurerm_network_security_group.prod.id
}
