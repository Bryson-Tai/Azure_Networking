#! /bin/bash

# Credit by: https://www.centron.de/en/tutorial/step-by-step-guide-install-tomcat-on-a-linux-system/

tomcatVersion=10.1.30

# Install Java Latest Version JDK
sudo apt update && sudo apt install -y default-jdk

# Get Java Version
javaVersion=$(java -version 2>&1 | grep "openjdk version" | awk '{print $3}' | tr -d '"')

# Create a dedicated user to Tomcat instead of running as root
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

# Download Tomcat Binary GZip
wget -c https://dlcdn.apache.org/tomcat/tomcat-10/v$tomcatVersion/bin/apache-tomcat-$tomcatVersion.tar.gz

# Extract Tomcat GZip
sudo tar xf apache-tomcat-$tomcatVersion.tar.gz -C /opt/tomcat

# Create a symbolic link pointing to the Tomcat installation directory to facilitate future updates
sudo ln -s /opt/tomcat/apache-tomcat-$tomcatVersion /opt/tomcat/updated

# Change permissions in the Tomcat directory
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/updated/bin/*.sh'

# Run Tomcat as a system service in Linux
# Create a Systemd service file
sudo cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment="JAVA_HOME=/usr/lib/jvm/java-$javaVersion-openjdk-amd64"
Environment="CATALINA_PID=/opt/tomcat/updated/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat/updated/"
Environment="CATALINA_BASE=/opt/tomcat/updated/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/updated/bin/startup.sh
ExecStop=/opt/tomcat/updated/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target
EOF

# Update system daemon and start tomcat service
sudo systemctl daemon-reload && sudo systemctl start tomcat

# Open firewall port 8080 for Tomcat accessibility
sudo ufw allow 8080/tcp
