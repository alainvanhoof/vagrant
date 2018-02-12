# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
cat > /etc/yum.repos.d/opennebula.repo << EOF
[opennebula]
name=opennebula
baseurl=http://downloads.opennebula.org/repo/5.4/CentOS/7/x86_64
enabled=1
gpgcheck=0
EOF

# Install
yum -y install opennebula-server opennebula-sunstone opennebula-ruby opennebula-gate opennebula-flow

yum -y install redhat-lsb

/usr/share/one/install_gems --yes

cat /var/lib/one/.one/one_auth

systemctl enable opennebula
systemctl start opennebula
systemctl enable opennebula-sunstone
systemctl start opennebula-sunstone
