# Virtual Network
resource "azurerm_virtual_network" "vn" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-vn"

  address_space = [
    "10.0.0.0/16"
  ]
}

# Subnets
resource "azurerm_subnet" "subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name = "${var.group_name_prefix}-subnet"

  address_prefixes = ["10.0.1.0/24"]
}