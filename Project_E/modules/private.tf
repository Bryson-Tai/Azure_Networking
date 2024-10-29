resource "azurerm_subnet" "private_subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name = "${var.group_name_prefix}-private-subnet"

  # This subnet with a service endpoints to Microsoft.Storage (Storage Account)
  service_endpoints = [
    "Microsoft.Storage"
  ]

  address_prefixes = [
    "10.0.2.0/24"
  ]
}

# Network Interface Card
resource "azurerm_network_interface" "private_vm_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-private-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

resource "azurerm_network_security_group" "nsg_private" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  name                = "${var.group_name_prefix}-nsg-private"
}

resource "azurerm_network_security_rule" "allow_storage_all" {
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
  name                        = "Allow-Storage-All"
  access                      = "Allow"
  direction                   = "Outbound"
  protocol                    = "*"
  priority                    = 100
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
}

resource "azurerm_network_security_rule" "deny_internet_all" {
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
  name                        = "Deny-Internet-All"
  access                      = "Deny"
  direction                   = "Outbound"
  protocol                    = "*"
  priority                    = 110
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
}

resource "azurerm_network_security_rule" "allow_ssh" {
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
  name                        = "Allow-SSH-All"
  access                      = "Allow"
  direction                   = "Inbound"
  protocol                    = "Tcp"
  priority                    = 120
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.nsg_private.id
  subnet_id                 = azurerm_subnet.private_subnet.id
}

resource "azurerm_linux_virtual_machine" "private_vm" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${var.group_name_prefix}-private-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"
  admin_password = "Admin_123"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.private_vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 32
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}