module "second_infra" {
  source = "../../"

  project_postfix = "b"
}

output "second_infra_public_ip" {
  value = module.second_infra.vm_public_ip
}