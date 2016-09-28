# EPEL and Update
yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
#cat > /etc/yum.repos.d/NAME.repo << EOF
#EOF

# Install

yum -y install erlang rabbitmq-server

rabbitmq-plugins enable rabbitmq_management

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
