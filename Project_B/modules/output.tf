output "vm_public_ip" {
  value = {
    vm_public_ip = azurerm_public_ip.public_ip.ip_address
  }
}