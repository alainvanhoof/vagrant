# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat >> /etc/yum.repos.d/mongo3.repo << EOF
[mongodb-org-3-stable]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/stable/x86_64/
gpgcheck=0
enabled=1
EOF

yum -y install mongodb-org

systemctl enable mongod
systemctl start mongod
