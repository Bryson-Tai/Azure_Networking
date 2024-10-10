# Subnets
resource "azurerm_subnet" "public_subnet" {
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.vn.name

  name = "${var.group_name_prefix}-public-subnet"

  address_prefixes = [
    "10.0.1.0/24"
  ]
}

resource "azurerm_route_table" "public_subnet_route_table" {
  name                = "public-dmz-private-route-table"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  route {
    name                   = "to-private-subnet"
    address_prefix         = "10.0.2.0/24" # From Private Subnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.3.4" # To Virtual Appliance - DMZ
  }
}

resource "azurerm_subnet_route_table_association" "public_subnet_route_table_assoc" {
  subnet_id      = azurerm_subnet.public_subnet.id
  route_table_id = azurerm_route_table.public_subnet_route_table.id
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "${var.group_name_prefix}-public-ip"

  allocation_method = "Static"
}

resource "azurerm_bastion_host" "public_bastion" {
  name                = "project_d_bastion"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.public_subnet.id
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
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
    sku       = "24_04-lts"
    version   = "latest"
  }
}