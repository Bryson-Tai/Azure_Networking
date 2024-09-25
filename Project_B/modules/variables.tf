variable "project_postfix" {
  description = "Distinguish different modules"
  type        = string
  default     = "default"
}

variable "group_name_prefix" {
  description = "Provide a prefer group name"
  type        = string
  default     = "project_b_poc_testing"
}

variable "resource_group_location" {
  description = "Provide resource group location"
  type        = string
  default     = "eastasia"
}

# variable "security_group_config" {
#   description = "Provide Security Group Config"
#   type =
# }