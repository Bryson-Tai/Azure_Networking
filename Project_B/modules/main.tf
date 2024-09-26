# Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "${var.group_name_prefix}-${var.project_postfix}-rg"
  location = var.resource_group_location
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-${var.project_postfix}-public-ip"

  allocation_method = "Static"
}

# Network Interface Card
resource "azurerm_network_interface" "vm_nic" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-${var.project_postfix}-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name           = replace("${var.group_name_prefix}-${var.project_postfix}-vm", "_", "-")
  size           = "Standard_A2_v2"
  admin_username = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
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
}

resource "null_resource" "configure_vm" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.public_ip.ip_address
      user        = azurerm_linux_virtual_machine.vm.admin_username
      private_key = tls_private_key.vm_ssh_keys.private_key_openssh
    }

    script = "${path.module}/bash/essential_vm_setup.sh"
  }
}