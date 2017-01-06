# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

yum -y install git

cd /root

curl -O https://dl.gogs.io/gogs_v0.9.113_linux_amd64.tar.gz

tar -zxvf gogs_v0.9.113_linux_amd64.tar.gz

cd /root/gogs

./gogs web &
