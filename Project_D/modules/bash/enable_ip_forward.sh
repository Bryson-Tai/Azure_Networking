#! /bin/bash

sudo sed -i "s/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf

# Reboot to apply ip_forward config
sudo reboot