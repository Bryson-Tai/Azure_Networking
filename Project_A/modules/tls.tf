# Generate Public & Private Key Pair for SSH
resource "tls_private_key" "vm_ssh_keys" {
  algorithm = "RSA"
}

# Save Private Key to local for SSH
resource "null_resource" "save_private_key" {
  provisioner "local-exec" {
    command = <<EOF
  sshDir=$HOME/.ssh

  mkdir -p $sshDir
  cat ${tls_private_key.vm_ssh_keys.private_key_openssh} > $sshDir/azure_dev_personal

  chmod 600 $sshDir/azure_dev_personal
 EOF
  }
}