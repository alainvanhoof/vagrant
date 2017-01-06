# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat >> /etc/yum.repos.d/ceph.repo << EOF
[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-kraken/el7/noarch
enabled=1
gpgcheck=0
type=rpm-md
EOF

yum -y install ceph-deploy

rm /etc/yum.repos.d/ceph.repo

useradd cephadmin
mkdir -p /home/cephadmin/.ssh/
chown cephadmin:cephadmin /home/cephadmin/.ssh/
chmod 700 /home/cephadmin/.ssh/
cp /vagrant/id_rsa* /home/cephadmin/.ssh/.
cp /vagrant/id_rsa.pub /home/cephadmin/.ssh/authorized_keys
cat > /home/cephadmin/.ssh/config << EOF
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
EOF
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

su - cephadmin -c "ceph-deploy new ceph01"
echo "osd pool default size = 2" >> /home/cephadmin/ceph.conf
su - cephadmin -c "ceph-deploy install cephadmin ceph01 ceph02 ceph03"
su - cephadmin -c "ceph-deploy mon create-initial"
su - cephadmin -c "ceph-deploy osd prepare ceph01:/storage ceph02:/storage ceph03:/storage"
su - cephadmin -c "ceph-deploy osd activate ceph01:/storage ceph02:/storage ceph03:/storage"
su - cephadmin -c "ceph-deploy admin cephadmin ceph01 ceph02 ceph03" 
chmod 644 /etc/ceph/ceph.client.admin.keyring

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")
if [ $IP != "10.0.0.170" ]; then echo "CEPH Admin-node";fi

