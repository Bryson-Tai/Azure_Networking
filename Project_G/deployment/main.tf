module "project_g" {
  source = "../modules"

  group_name_prefix       = "project_g"
  resource_group_location = "eastasia"
}

# Storage Account Name
output "allow_sa_name" {
  value = module.project_g.allow_storage_account_name
}
output "deny_sa_name" {
  value = module.project_g.deny_storage_account_name
}