#! /bin/bash

sshDir=$HOME/.ssh
fileName=azure_dev_personal

mkdir -p "$sshDir"

echo "${private_key}" > "$sshDir/$fileName"

chmod 600 "$sshDir/$fileName"