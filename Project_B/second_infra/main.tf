module "second_infra" {
  source = "../modules"

  project_postfix         = "b"
  resource_group_location = "eastasia"
  group_name_prefix       = "project_b_poc_testing"
}

output "second_infra_public_ip" {
  value = module.second_infra.vm_public_ip
}