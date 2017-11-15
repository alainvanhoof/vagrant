# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/exports << EOF
/export/backup 10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash)
EOF

mkdir -p /export/backup
chmod 777 /export/backup

systemctl enable nfs-server
systemctl start nfs-server

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=0
enabled=1
autorefresh=1
type=rpm-md
EOF

yum -y install packetbeat metricbeat filebeat collectd

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

systemctl enable packetbeat
systemctl enable metricbeat
systemctl enable filebeat
systemctl enable collectd
systemctl start packetbeat
systemctl start metricbeat
systemctl start filebeat
systemctl start collectd

