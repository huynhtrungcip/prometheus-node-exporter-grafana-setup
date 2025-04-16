# 🌐 Monitoring Stack Setup: Prometheus, Node Exporter, and Grafana

**Version:** 1.0  
**Author:** Trung Huynh Chi

---

This repository provides a one-click Bash script to set up **Prometheus**, **Node Exporter**, and **Grafana** on **Ubuntu 20.04+** for full system monitoring and visualization.

---

## ✨ Features

- 🔧 Automated installation of Prometheus, Node Exporter, and Grafana
- 🔐 Dedicated Linux users for each service for security
- 🚀 Services run as systemd and auto-start on reboot
- 📊 Grafana ready to visualize system metrics from Prometheus

---

## 📋 Prerequisites

Make sure you have:

- ✅ A fresh Ubuntu 20.04 or later
- ✅ Internet connection
- ✅ `sudo` privileges

---

## 🚀 Quick Start

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
dos2unix install_monitoring.sh  # Optional if you're on Windows before
sudo ./install_monitoring.sh
```

### 4⃣ Check Services

```bash
sudo systemctl status prometheus
sudo systemctl status node_exporter
sudo systemctl status grafana-server
```

---

## 🌐 Access the Services

| Service       | URL                           |
|---------------|--------------------------------|
| Prometheus    | http://<your-ip>:9090         |
| Node Exporter | http://<your-ip>:9100         |
| Grafana       | http://<your-ip>:3000         |

> **Grafana Login**:  
> Username: `admin`  
> Password: `admin` → You will be prompted to change it.

---

## 🔍 Troubleshooting

### Check Logs

```bash
journalctl -u prometheus
journalctl -u node_exporter
journalctl -u grafana-server
```

### Restart Services

```bash
sudo systemctl restart prometheus
sudo systemctl restart node_exporter
sudo systemctl restart grafana-server
```

---

## 🤝 Contributions

Pull requests and suggestions are welcome!

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

🚀 Happy Monitoring!

