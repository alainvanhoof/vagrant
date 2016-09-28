# EPEL and Update
yum -y install epel-release
#yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# install Redis

yum -y install redis
systemctl enable redis
systemctl start redis

# Create YUM Repo
cat > /etc/yum.repos.d/sensu.repo << EOF
[sensu]
name=sensu
baseurl=http://sensu.global.ssl.fastly.net/yum/x86_64/
gpgcheck=0
enabled=1
EOF

# Install
yum -y install sensu

cat > /etc/sensu/config.json << EOF
{
  "redis": {
    "host": "127.0.0.1"
  },
  "transport": {
    "name": "redis"
  },
  "api": {
    "host": "127.0.0.1",
    "port": 4567
  }
}
EOF

cat > /etc/sensu/conf.d/client.json << EOF
{
  "client": {
    "name": "sensu01",
    "address": "127.0.0.1",
    "environment": "development",
    "subscriptions": [
      "dev"
    ],
    "socket": {
      "bind": "127.0.0.1",
      "port": 3030
    }
  }
}
EOF

systemctl enable sensu-server
systemctl enable sensu-api
systemctl enable sensu-client
systemctl start sensu-server
systemctl start sensu-api
systemctl start sensu-client

# Install uchiwa dashboard

yum -y install http://dl.bintray.com/palourde/uchiwa/uchiwa-0.18.2-1.x86_64.rpm

cat > /etc/sensu/uchiwa.json << EOF
{
  "sensu": [
      {
      "name": "DC01",
      "host": "localhost",
      "port": 4567,
      "timeout": 10
    }
 ]
}
{
  "uchiwa": {
    "host": "0.0.0.0",
    "port": 3000,
    "refresh": 10
  }
}
EOF

systemctl enable uchiwa
systemctl start uchiwa

