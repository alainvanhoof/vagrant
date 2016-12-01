# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat >> /etc/yum.repos.d/mongodb-org.repo << EOF
[mongodb-org-stable]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.4/x86_64/
gpgcheck=0
enabled=1
EOF

yum -y install mongodb-org

sed -i -e "s/  bindIp: 127.0.0.1/  bindIp: 10.0.0.142/" /etc/mongod.conf

cat >> /etc/mongod.conf << EOF
sharding:
  clusterRole: configsvr
replication:
  replSetName: MongoClusterA
EOF

cat > /root/init_mongo_repl.js << EOF
rs.add("10.0.0.142");
EOF

systemctl enable mongod
systemctl start mongod

sleep 5

mongo mongodb://10.0.0.140 < /root/init_mongo_repl.js

