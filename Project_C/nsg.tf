# Create Network Security Group
resource "azurerm_network_security_group" "network_sec_group" {
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location
  name                = "${azurerm_resource_group.bryson_group.name}-sec-group"
}

# Open Port to enable SSH, Web Server
resource "azurerm_network_security_rule" "enable_ssh" {
  resource_group_name         = azurerm_resource_group.bryson_group.name
  network_security_group_name = azurerm_network_security_group.network_sec_group.name

  name              = "enable_ssh"
  priority          = 100
  direction         = "Inbound"
  access            = "Allow"
  protocol          = "Tcp"
  source_port_range = "*"
  destination_port_ranges = [
    "22",
    "80",
    "443",
    "3306"
  ]
  source_address_prefixes = [
    # My PC IP
    "202.187.32.88",
    # Allow first VM (52.175.28.35) to inbound to VM with MySQL (20.2.154.51)
    "52.175.28.35",
  ]
  destination_address_prefix = "*"
}

# Allow to ping
resource "azurerm_network_security_rule" "enable_ping" {
  resource_group_name         = azurerm_resource_group.bryson_group.name
  network_security_group_name = azurerm_network_security_group.network_sec_group.name

  name                       = "enable_ping"
  priority                   = 150
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Icmp"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

# Associate this network security group to subnet
#! We could associate this to Network Interface Card (NIC) too
resource "azurerm_subnet_network_security_group_association" "sec_group_assoc" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.network_sec_group.id
}