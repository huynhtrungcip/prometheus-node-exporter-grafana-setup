#!/bin/bash

# Author: Trung Huynh Chi
# Script to install and configure Prometheus, Node Exporter, and Grafana on Ubuntu 20.04

# Update the system packages to ensure the latest versions are installed
# This is crucial for stability and compatibility.
sudo apt update && sudo apt upgrade -y

# Install dependencies required for downloading and extracting software packages
# curl: For downloading files from URLs
# tar: For extracting tar.gz files
sudo apt install -y curl tar

# Create a dedicated user for Prometheus to enhance security
# This user will own the Prometheus process and files.
sudo useradd --no-create-home --shell /bin/false prometheus

# Create necessary directories for Prometheus
# /etc/prometheus: For configuration files
# /var/lib/prometheus: For Prometheus data storage
sudo mkdir /etc/prometheus /var/lib/prometheus

# Download the latest version of Prometheus
# Check https://prometheus.io/download/ for updated links if needed.
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz

# Extract the downloaded Prometheus tarball
# The extracted files include the binaries and default configuration.
tar -xvzf prometheus-2.47.0.linux-amd64.tar.gz

# Move the Prometheus binaries to /usr/local/bin for global accessibility
sudo mv prometheus-2.47.0.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.47.0.linux-amd64/promtool /usr/local/bin/

# Move Prometheus configuration files to /etc/prometheus
# These include prometheus.yml and console templates.
sudo mv prometheus-2.47.0.linux-amd64/consoles /etc/prometheus/
sudo mv prometheus-2.47.0.linux-amd64/console_libraries /etc/prometheus/
sudo mv prometheus-2.47.0.linux-amd64/prometheus.yml /etc/prometheus/

# Set ownership of Prometheus files to the prometheus user for security
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Clean up downloaded and extracted files to free up space
rm -rf prometheus-2.47.0.linux-amd64 prometheus-2.47.0.linux-amd64.tar.gz

# Create a systemd service file for Prometheus
# This ensures Prometheus starts automatically on boot.
echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

# Reload systemd to recognize the new service, then enable and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Install Node Exporter for monitoring system metrics
# This exports system-level metrics for Prometheus to scrape.
sudo useradd --no-create-home --shell /bin/false node_exporter
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvzf node_exporter-1.6.1.linux-amd64.tar.gz
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.6.1.linux-amd64 node_exporter-1.6.1.linux-amd64.tar.gz

# Create a systemd service file for Node Exporter
# This ensures Node Exporter runs automatically on boot.
echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/node_exporter.service

# Reload systemd, then enable and start Node Exporter
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Install Grafana for visualizing metrics collected by Prometheus
# Add Grafana's APT repository to the system
sudo apt install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
curl -fsSL https://packages.grafana.com/gpg.key | sudo tee /usr/share/keyrings/grafana-archive-keyring.gpg >/dev/null

# Install Grafana using the APT package manager
sudo apt update
sudo apt install -y grafana

# Enable and start the Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Display status of all services to verify successful installation
sudo systemctl status prometheus
sudo systemctl status node_exporter
sudo systemctl status grafana-server

# Script completed message
echo "Prometheus, Node Exporter, and Grafana installation completed successfully!"
