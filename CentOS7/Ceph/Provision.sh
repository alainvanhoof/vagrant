# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

useradd cephadmin
mkdir -p /home/cephadmin/.ssh/
chown cephadmin:cephadmin /home/cephadmin/.ssh/
chmod 700 /home/cephadmin/.ssh/
cp /vagrant/id_rsa* /home/cephadmin/.ssh/.
cp /vagrant/id_rsa.pub /home/cephadmin/.ssh/authorized_keys
chown cephadmin:cephadmin /home/cephadmin/.ssh/*
chmod 400 /home/cephadmin/.ssh/*

echo "cephadmin ALL = (root) NOPASSWD:ALL" > /etc/sudoers.d/ceph
chmod 440 /etc/sudoers.d/ceph

cat >> /etc/hosts << EOF
10.0.0.170 cephadmin
10.0.0.171 ceph01
10.0.0.172 ceph02
10.0.0.173 ceph03
EOF

mkdir -p /storage
chown 167:167 /storage

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")
if [ $IP != "10.0.0.170" ]; then echo "CEPH Admin-node";fi

