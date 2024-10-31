resource "azurerm_subnet" "main_subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name = "${var.group_name_prefix}-main-subnet"

  # This subnet with a service endpoints to Microsoft.Storage (Storage Account)
  service_endpoints = [
    "Microsoft.Storage"
  ]

  # Associate Service Endpoint Policy to this subnet
  service_endpoint_policy_ids = [
    azurerm_subnet_service_endpoint_storage_policy.service_endpoint_policy.id
  ]

  address_prefixes = [
    "10.0.2.0/24"
  ]
}

# Network Interface Card
resource "azurerm_network_interface" "main_vm_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-main-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main_subnet.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

resource "azurerm_network_security_group" "nsg_main" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  name                = "${var.group_name_prefix}-nsg-main"
}

resource "azurerm_network_security_rule" "allow_storage_all" {
  resource_group_name         = azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_main.name
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
  network_security_group_name = azurerm_network_security_group.nsg_main.name
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

resource "azurerm_subnet_network_security_group_association" "main_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.nsg_main.id
  subnet_id                 = azurerm_subnet.main_subnet.id
}

resource "azurerm_linux_virtual_machine" "main_vm" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${var.group_name_prefix}-main-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"
  admin_password = "Admin_123"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.main_vm_nic.id,
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