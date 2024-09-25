# Virtual Network
resource "azurerm_virtual_network" "vn" {
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location

  name = "${azurerm_resource_group.bryson_group.name}-VN"

  address_space = [
    "10.0.0.0/16"
  ]
}

# Subnets
resource "azurerm_subnet" "subnet1" {
  resource_group_name  = azurerm_resource_group.bryson_group.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name             = "${azurerm_virtual_network.vn.name}-subnet1"
  address_prefixes = ["10.0.1.0/24"]
}