# Get your machine host IP for SSH enable
data "http" "ip" {
  url = "https://checkip.amazonaws.com"
}

# Create Network Security Group
resource "azurerm_network_security_group" "network_sec_group" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-sec-group"
}

# Open Port to enable SSH, Web Server
resource "azurerm_network_security_rule" "enable_ssh" {
  resource_group_name         = azurerm_resource_group.main_rg.name
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
    "443"
  ]
  source_address_prefix = chomp(data.http.ip.response_body)

  destination_address_prefix = "*"
}

# Allow to ping
resource "azurerm_network_security_rule" "enable_ping" {
  resource_group_name         = azurerm_resource_group.main_rg.name
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
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.network_sec_group.id
}