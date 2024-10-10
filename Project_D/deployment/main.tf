module "project_d" {
  source = "../modules"

  group_name_prefix       = "project_d"
  resource_group_location = "eastasia"

}

# output "project_d_ips" {
#   value = module.project_d.vm_ips
# }
