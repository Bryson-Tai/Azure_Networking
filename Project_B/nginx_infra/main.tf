module "nginx_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "a"
  resource_group_location = "eastasia"

  security_rule_config = {}
}

output "nginx_infra_public_ip" {
  value = module.nginx_infra.vm_public_ip
}