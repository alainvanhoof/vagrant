# EPEL and Update
yum -y install epel-release 
#yum -y update

cat >> /etc/yum.repos.d/powerdns-auth-40.repo << EOF
[powerdns-rec-40]
name=PowerDNS repository for PowerDNS Recursor - version 4.0.X
baseurl=http://repo.powerdns.com/centos/x86_64/7/rec-40
gpgcheck=0
enabled=1
priority=90
includepkg=pdns*
EOF

yum -y install yum-plugin-priorities

yum -y install pdns-recursor

systemctl enable pdns-recursor
systemctl start pdns-recursor
