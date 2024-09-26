# Get your machine host IP for SSH enable
data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

# Create Network Security Group
resource "azurerm_network_security_group" "network_sec_group" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  name                = "${var.group_name_prefix}-${var.project_postfix}-sec-group"
}

# Open Port to enable SSH, Web Server
resource "azurerm_network_security_rule" "custom_nsg_rules" {
  for_each = var.security_rule_config

  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.network_sec_group.name

  name      = each.key
  priority  = each.value.priority
  direction = each.value.enable_inbound ? "Inbound" : "Outbound"
  access    = each.value.allow_access ? "Allow" : "Deny"
  protocol  = each.value.protocol

  source_port_range          = length(each.value.source_port_ranges) > 0 ? null : each.value.source_port_range
  destination_port_range     = length(each.value.destination_port_ranges) > 0 ? null : each.value.destination_port_range
  source_address_prefix      = length(each.value.source_address_prefixes) > 0 ? null : each.value.source_address_prefix
  destination_address_prefix = length(each.value.destination_address_prefixes) > 0 ? null : each.value.destination_address_prefix

  source_port_ranges           = length(each.value.source_port_ranges) == 0 ? null : each.value.source_port_ranges
  destination_port_ranges      = length(each.value.destination_port_ranges) == 0 ? null : each.value.destination_port_ranges
  source_address_prefixes      = length(each.value.source_address_prefixes) == 0 ? null : each.value.source_address_prefixes
  destination_address_prefixes = length(each.value.destination_address_prefixes) == 0 ? null : each.value.destination_address_prefixes
}

# Enable SSH by Default
resource "azurerm_network_security_rule" "enable_ssh" {
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.network_sec_group.name

  name                       = "enable_ssh"
  priority                   = 140
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = data.http.ip.response_body
  destination_address_prefix = "*"
}

# Enable to Ping by Default
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