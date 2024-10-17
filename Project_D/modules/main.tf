# Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "${var.group_name_prefix}-rg"
  location = var.resource_group_location
}

# Virtual Network
resource "azurerm_virtual_network" "vn" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-vn"

  address_space = [
    "10.0.0.0/16"
  ]
}
