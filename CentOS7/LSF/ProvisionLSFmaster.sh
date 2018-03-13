# EPEL and Update
#yum -y install epel-release
yum -y update
yum -y install ed

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

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
