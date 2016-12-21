# Update
yum -y update

# Prometheus
cd /root
curl -LO "https://github.com/prometheus/prometheus/releases/download/v1.4.1/prometheus-1.4.1.linux-amd64.tar.gz"
mkdir /root/Prometheus
cd /root/Prometheus
tar -zxf ../prometheus-1.4.1.linux-amd64.tar.gz 
cd /root
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v0.13.0/node_exporter-0.13.0.linux-amd64.tar.gz"
cd /root/Prometheus
tar -zxf ../node_exporter-0.13.0.linux-amd64.tar.gz

cat >> /root/Prometheus/prometheus-1.4.1.linux-amd64/prometheus.yml << EOF
  - job_name:       'node'
    static_configs:
      - targets: ['localhost:9100']
EOF

nohup /root/Prometheus/prometheus-1.4.1.linux-amd64/prometheus -config.file=/root/Prometheus/prometheus-1.4.1.linux-amd64/prometheus.yml> /var/log/prometheus.log 2>&1 &
nohup /root/Prometheus/node_exporter-0.13.0.linux-amd64/node_exporter> /var/log/cwnode-exporter.log 2>&1 &
