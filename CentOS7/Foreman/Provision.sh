# EPEL and Update
yum -y install epel-release
yum -y update

# The Foreman
cat > /etc/yum.repos.d/foreman.repo << EOF
[foreman]
name=Foreman 1.11
baseurl=http://yum.theforeman.org/releases/1.11/el7/x86_64
enabled=1
gpgcheck=0
EOF
cat > /etc/yum.repos.d/foreman-plugins.repo << EOF
[foreman-plugins]
name=Foreman plugins 1.11
baseurl=http://yum.theforeman.org/plugins/1.11/el7/x86_64
enabled=1
gpgcheck=0
EOF

yum -y install centos-release-scl
yum -y install foreman foreman-installer

cat >> /etc/hosts << EOF
10.0.0.30 foreman01 foreman01.lafeberhof.nl
EOF

foreman-installer

systemctl enable foreman
systemctl start foreman

