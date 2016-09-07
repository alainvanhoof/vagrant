# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat >> /etc/yum.repos.d/elasticsearch2.repo << EOF
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=0
enabled=1
EOF

yum -y install java-1.8.0-openjdk-headless
yum -y install elasticsearch

cat >> /etc/elasticsearch/elasticsearch.yml << EOF
node.name: "es01"
cluster.name: "esc01"
network.host: _eth0:ipv4_
EOF

systemctl enable elasticsearch
systemctl start elasticsearch