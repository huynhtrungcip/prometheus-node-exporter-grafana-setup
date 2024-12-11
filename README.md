# 🌐 Monitoring Stack Setup: Prometheus, Node Exporter, and Grafana  

**Version**: 1.0  
**Author**: [Trung Huynh Chi](https://www.linkedin.com/in/trung-huynh-chi-pc01/)  

![Bash](https://img.shields.io/badge/Script-Bash-blue)  
![License](https://img.shields.io/badge/License-MIT-green)  
![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange)  

---

This repository contains a Bash script for automating the installation and configuration of **Prometheus**, **Node Exporter**, and **Grafana** on Ubuntu 20.04. It provides a robust setup for system monitoring and visualization.

---

## ✨ Features  

- 🚀 Complete installation and configuration of Prometheus, Node Exporter, and Grafana.  
- 🔒 Enhanced security with dedicated system users for Prometheus and Node Exporter.  
- 🔄 Services configured to start on boot using systemd.  
- 📋 Clean, step-by-step execution for user convenience.  

---

## 📋 Prerequisites  

Before running the script, ensure the following:  

- ✅ Fresh installation of Ubuntu 20.04.  
- ✅ `sudo` privileges for the user executing the script.  
- ✅ Internet connection to download required software packages.  

---

## 🚰 How to Use  

### 1⃣ Clone the Repository  

```bash  
git clone https://github.com/huynhtrungcip/prometheus-node-exporter-grafana-setup.git  
cd prometheus-node-exporter-grafana-setup  
```  

### 2⃣ Make the Script Executable  

```bash  
chmod +x install_monitoring.sh  
```  

### 3⃣ Run the Script  

```bash  
dos2unix install_monitoring.sh  
sudo ./install_monitoring.sh  
```  

### 4⃣ Verify Service Status  

After the script runs, you can verify the status of the services:  

```bash  
sudo systemctl status prometheus  
sudo systemctl status node_exporter  
sudo systemctl status grafana-server  
```  

---

## 🔅 Access the Services  

- **Prometheus**: `http://<your-server-ip>:9090`  
- **Node Exporter**: `http://<your-server-ip>:9100`  
- **Grafana**: `http://<your-server-ip>:3000`  

> **Default Grafana Credentials:**  
> - Username: `admin`  
> - Password: `admin`  

### 🔒 Change Grafana Password  

Upon first login, you will be prompted to change the default password. Use a secure password.  

---

## 📂 Script Details  

The script automates the following steps:  

### 1⃣ **Prometheus Installation**  

- Creates a dedicated user: `prometheus`.  
- Downloads and installs Prometheus binaries.  
- Sets up necessary directories and permissions.  
- Configures Prometheus as a systemd service.  

### 2⃣ **Node Exporter Installation**  

- Creates a dedicated user: `node_exporter`.  
- Downloads and installs Node Exporter binary.  
- Configures Node Exporter as a systemd service.  

### 3⃣ **Grafana Installation**  

- Installs Grafana from the official repository.  
- Configures Grafana to start on boot.  

---

## 🛑 Troubleshooting  

### ✅ Check Service Logs  

If any service fails, check the logs for more information:  

```bash  
journalctl -u prometheus  
journalctl -u node_exporter  
journalctl -u grafana-server  
```

### ✅ Check Configuration File  

Make sure the configuration file is as follows:  

**✒prometheus.service**
```bash  
sudo vim /etc/systemd/system/prometheus.service 
```
```bash  
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
```

**✒node_exporter.service**
```bash  
sudo vim /etc/systemd/system/node_exporter.service 
```
```bash  
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
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind

[Install]
WantedBy=multi-user.target 
```

**✒prometheus.yml**
```bash  
sudo vim /etc/prometheus/prometheus.yml 
```
```bash  
...
  - job_name: node_export
    static_configs:
      - targets: ["localhost:9100"]
```

**✒datasources.yaml**
```bash  
sudo vim /etc/grafana/provisioning/datasources/datasources.yaml 
```
```bash  
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    url: http://localhost:9090
    isDefault: true
```


### ✅ Common Fixes  

- Ensure all dependencies are installed.  
- Restart services if necessary:  

```bash  
sudo systemctl restart prometheus  
sudo systemctl restart node_exporter  
sudo systemctl restart grafana-server  
```  

---

## 🤝 Contributions  

Contributions are welcome! Submit issues or pull requests to improve the script or documentation.  

---

## 📜 License  

This repository is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.  

---  

Start monitoring your systems with ease! 🚀

