# Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = "project_c_rg"
  location = "eastasia"
}

resource "azurerm_virtual_network" "vn" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  name = "project_c_vn"

  address_space = [
    "10.0.0.0/16"
  ]
}

module "server_group_1" {
  source = "../modules"

  group_name_prefix = "server_group_1"

  rg_name     = azurerm_resource_group.main_rg.name
  rg_location = azurerm_resource_group.main_rg.location

  vritual_network_name = azurerm_virtual_network.vn.name

  vm_config = {
    "client_1" = {
      subnetName = "subnet-1"
    }
  }

  subnet_config = {
    "subnet-1" = {
      subnet_ip_ranges = ["10.0.1.0/24"]

      security_rule_config = {
      }
    }
  }
}

module "server_group_2" {
  source = "../modules"

  group_name_prefix = "server_group_2"

  rg_name     = azurerm_resource_group.main_rg.name
  rg_location = azurerm_resource_group.main_rg.location

  vritual_network_name = azurerm_virtual_network.vn.name

  vm_config = {
    "client_2" = {
      subnetName = "subnet-2"
    }
  }

  subnet_config = {
    "subnet-2" = {
      subnet_ip_ranges = ["10.0.2.0/24"]

      security_rule_config = {
      }
    }
  }
}

module "server_group_3" {
  source = "../modules"

  group_name_prefix = "server_group_3"

  rg_name     = azurerm_resource_group.main_rg.name
  rg_location = azurerm_resource_group.main_rg.location

  vritual_network_name = azurerm_virtual_network.vn.name

  vm_config = {
    "client_3" = {
      subnetName = "subnet-3"
    }
  }

  subnet_config = {
    "subnet-3" = {
      subnet_ip_ranges = ["10.0.3.0/24"]

      security_rule_config = {
      }
    }
  }
}

module "remote_servers" {
  source = "../modules"

  group_name_prefix = "remote_servers"

  rg_name     = azurerm_resource_group.main_rg.name
  rg_location = azurerm_resource_group.main_rg.location

  vritual_network_name = azurerm_virtual_network.vn.name

  vm_config = {
    "client_4" = {
      subnetName = "subnet-4"
      app_sec_group_list = [
        "webserver"
      ]
    }
    "client_5" = {
      subnetName = "subnet-4"
      app_sec_group_list = [
        "tomcatserver"
      ]
    }
  }

  subnet_config = {
    "subnet-4" = {
      subnet_ip_ranges = ["10.0.4.0/24"]

      security_rule_config = {
      }
    }
  }
}

output "client_1_public_ip" {
  value = module.server_group_1.vm_public_ip
}

output "client_2_public_ip" {
  value = module.server_group_2.vm_public_ip
}

output "client_3_public_ip" {
  value = module.server_group_3.vm_public_ip
}

output "remote_servers_public_ips" {
  value = module.remote_servers.vm_public_ip
}