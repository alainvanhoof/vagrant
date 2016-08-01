# EPEL and Update
yum -y install epel-release
yum -y update

# MongoDB
yum -y install mongodb-server
systemctl enable mongod
systemctl start mongod

# QPID
#yum -y install qpid-cpp-server qpid-cpp-server-store
yum -y install qpid-cpp-server qpid-cpp-server-linearstore
systemctl enable qpidd
systemctl start qpidd

# Pulp
curl https://repos.fedorapeople.org/repos/pulp/pulp/rhel-pulp.repo -o /etc/yum.repos.d/pulp.repo
yum -y groupinstall pulp-server-qpid pulp-admin
sudo -u apache pulp-manage-db
systemctl enable httpd
systemctl start httpd
systemctl enable pulp_workers
systemctl start pulp_workers
systemctl enable pulp_celerybeat
systemctl start pulp_celerybeat
systemctl enable pulp_resource_manager
systemctl start pulp_resource_manager
sed -i -e "s/# verify_ssl: True/verify_ssl: False/" /etc/pulp/admin/admin.conf
sed -i -e "s/# verify_ssl: true/verify_ssl: false/" /etc/pulp/server.conf
sed -i -e "s/# verify_ssl: true/verify_ssl: false/" /etc/pulp/repo_auth.conf
mkdir /root/.pulp/
chmod 700 /root/.pulp
cat > /root/.pulp/admin.conf << EOF
[auth]
username: admin
password: admin
EOF
chmod 600 /root/.pulp/admin.conf
