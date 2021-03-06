# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/yum.repos.d/grafana.repo << EOF
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/7/x86_64/
enabled=1
gpgcheck=0
EOF

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=0
enabled=1
autorefresh=1
type=rpm-md
EOF

yum -y install grafana packetbeat metricbeat filebeat collectd

sed -i -e 's/localhost:9200/10.0.0.120:9200/' /etc/*beat/*beat.yml

cat >> /etc/collectd.conf << EOF
LoadPlugin write_graphite
<Plugin write_graphite>
    <Node "graphing">
        Host "10.0.0.126"
        Port "2003"
        Protocol "tcp"
        LogSendErrors true
        Prefix "collectd."
        StoreRates true
        AlwaysAppendDS false
        EscapeCharacter "_"
    </Node>
</Plugin>
EOF

setsebool -P collectd_tcp_network_connect 1

systemctl enable grafana-server
systemctl enable packetbeat
systemctl enable metricbeat
systemctl enable filebeat
systemctl enable collectd
systemctl start grafana-server
systemctl start packetbeat
systemctl start metricbeat
systemctl start filebeat
systemctl start collectd

