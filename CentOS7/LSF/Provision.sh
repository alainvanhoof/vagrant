# EPEL and Update
#yum -y install epel-release
yum -y update

yum -y install ed

#yum -y groupinstall "Development Tools"

cat >> /etc/hosts << EOF

10.0.0.100 lsfmaster
10.0.0.101 lsf01 
10.0.0.102 lsf02
10.0.0.103 lsf03
10.0.0.104 lsf04
EOF

mkdir /root/.ssh
chmod 500 /root/.ssh
cp /vagrant/id_rsa* /root/.ssh/.
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
chmod 400 /root/.ssh/*

mkdir -p /opt/lsf
useradd -d /opt/lsf -M lsfadmin 
chown lsfadmin /opt/lsf/
