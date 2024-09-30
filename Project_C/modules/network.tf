# Subnets
resource "azurerm_subnet" "subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = var.vritual_network_name

  name             = "${var.vritual_network_name}-subnet"
  address_prefixes = var.subnet_ip_ranges
}