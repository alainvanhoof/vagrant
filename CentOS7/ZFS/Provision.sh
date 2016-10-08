# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

cat >> /etc/yum.repos.d/zfs.repo << EOF
[zfs]
name=ZFS on Linux for EL7 - dkms
baseurl=http://download.zfsonlinux.org/epel/7/x86_64/
enabled=0
gpgcheck=0
[zfs-kmod]
name=ZFS on Linux for EL7 - kmod
baseurl=http://download.zfsonlinux.org/epel/7/kmod/x86_64/
enabled=1
gpgcheck=0
EOF

yum -y install zfs nfs-utils

modprobe zfs

# NFS Shares

systemctl enable nfs-server
systemctl start nfs-server