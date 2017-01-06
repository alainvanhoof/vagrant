# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/exports << EOF
/export/storage 10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash)
EOF

mkdir -p /export/storage
chmod 777 /export/storage

systemctl enable nfs-server
systemctl start nfs-server
