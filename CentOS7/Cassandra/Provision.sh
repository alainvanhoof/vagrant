# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/yum.repos.d/cassandra.repo << EOF
[datastax]
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 0
EOF

yum -y install java-1.8.0-openjdk-headless dsc30

sed -i -e "s/cluster_name: 'Test Cluster'/cluster_name: 'Cassandra Cluster 01'/" /etc/cassandra/default.conf/cassandra.yaml
sed -i -e "s/seeds: \"127.0.0.1\"/seeds: \"10.0.0.130\"/" /etc/cassandra/default.conf/cassandra.yaml
sed -i -e "s/listen_address: localhost/# listen_address: localhost/" /etc/cassandra/default.conf/cassandra.yaml
sed -i -e "s/^# listen_interface: eth0/listen_interface: eth1/" /etc/cassandra/default.conf/cassandra.yaml

systemctl enable cassandra
systemctl start cassandra

