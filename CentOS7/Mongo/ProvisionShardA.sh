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

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")

sed -i -e "s/  bindIp: 127.0.0.1/  bindIp: ${IP}/" /etc/mongod.conf

cat >> /etc/mongod.conf << EOF
sharding:
  clusterRole: shardsvr
replication:
  replSetName: MongoShardA
EOF

cat > /root/init_mongo_repl.js << EOF
rs.initiate();
EOF

if [ $IP != "10.0.0.143" ]; then
cat > /root/init_mongo_repl.js << EOF
rs.add("${IP}");
EOF
fi

systemctl enable mongod
systemctl start mongod

sleep 5
mongo mongodb://10.0.0.143 < /root/init_mongo_repl.js
