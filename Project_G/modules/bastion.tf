# Bastion require a dedicated subnet for itself
resource "azurerm_subnet" "bastion_subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  # Bastion require 'AzureBastionSubnet' as the exact name of Subnet for creation
  name = "AzureBastionSubnet"

  address_prefixes = [
    "10.0.1.0/26"
  ]
}

# Public IP for bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "bastion-public-ip"

  allocation_method = "Static"
}

# Since bastion would act as a hop server, it require a public IP address for public access from our local host
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.group_name_prefix}_bastion"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}