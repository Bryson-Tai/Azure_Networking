module "first_infra" {
  source = "../../"

  project_postfix = "a"
}

output "first_infra_public_ip" {
  value = module.first_infra.vm_public_ip
}