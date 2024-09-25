module "first_infra" {
  source = "../modules"

  project_postfix         = "a"
  resource_group_location = "eastasia"
  group_name_prefix       = "project_b_poc_testing"
}

output "first_infra_public_ip" {
  value = module.first_infra.vm_public_ip
}