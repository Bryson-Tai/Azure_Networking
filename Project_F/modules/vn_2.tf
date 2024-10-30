# Virtual Network
resource "azurerm_virtual_network" "vn_2" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-vn-2"

  address_space = [
    "10.1.0.0/16"
  ]
}

resource "azurerm_subnet" "vn_2_subnet_1" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn_2.name

  name = "${azurerm_virtual_network.vn_2.name}-subnet-1"

  address_prefixes = [
    "10.1.2.0/24"
  ]
}

# Network Interface Card
resource "azurerm_network_interface" "vn_2_subnet_1_vm_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${azurerm_subnet.vn_2_subnet_1.name}-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vn_2_subnet_1.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

resource "azurerm_network_security_group" "vn_2_subnet_1_vm_nsg" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${azurerm_subnet.vn_2_subnet_1.name}-vm-nsg"
}

resource "azurerm_subnet_network_security_group_association" "vn_2_subnet_1_vm_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.vn_2_subnet_1_vm_nsg.id
  subnet_id                 = azurerm_subnet.vn_2_subnet_1.id
}

resource "azurerm_linux_virtual_machine" "vn_2_subnet_1_vm" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${azurerm_subnet.vn_2_subnet_1.name}-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"
  admin_password = "Admin_123"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vn_2_subnet_1_vm_nic.id,
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