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

yum -y install logstash packetbeat metricbeat filebeat collectd java-1.8.0-openjdk-headless

cat > /etc/logstash/conf.d/basic.conf << EOF
input {
  file {
    path => "/var/log/logstash/logstash-plain.log"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["10.0.0.120:9200"]
  }
  stdout { codec => rubydebug }
}
EOF

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

sed -i -e 's/localhost:9200/10.0.0.120:9200/' /etc/*beat/*beat.yml

systemctl enable logstash
systemctl enable packetbeat
systemctl enable metricbeat
systemctl enable filebeat
systemctl enable collectd
systemctl start logstash
systemctl start packetbeat
systemctl start metricbeat
systemctl start filebeat
systemctl start collectd

