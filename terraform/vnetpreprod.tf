resource "azurerm_resource_group" "preprod" {
  name     = "preprodvnet"
  location = var.location
}

resource "azurerm_virtual_network" "preprod" {
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.preprod.location
  name                = azurerm_resource_group.preprod.name
  resource_group_name = azurerm_resource_group.preprod.name

}

resource "azurerm_subnet" "preprod" {
  address_prefixes                          = ["10.1.1.0/24"]
  name                                      = azurerm_resource_group.preprod.name
  virtual_network_name                      = azurerm_virtual_network.preprod.name
  resource_group_name                       = azurerm_resource_group.preprod.name
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "preprod" {
  name                = azurerm_resource_group.preprod.name
  resource_group_name = azurerm_resource_group.preprod.name
  location            = azurerm_resource_group.preprod.location

}

resource "azurerm_subnet_network_security_group_association" "preprod" {
  subnet_id                 = azurerm_subnet.preprod.id
  network_security_group_id = azurerm_network_security_group.preprod.id
}

