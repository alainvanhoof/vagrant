# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/yum.repos.d/elasticsearch5.repo << EOF
[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=0
enabled=1
autorefresh=1
type=rpm-md
EOF

yum -y install packetbeat metricbeat filebeat elasticsearch java-1.8.0-openjdk-headless collectd

cat >> /etc/elasticsearch/elasticsearch.yml << EOF
node.name: "es01"
cluster.name: "esc01"
network.host: _eth1:ipv4_
path.repo: ["/backup"]
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF

sed -i -e 's/-Xms2g/-Xms768m/' /etc/elasticsearch/jvm.options
sed -i -e 's/-Xmx2g/-Xmx768m/' /etc/elasticsearch/jvm.options

mkdir /backup
chmod 777 /backup
mount -t nfs 10.0.0.123:/export/backup /backup

sysctl --system

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

systemctl enable elasticsearch
systemctl enable packetbeat
systemctl enable metricbeat
systemctl enable filebeat
systemctl enable collectd
systemctl start elasticsearch
systemctl start packetbeat
systemctl start metricbeat
systemctl start filebeat
systemctl start collectd

