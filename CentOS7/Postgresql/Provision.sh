# EPEL and Update
#yum -y install epel-release
#yum -y update

cat >> /etc/yum.repos.d/postgresql95.repo << EOF
[postgresql95]
name=PostgreSQL 9.5 CentoOS 7
baseurl=https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64
gpgcheck=0
enabled=1
EOF

yum -y install postgresql-server

postgresql-setup initdb

systemctl enable postgresql
systemctl start postgresql
