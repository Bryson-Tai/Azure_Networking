output "vm_public_ip" {
  value = {
    for key, value in local.structured_vm_config : key => {
      public_ip  = azurerm_linux_virtual_machine.vm[key].public_ip_address
      private_ip = azurerm_linux_virtual_machine.vm[key].private_ip_address
    }
  }
}