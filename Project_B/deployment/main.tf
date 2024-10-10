module "sql_infra" {
  source = "../modules"

  group_name_prefix       = "project_b"
  project_postfix         = "mysql"
  resource_group_location = "eastasia"

  security_rule_config = {
    "allowNginxConnectMySQL" = {
      priority              = 100
      source_address_prefix = module.nginx_infra.vm_ips["vm_public_ip"]
    }
  }
}

module "nginx_infra" {
  source = "../modules"

  group_name_prefix       = "project_b"
  project_postfix         = "nginx"
  resource_group_location = "eastasia"

  security_rule_config = {}
}

output "sql_infra_ips" {
  value = module.sql_infra.vm_ips
}

output "nginx_infra_ips" {
  value = module.nginx_infra.vm_ips
}

