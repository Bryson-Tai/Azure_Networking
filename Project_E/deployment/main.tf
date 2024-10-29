module "project_e" {
  source = "../modules"

  group_name_prefix       = "project_e"
  resource_group_location = "eastasia"
}

# Storage Account Name
output "storage_account_name" {
  value = module.project_e.storage_account_name
}