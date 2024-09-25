module "second_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "b"
  resource_group_location = "eastasia"
}

output "second_infra_public_ip" {
  value = module.second_infra.vm_public_ip
}