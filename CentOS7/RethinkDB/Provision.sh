# EPEL and Update
#yum -y install epel-release 
#yum -y update

cat >> /etc/yum.repos.d/powerdns-auth-40.repo << EOF
[rethinkdb]
name=RethinkDB
baseurl=https://download.rethinkdb.com/centos/7/x86_64/
gpgcheck=0
enabled=1
EOF

yum -y install screen rethinkdb

screen "rethinkdb --bind all" &
