# Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "${var.group_name_prefix}-rg"
  location = "eastasia"
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-public-ip"

  allocation_method = "Static"
}

# Network Interface Card
resource "azurerm_network_interface" "vm1_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-vm1-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${var.group_name_prefix}-nginx-server-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm_ssh_keys.public_key_openssh
  }

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

  custom_data = filebase64("${path.module}/bash/install_nginx.sh")
}