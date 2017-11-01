cat > /etc/yum.repos.d/grafana.repo << EOF
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/7/x86_64/
enabled=1
gpgcheck=0
EOF

yum -y install grafana
systemctl enable grafana-server
systemctl start grafana-server
