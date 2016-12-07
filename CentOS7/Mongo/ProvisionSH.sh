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

sed -i -e "s/  bindIp: 127.0.0.1/  bindIp: ${IP}/" /etc/mongos.conf

cat >> /etc/mongos.conf << EOF
sharding:
  configDB: MongoClusterA/10.0.0.140:27017,10.0.0.141:27017,10.0.0.142:27017
EOF

cat > usr/lib/systemd/system/mongos.service << EOF
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=mongod
Group=mongod
Environment="OPTIONS=--quiet --config /etc/mongos.conf"
ExecStart=/bin/mongos $OPTIONS 
PIDFile=/var/run/mongodb/mongos.pid
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false
# Recommended limits for for mongod as specified in
# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings

[Install]
WantedBy=multi-user.target
EOF
