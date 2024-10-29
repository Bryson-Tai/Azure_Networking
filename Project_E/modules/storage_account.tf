# Get our machine IP Address to allow access to Storage Account
# Because we have set Access Default Action to Deny
data "http" "ip" {
  url = "https://checkip.amazonaws.com"
}

resource "azurerm_storage_account" "sa" {
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  name                     = "projectesa"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    # Set default_action to Deny means no any access is available
    # Use ip_rules or virtual_network_subnet_ids to set allowed source
    default_action = "Deny"

    # Set Virtual Network Subnet IDs to only allow which subnet to access to this Storage Account
    virtual_network_subnet_ids = [
      azurerm_subnet.private_subnet.id
    ]

    # Set which IPs is allowed to access to this Storage Account
    ip_rules = [
      chomp(data.http.ip.response_body),
    ]
  }
}

resource "azurerm_storage_share" "sa_file_share" {
  storage_account_name = azurerm_storage_account.sa.name
  name                 = replace("${var.group_name_prefix}-file-share", "_", "-")
  quota                = 50
}

# Storage Account Name
output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}