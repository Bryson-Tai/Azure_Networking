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
    "webserver" = {
      subnetName = "subnet-4"
      app_sec_group_list = [
        "webserver"
      ]
    }
    "tomcat" = {
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
        # Allow Remote Server welcome page to be viewed in my PC
        "enable_remote_server_to_local" = {
          priority            = 500
          inbound_or_outbound = true
          allow_access        = true
          protocol            = "Tcp"
          source_port_range   = "*"
          destination_port_ranges = [
            "80",
            "8080"
          ]
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
        # Scenario 1: Allow other Server Groups to access the Remote Server Group
        "server_groups_access" = {
          priority               = 480
          inbound_or_outbound    = true
          allow_access           = true
          protocol               = "Tcp"
          source_port_range      = "*"
          destination_port_range = "*"
          source_address_prefixes = [
            "10.0.1.0/24",
            "10.0.2.0/24",
            "10.0.3.0/24",
          ]
          destination_address_prefix = "10.0.4.0/24"
        }
        # Scenario 2: Allow Server Group 2 to access WebServer ASG only
        "deny_group_2_tomcat_access" = {
          priority               = 460
          inbound_or_outbound    = true
          allow_access           = false
          protocol               = "Tcp"
          source_port_range      = "*"
          destination_port_range = "*"
          source_address_prefix  = "10.0.2.0/24"
          destination_application_security_group_list = [
            "tomcatserver"
          ]
        }
        # Scenario 3: Allow Server Group 3 to access TomcatServer ASG only
        "deny_group_3_webserver_access" = {
          priority               = 440
          inbound_or_outbound    = true
          allow_access           = false
          protocol               = "Tcp"
          source_port_range      = "*"
          destination_port_range = "*"
          source_address_prefix  = "10.0.3.0/24"
          destination_application_security_group_list = [
            "webserver"
          ]
        }
      }
    }
  }
}

output "client_1_public_ip" {
  value = module.server_group_1.vm_ips
}

output "client_2_public_ip" {
  value = module.server_group_2.vm_ips
}

output "client_3_public_ip" {
  value = module.server_group_3.vm_ips
}

output "remote_servers_public_ips" {
  value = module.remote_servers.vm_ips
}