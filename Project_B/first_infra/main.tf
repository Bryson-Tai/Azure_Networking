module "first_infra" {
  source = "../modules"

  group_name_prefix       = "project_b_poc_testing"
  project_postfix         = "a"
  resource_group_location = "eastasia"

  security_rule_config = {
    "test_rule" = {
      priority       = 100
      enable_inbound = true
      allow_access   = true
      protocol       = "Tcp"
    }

  }
}

output "first_infra_public_ip" {
  value = module.first_infra.vm_public_ip
}