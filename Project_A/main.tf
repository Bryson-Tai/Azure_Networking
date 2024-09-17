# Resource Group
resource "azurerm_resource_group" "bryson_group" {
  name     = "Bryson_TDP_POC"
  location = "eastasia"
}

# Virtual Network & Subnets
resource "azurerm_virtual_network" "vn" {
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location

  name = "${azurerm_resource_group.bryson_group.name}-VN"

  address_space = [
    "10.0.0.0/16"
  ]
}

resource "azurerm_subnet" "subnet1" {
  resource_group_name  = azurerm_resource_group.bryson_group.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name             = "${azurerm_virtual_network.vn.name}-subnet1"
  address_prefixes = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location

  name = "${azurerm_resource_group.bryson_group.name}-public-ip"

  allocation_method = "Static"
}

# Generate Public & Private Key Pair for SSH
resource "tls_private_key" "vm_ssh_keys" {
  algorithm = "RSA"
}

# Save Private Key to local for SSH
resource "null_resource" "save_private_key" {
  provisioner "local-exec" {
    command = <<EOF
  keysDir=${path.module}/vm_keys
  mkdir -p $keysDir
  cat ${tls_private_key.vm_ssh_keys.private_key_pem} > $keysDir/vm1
 EOF
  }
}

resource "azurerm_network_interface" "vm1_nic" {
  name                = "${azurerm_resource_group.bryson_group.name}-vm1-nic"
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "${azurerm_resource_group.bryson_group.name}-nginx-server-vm"
  resource_group_name = azurerm_resource_group.bryson_group.name
  location            = azurerm_resource_group.bryson_group.location
  size                = "Standard_A2_v2"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm_ssh_keys.public_key_pem
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