#!/bin/bash

# Author: Trung Huynh Chi
# Script to install and configure Prometheus, Node Exporter, and Grafana on Ubuntu 20.04+

echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing dependencies..."
sudo apt install -y curl tar software-properties-common gnupg2

###----------------------------#
### PROMETHEUS INSTALLATION
###----------------------------#

echo "[+] Adding Prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus

echo "[+] Creating Prometheus directories..."
sudo mkdir -p /etc/prometheus /var/lib/prometheus

echo "[+] Downloading Prometheus..."
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
tar -xvzf prometheus-2.47.0.linux-amd64.tar.gz

echo "[+] Installing Prometheus binaries..."
sudo mv prometheus-2.47.0.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.47.0.linux-amd64/promtool /usr/local/bin/

echo "[+] Installing Prometheus config and consoles..."
sudo mv prometheus-2.47.0.linux-amd64/consoles /etc/prometheus/
sudo mv prometheus-2.47.0.linux-amd64/console_libraries /etc/prometheus/
sudo mv prometheus-2.47.0.linux-amd64/prometheus.yml /etc/prometheus/

echo "[+] Setting ownership for Prometheus..."
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

echo "[+] Cleaning up Prometheus package..."
rm -rf prometheus-2.47.0.linux-amd64.tar.gz prometheus-2.47.0.linux-amd64

echo "[+] Creating Prometheus systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
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
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus/ \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090 \\
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

###----------------------------#
### NODE EXPORTER INSTALLATION
###----------------------------#

echo "[+] Adding Node Exporter user..."
sudo useradd --no-create-home --shell /bin/false node_exporter

echo "[+] Downloading Node Exporter..."
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvzf node_exporter-1.6.1.linux-amd64.tar.gz

echo "[+] Installing Node Exporter..."
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.6.1.linux-amd64*

echo "[+] Creating Node Exporter systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
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
ExecStart=/usr/local/bin/node_exporter \\
  --collector.logind

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

###----------------------------#
### GRAFANA INSTALLATION (SAFE)
###----------------------------#

echo "[+] Installing Grafana (secure method)..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana

sudo systemctl enable grafana-server
sudo systemctl start grafana-server

###----------------------------#
### FINAL STATUS
###----------------------------#

echo "[✔] Installation completed! Service statuses below:"
sudo systemctl status prometheus --no-pager
sudo systemctl status node_exporter --no-pager
sudo systemctl status grafana-server --no-pager

echo "[🚀] Access your services:"
echo "- Prometheus:     http://<your-server-ip>:9090"
echo "- Node Exporter:  http://<your-server-ip>:9100"
echo "- Grafana:        http://<your-server-ip>:3000"
echo "  (default login: admin / admin — you'll be asked to change it)"
