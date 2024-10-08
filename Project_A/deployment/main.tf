module "project_a" {
  source = "../modules"

  group_name_prefix       = "project_a"
  resource_group_location = "eastasia"
}

output "vm_ips" {
  value = module.project_a.vm_ips
}