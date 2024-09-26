#! /bin/bash

# Install MySQL server
sudo apt update -y && sudo apt install -y mysql-server nginx

sleep 5

# Change bind-address config to remote enable MySQL server
sudo sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" "/etc/mysql/mysql.conf.d/mysqld.cnf"

# Restart mysql service
sudo systemctl restart mysql

# Login to MySQL as ROOT and run MySQL query
sudo mysql <<EOF
    CREATE USER 'testUser'@'%' IDENTIFIED BY 'test123';
    GRANT ALL PRIVILEGES ON *.* TO 'testUser'@'%';
    FLUSH PRIVILEGES;
EOF