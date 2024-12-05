
markdown
Đang tải...
# 🌐 Monitoring Stack Setup: Prometheus, Node Exporter, and Grafana  

**Version**: 1.0  
**Author**: [Trung Huynh](https://www.linkedin.com/in/trung-huynh-chi-pc01/)  

![Bash](https://img.shields.io/badge/Script-Bash-blue)  
![License](https://img.shields.io/badge/License-MIT-green)  
![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange)  

---

This repository contains a Bash script that automates the installation and configuration of **Prometheus**, **Node Exporter**, and **Grafana** on an Ubuntu 20.04 system. These tools are widely used for system monitoring and visualization.

## ✨ Features

- 🚀 Automates installation of Prometheus, Node Exporter, and Grafana.
- 🔒 Sets up system users for security isolation.
- 🔄 Configures services to start automatically on boot.
- 📚 Provides detailed instructions for accessing the services.

## 📋 Prerequisites

Before running the script, ensure the following:

- ✅ A fresh installation of Ubuntu 20.04.
- ✅ `sudo` privileges for the user running the script.

## 🛠️ How to Use the Script

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/huynhtrungcip/prometheus-node-exporter-grafana-setup.git
cd <repository-directory>
```

### 2️⃣ Make the Script Executable
```bash
chmod +x install_monitoring.sh
```

### 3️⃣ Run the Script
```bash
sudo ./install_monitoring.sh
```

### 4️⃣ Access the Services

- **Prometheus**: `http://<your-server-ip>:9090`
- **Node Exporter**: `http://<your-server-ip>:9100`
- **Grafana**: `http://<your-server-ip>:3000`

> **Default Credentials for Grafana:**
> - Username: `admin`
> - Password: `admin`

### 5️⃣ Change Grafana Default Password
Upon first login, you will be prompted to change the password. Choose a secure one.

## 📂 Script Overview

### 🔹 Prometheus

- Creates a dedicated system user: `prometheus`.
- Downloads and installs Prometheus binary.
- Configures Prometheus to run as a service.

### 🔹 Node Exporter

- Creates a dedicated system user: `node_exporter`.
- Downloads and installs Node Exporter binary.
- Configures Node Exporter to run as a service.

### 🔹 Grafana

- Installs Grafana from the official repository.
- Configures Grafana to start on boot.

## 🛠️ Troubleshooting

### ✅ Check Service Status
Use the following commands to check the status of the installed services:
```bash
sudo systemctl status prometheus
sudo systemctl status node_exporter
sudo systemctl status grafana-server
```

### 🪵 View Logs
If any service fails, view logs for detailed error messages:
```bash
journalctl -u prometheus|node_exporter|grafana-server
```

## 🤝 Contribution

Contributions are welcome! If you find any issues or have suggestions for improvement, feel free to submit a pull request.

## 📜 License

This project is licensed under the MIT License. See the LICENSE file for details.
