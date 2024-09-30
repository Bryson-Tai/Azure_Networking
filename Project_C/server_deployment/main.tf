resource "azurerm_virtual_network" "vn" {
  resource_group_name = "project_c_poc_testing-c-rg"
  location            = "eastasia"

  name = "project_c_poc_testing-c-vn"

  address_space = [
    "10.0.0.0/16"
  ]
}

module "client_1" {
  source = "../modules"

  group_name_prefix = "project_c_poc_testing"
  project_postfix   = "c"

  vritual_network_name = azurerm_virtual_network.vn.name
  subnet_ip_ranges     = ["10.0.1.0/24"]

  security_rule_config = {
  }
}

module "client_2" {
  source = "../modules"

  group_name_prefix = "project_c_poc_testing"
  project_postfix   = "c"

  vritual_network_name = azurerm_virtual_network.vn.name
  subnet_ip_ranges     = ["10.0.2.0/24"]

  security_rule_config = {
  }
}

module "client_3" {
  source = "../modules"

  group_name_prefix = "project_c_poc_testing"
  project_postfix   = "c"

  vritual_network_name = azurerm_virtual_network.vn.name
  subnet_ip_ranges     = ["10.0.3.0/24"]

  security_rule_config = {
  }
}

module "client_4" {
  source = "../modules"

  group_name_prefix = "project_c_poc_testing"
  project_postfix   = "c"

  vritual_network_name = azurerm_virtual_network.vn.name
  subnet_ip_ranges     = ["10.0.4.0/24"]

  vm_quantity = 2

  security_rule_config = {
  }
}

output "client_1_public_ip" {
  value = module.client_1.vm_public_ip
}
output "client_2_public_ip" {
  value = module.client_2.vm_public_ip
}
output "client_3_public_ip" {
  value = module.client_3.vm_public_ip
}
output "client_4_public_ip" {
  value = module.client_4.vm_public_ip
}