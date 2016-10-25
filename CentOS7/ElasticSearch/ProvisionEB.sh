# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat > /etc/exports << EOF
/export/backup 10.0.0.0/24(rw,sync,no_subtree_check,no_root_squash)
EOF

mkdir -p /export/backup
chmo 777 -p /export/backup

systemctl enable nfs-server
systemctl start nfs-server

