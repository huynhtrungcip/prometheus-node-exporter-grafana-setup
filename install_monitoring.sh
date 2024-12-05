#!/bin/bash

################################################################################
# Script to install Prometheus, Node Exporter, and Grafana on Ubuntu 20.04    #
# Author: [Your Name]                                                        #
# Date: [Date]                                                               #
# Description: This script automates the installation and configuration of   #
# Prometheus, Node Exporter, and Grafana for monitoring and visualization.   #
################################################################################

# Exit immediately if a command exits with a non-zero status
set -e

################################################################################
# Update and Upgrade System Packages                                          #
################################################################################
sudo apt-get update

################################################################################
# Install Prometheus                                                          #
################################################################################

# Create Prometheus system user
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Download and extract Prometheus
PROM_VERSION="2.32.1"
wget https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-amd64.tar.gz
tar -xvf prometheus-$PROM_VERSION.linux-amd64.tar.gz

# Configure Prometheus
sudo mkdir -p /data /etc/prometheus
cd prometheus-$PROM_VERSION.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
cd ..
rm -rf prometheus-$PROM_VERSION.linux-amd64*

# Create Prometheus systemd service file
sudo bash -c 'cat <<EOT > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOT'

# Enable and start Prometheus service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus --no-pager

################################################################################
# Install Node Exporter                                                       #
################################################################################

# Create Node Exporter system user
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# Download and extract Node Exporter
NODE_EXPORTER_VERSION="1.3.1"
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
tar -xvf node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
sudo mv node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-$NODE_EXPORTER_VERSION.linux-amd64*

# Create Node Exporter systemd service file
sudo bash -c 'cat <<EOT > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target
EOT'

# Enable and start Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter --no-pager

################################################################################
# Install Grafana                                                             #
################################################################################

# Install dependencies for Grafana
sudo apt-get install -y apt-transport-https software-properties-common

# Add Grafana GPG key and repository
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server --no-pager

################################################################################
# Completion Message                                                          #
################################################################################
echo "Prometheus, Node Exporter, and Grafana have been successfully installed and configured."

################################################################################
# Usage Instructions                                                          #
################################################################################
# To run this script, follow these steps:                                     #
# 1. Save the script as install_monitoring.sh.                               #
# 2. Make it executable: chmod +x install_monitoring.sh.                     #
# 3. Run the script: sudo ./install_monitoring.sh.                           #
# 4. Access the services:                                                    #
#    - Prometheus: http://<your-server-ip>:9090                              #
#    - Node Exporter: http://<your-server-ip>:9100                           #
#    - Grafana: http://<your-server-ip>:3000 (Default login: admin/admin)    #
################################################################################
