# EPEL and Update
yum -y install epel-release 
#yum -y update

yum -y install yum-plugin-priorities

# Install PostgreSQL

cat >> /etc/yum.repos.d/postgresql95.repo << EOF
[postgresql95]
name=PostgreSQL 9.5 CentoOS 7
baseurl=https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64
gpgcheck=0
enabled=1
EOF

yum -y install postgresql-server

postgresql-setup initdb

cat > /var/lib/pgsql/data/pg_hba.conf << EOF
local all        all                     trust
host  all        all        127.0.0.1/32 trust
host  all        all        ::1/128      trust
EOF

systemctl enable postgresql
systemctl start postgresql

# Install PowerDNS Authorative Server

cat >> /etc/yum.repos.d/powerdns-auth-40.repo << EOF
[powerdns-auth-40]
name=PowerDNS repository for PowerDNS Authoritative Server - version 4.0.X
baseurl=http://repo.powerdns.com/centos/x86_64/7/auth-40
gpgcheck=0
enabled=1
priority=90
includepkg=pdns*
EOF

yum -y install pdns pdns-backend-postgresql

sudo -u postgres psql -c "CREATE DATABASE pdns;"
sudo -u postgres psql pdns < /usr/share/doc/pdns-backend-postgresql-*/schema.pgsql.sql
sudo -u postgres psql -c "CREATE USER pdns WITH PASSWORD 'pdn456';"
sudo -u postgres psql -c "GRANT ALL ON DATABASE pdns TO pdns;"
sudo -u postgres psql pdns -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO pdns;"
sudo -u postgres psql pdns -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO pdns;"

systemctl restart postgresql

cat > /etc/pdns/pdns.conf << EOF
launch=gpgsql
#allow-recursion=
#recursor=127.0.0.1
#local-address=
gpgsql-host=127.0.0.1
gpgsql-dbname=pdns
gpgsql-user=pdns
gpgsql-password=pdsn456
webserver=yes
api=yes
api-key=RKLWhrd123
webserver-address=0.0.0.0
webserver-allow-from=0.0.0.0/0,::/0
EOF

systemctl enable pdns
systemctl start pdns
