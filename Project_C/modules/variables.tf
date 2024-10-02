variable "group_name_prefix" {
  description = "Provide a prefer group name"
  type        = string
  default     = "project_c"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = ""
}

variable "rg_location" {
  description = "Provide resource group location"
  type        = string
  default     = "eastasia"
}

variable "vritual_network_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "vm_config" {
  type = map(object({
    subnetName         = string
    app_sec_group_list = optional(list(string), [""])
  }))

  default = {
    "vm_names" = {
      subnetName = ""
      app_sec_group_list = [
        "webserver"
      ]
    }
  }
}

variable "subnet_config" {
  type = map(object({
    subnet_ip_ranges = list(string)

    security_rule_config = map(object({
      priority                                    = number
      enable_inbound                              = optional(bool, true)
      allow_access                                = optional(bool, true)
      protocol                                    = optional(string, "*")
      source_port_range                           = optional(string, "*")
      destination_port_range                      = optional(string, "*")
      source_address_prefix                       = optional(string, "*")
      destination_address_prefix                  = optional(string, "*")
      source_port_ranges                          = optional(list(string), [])
      destination_port_ranges                     = optional(list(string), [])
      source_address_prefixes                     = optional(list(string), [])
      destination_address_prefixes                = optional(list(string), [])
      source_application_security_group_list      = optional(list(string), [])
      destination_application_security_group_list = optional(list(string), [])
    }))
  }))

  default = {
    "subnet-1" = {
      subnet_ip_ranges = []

      security_rule_config = {
        "nsg_name" = {
          priority                                    = 100
          enable_inbound                              = true
          allow_access                                = true
          protocol                                    = "Tcp"
          source_port_range                           = "*"
          destination_port_range                      = "*"
          source_address_prefix                       = "*"
          destination_address_prefix                  = "*"
          source_port_ranges                          = []
          destination_port_ranges                     = []
          source_address_prefixes                     = []
          destination_address_prefixes                = []
          source_application_security_group_name      = []
          destination_application_security_group_name = []
        }
      }
    }
  }
}