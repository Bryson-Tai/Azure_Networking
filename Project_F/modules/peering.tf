#@ To achieve fully peering, in OpenTofu we need to have 2 peering resources setup
resource "azurerm_virtual_network_peering" "vn_peer_vn1_to_vn2" {
  name                = "peervn1tovn2"
  resource_group_name = azurerm_resource_group.main_rg.name
  # From
  virtual_network_name = azurerm_virtual_network.vn_1.name
  # To
  remote_virtual_network_id = azurerm_virtual_network.vn_2.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "vn_peer_vn2_to_vn1" {
  name                = "peervn2tovn1"
  resource_group_name = azurerm_resource_group.main_rg.name
  # From
  virtual_network_name = azurerm_virtual_network.vn_2.name
  # To
  remote_virtual_network_id = azurerm_virtual_network.vn_1.id
  allow_forwarded_traffic   = true
}