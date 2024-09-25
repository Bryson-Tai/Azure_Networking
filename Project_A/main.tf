module "project_a" {
  source = "./modules"

  group_name_prefix       = "project_a_poc_testing"
  resource_group_location = "eastasia"
}