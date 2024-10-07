module "sql_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "sql"
  resource_group_location = "eastasia"

  security_rule_config = {
    "allowConnectMySQL" = {
      priority              = 100
      source_address_prefix = module.sql_infra.vm_ips["vm_public_ip"]
    }
  }
}

module "nginx_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "nginx"
  resource_group_location = "eastasia"

  security_rule_config = {}
}

output "sql_infra_public_ip" {
  value = module.sql_infra.vm_ips
}

output "nginx_infra_public_ip" {
  value = module.nginx_infra.vm_ips
}

