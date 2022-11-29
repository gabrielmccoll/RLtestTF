resource "azurerm_resource_group" "shrd" {
  name     = "shrdvnet"
  location = var.location
}

resource "azurerm_virtual_network" "shrd" {
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.shrd.location
  name                = azurerm_resource_group.shrd.name
  resource_group_name = azurerm_resource_group.shrd.name

}

resource "azurerm_subnet" "shrd" {
  address_prefixes                          = ["10.2.1.0/24"]
  name                                      = azurerm_resource_group.shrd.name
  virtual_network_name                      = azurerm_virtual_network.shrd.name
  resource_group_name                       = azurerm_resource_group.shrd.name
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "shrd" {
  name                = azurerm_resource_group.shrd.name
  resource_group_name = azurerm_resource_group.shrd.name
  location            = azurerm_resource_group.shrd.location

}

resource "azurerm_subnet_network_security_group_association" "shrd" {
  subnet_id                 = azurerm_subnet.shrd.id
  network_security_group_id = azurerm_network_security_group.shrd.id
}

resource "azurerm_virtual_network_peering" "shrdprod" {
  name                      = "shrdprod"
  resource_group_name       = azurerm_resource_group.shrd.name
  virtual_network_name      = azurerm_virtual_network.shrd.name
  remote_virtual_network_id = azurerm_virtual_network.prod.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false

}