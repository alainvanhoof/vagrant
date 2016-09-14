# EPEL and Update
yum -y install epel-release 
#yum -y update

cat >> /etc/yum.repos.d/powerdns-auth-40.repo << EOF
[powerdns-dnsdist-11]
name=PowerDNS repository for dnsdist - version 1.1.X
baseurl=http://repo.powerdns.com/centos/x86_64/7/dnsdist-11
gpgcheck=0
enabled=1
priority=90
includepkg=dnsdist*
EOF

yum -y install yum-plugin-priorities

yum -y install dnsdist

cat > /etc/dnsdist/dnsdist.conf << EOF
newServer("192.168.0.12")
newServer("8.8.8.8")
setServerPolicy(firstAvailable) -- first server within its QPS limit
webserver("10.0.0.170:8080", "admin", "APIkey")
EOF

systemctl enable dnsdist
systemctl start dnsdist
