# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
cat > /etc/yum.repos.d/kibana.repo << EOF
[kibana-4.6]
name=Kibana repository for 4.6.x packages
baseurl=https://packages.elastic.co/kibana/4.6/centos
gpgcheck=0
enabled=1
EOF

# Install
yum -y install kibana
systemctl enable kibana
systemctl start kibana
