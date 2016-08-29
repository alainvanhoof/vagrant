# EPEL and Update
# yum -y install epel-release
yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Gitlab Install script
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

# GitLab install
yum -y install gitlab-ce
gitlab-ctl reconfigure
