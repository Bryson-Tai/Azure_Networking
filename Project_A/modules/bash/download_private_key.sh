#! /bin/bash

sshDir=$HOME/.ssh
fileName=azure_vm_personal

mkdir -p "$sshDir"

echo "${private_key}" > "$sshDir/$fileName"

chmod 600 "$sshDir/$fileName"