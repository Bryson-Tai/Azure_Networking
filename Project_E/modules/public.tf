# Subnets
resource "azurerm_subnet" "public_subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name = "${var.group_name_prefix}-public-subnet"

  address_prefixes = [
    "10.0.0.0/24"
  ]
}

# Network Interface Card
resource "azurerm_network_interface" "public_vm_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-public-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "public_vm" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${var.group_name_prefix}-public-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"
  admin_password = "Admin_123"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.public_vm_nic.id,
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