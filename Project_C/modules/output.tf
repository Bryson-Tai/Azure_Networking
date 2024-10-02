output "vm_public_ip" {
  value = {
    for key, value in local.structured_vm_config : key => azurerm_public_ip.public_ip[key].ip_address
  }
}