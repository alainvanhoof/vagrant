# EPEL and Update
#yum -y install epel-release
#yum -y update

yum -y install ed

cat >> /etc/hosts << EOF
# LSF
10.0.0.100 lsfmaster
10.0.0.101 lsf01 
10.0.0.102 lsf02
10.0.0.103 lsf03
10.0.0.104 lsf04
EOF

mkdir /root/.ssh
cp /vagrant/id_rsa* /root/.ssh/.
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
cat >> root/.ssh/config << EOF
Host *
    StrictHostKeyChecking no
EOF
chmod 700 /root/.ssh
chmod 400 /root/.ssh/*

cat > /etc/exports << EOF
/export/lsf  10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash)
/export/home 10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash)
EOF

mkdir -p /export/lsf
chmod 777 /export/lsf

mkdir -p /export/home
chmod 777 /export/home

systemctl enable nfs-server
systemctl start nfs-server

mkdir -p /opt/lsf
chmod 777 /opt/lsf
mount -t nfs 10.0.0.100:/export/lsf /opt/lsf
useradd -d /opt/lsf -M lsfadmin 
chown lsfadmin /opt/lsf/

mkdir -p /glb/home
chmod 777 /glb/home
mount -t nfs 10.0.0.100:/export/home /glb/home
useradd -d /glb/home/lsfuser -m lsfuser
cat >> /glb/home/lsfuser/.bashrc << EOF

source /opt/lsf/conf/profile.lsf
EOF
