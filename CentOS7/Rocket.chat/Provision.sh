# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Mongo Install script
cat > /etc/yum.repos.d/mongodb.repo << EOF
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF

# Rocket.chat install
yum install -y nodejs curl GraphicsMagick npm mongodb-org-server mongodb-org
npm install -g inherits n

n 0.10.40
cd /root
curl -L https://rocket.chat/releases/latest/download -o rocket.chat.tgz
tar zxvf rocket.chat.tgz
mv bundle Rocket.Chat
cd Rocket.Chat/programs/server
npm install
cd ../..

export PORT=3000
export ROOT_URL=http://localhost:3000/
export MONGO_URL=mongodb://localhost:27017/rocketchat

systemctl enable mongod
systemctl start mongod

cat > /usr/lib/systemd/system/rocketchat.service << EOF
[Unit]
  Description=The Rocket.Chat  server
  After=network.target remote-fs.target nss-lookup.target nginx.target mongod.target
  [Service]
  ExecStart=/usr/local/bin/node /root/Rocket.Chat/main.js
  StandardOutput=syslog
  StandardError=syslog
  SyslogIdentifier=rocketchat
  User=root
  Environment=MONGO_URL=mongodb://localhost:27017/rocketchat ROOT_URL=http://localhost:3000/ PORT=3000
  [Install]
  WantedBy=multi-user.target
EOF

systemctl enable rocketchat.service
systemctl start rocketchat.service
