# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/selinux/config

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=0
enabled=1
autorefresh=1
type=rpm-md
EOF

yum -y install graphite-web graphite-web-selinux mariadb mariadb-server MySQL-python python-carbon python-whisper collectd packetbeat metricbeat filebeat

systemctl start mariadb
systemctl enable mariadb

mysql -e "CREATE DATABASE graphite;"
mysql -e "GRANT ALL PRIVILEGES ON graphite.* TO 'graphite'@'localhost' IDENTIFIED BY 'graphitePW01Vxzsigavms';"
mysql -e 'FLUSH PRIVILEGES;'

cat >> /etc/graphite-web/local_settings.py <<EOF
SECRET_KEY = 'AfwaesgjhsgFDRAG45'
DATABASES = {
 'default': {
 'NAME': 'graphite',
 'ENGINE': 'django.db.backends.mysql',
 'USER': 'graphite',
 'PASSWORD': 'graphitePW01Vxzsigavms',
 }
}
EOF

/usr/lib/python2*/site-packages/graphite/manage.py syncdb --noinput

sed -i -e "s/Require local/Require all granted/" /etc/httpd/conf.d/graphite-web.conf

cat >> /etc/carbon/storage.conf << EOF
[collectd]
pattern = ^collectd.*
retentions = 10s:1d,1m:7d,10m:1y
EOF

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

systemctl start carbon-cache
systemctl enable carbon-cache
systemctl start httpd
systemctl enable httpd
systemctl start collectd
systemctl enable collectd

systemctl enable packetbeat
systemctl enable metricbeat
systemctl enable filebeat
systemctl start packetbeat
systemctl start metricbeat
systemctl start filebeat

