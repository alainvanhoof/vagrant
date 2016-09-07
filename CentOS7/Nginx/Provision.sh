# EPEL and Update
#yum -y install epel-release
#yum -y update

cat >> /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

yum -y install nginx

systemctl enable nginx
systemctl start nginx
