#! /bin/bash

# Purposely put to wait VM to fully startup
#! Else, it will not able to run `apt update` properly
sleep 10s

# Install MySQL and Nginx Server
sudo apt update && sudo apt install -y mysql-server nginx

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