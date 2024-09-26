module "sql_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "b"
  resource_group_location = "eastasia"

  security_rule_config = {
    "allowConnectMySQL" = {
      priority              = 100
      source_address_prefix = "20.255.75.105"
    }
  }
}

output "sql_infra_public_ip" {
  value = module.sql_infra.vm_public_ip
}