# Get our machine IP Address to allow access to Storage Account
# Because we have set Access Default Action to Deny
data "http" "ip" {
  url = "https://checkip.amazonaws.com"
}

#TODO: Uncomment this after first deployment
# data "azurerm_subnet" "get_main_subnet_id" {
#   resource_group_name  = azurerm_resource_group.main_rg.name
#   virtual_network_name = "${var.group_name_prefix}-vn"
#   name                 = "${var.group_name_prefix}-main-subnet"
# }

#@ Allow Storage Account - Allow to access
resource "azurerm_storage_account" "allow_sa" {
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  name                     = "allowaccount123"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    # Set default_action to Deny means no any access is available
    # Use ip_rules or virtual_network_subnet_ids to set allowed source
    default_action = "Deny"

    #TODO: Uncomment this after first deployment
    # Set Virtual Network Subnet IDs to only allow which subnet to access to this Storage Account
    # virtual_network_subnet_ids = [
    #   data.azurerm_subnet.get_main_subnet_id.id
    # ]

    # Set which IPs is allowed to access to this Storage Account
    # This is your local machine IP, or else IaC is not able to access to SA
    ip_rules = [
      chomp(data.http.ip.response_body),
    ]
  }
}

resource "azurerm_storage_share" "allow_sa_file_share" {
  storage_account_name = azurerm_storage_account.allow_sa.name
  name                 = replace("allow-${var.group_name_prefix}-file-share", "_", "-")
  quota                = 50
}

#@ Configure service-endpoint policy to the subnet
#@ Only allow storage account could be access by private subnet
resource "azurerm_subnet_service_endpoint_storage_policy" "service_endpoint_policy" {
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  name                = "allow-service-endpoint-policy"

  definition {
    name    = "allow-storage-access"
    service = "Microsoft.Storage"
    service_resources = [
      azurerm_storage_account.allow_sa.id,
    ]
  }
}

## Output
output "allow_storage_account_name" {
  value = azurerm_storage_account.allow_sa.name
}

#@ Deny Storage Account - Not allow to access
resource "azurerm_storage_account" "deny_sa" {
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  name                     = "denyaccount123"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    # Set default_action to Deny means no any access is available
    # Use ip_rules or virtual_network_subnet_ids to set allowed source
    default_action = "Deny"

    # Set which IPs is allowed to access to this Storage Account
    # This is your local machine IP, or else IaC is not able to access to SA
    ip_rules = [
      chomp(data.http.ip.response_body),
    ]
  }
}

resource "azurerm_storage_share" "deny_sa_file_share" {
  storage_account_name = azurerm_storage_account.deny_sa.name
  name                 = replace("deny-${var.group_name_prefix}-file-share", "_", "-")
  quota                = 50
}

## Output
output "deny_storage_account_name" {
  value = azurerm_storage_account.deny_sa.name
}