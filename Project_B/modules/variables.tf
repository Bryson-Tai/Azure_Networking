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

variable "security_rule_config" {
  description = "Provide Security Group Config"
  type = map(object({
    priority                     = number
    inbound_or_outbound          = optional(bool, true)
    allow_access                 = optional(bool, true)
    protocol                     = optional(string, "*")
    source_port_range            = optional(string, "*")
    destination_port_range       = optional(string, "*")
    source_address_prefix        = optional(string, "*")
    destination_address_prefix   = optional(string, "*")
    source_port_ranges           = optional(list(string), [])
    destination_port_ranges      = optional(list(string), [])
    source_address_prefixes      = optional(list(string), [])
    destination_address_prefixes = optional(list(string), [])
  }))

  default = {
    "nsg_name" = {
      priority                     = 100
      inbound_or_outbound          = true
      allow_access                 = true
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "*"
      source_address_prefix        = "*"
      destination_address_prefix   = "*"
      source_port_ranges           = []
      destination_port_ranges      = []
      source_address_prefixes      = []
      destination_address_prefixes = []
    }
  }
}