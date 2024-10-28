resource "azurerm_storage_account" "sa" {
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  name                     = "projectesa"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"

    virtual_network_subnet_ids = [
      azurerm_subnet.private_subnet.id
    ]
  }
}

resource "azurerm_storage_share" "sa_file_share" {
  storage_account_name = azurerm_storage_account.sa.name
  name                 = replace("${var.group_name_prefix}-file-share", "_", "-")
  quota                = 50
}

output "sa_endpoint" {
  value = azurerm_storage_account.sa.dns_endpoint_type
}