# EPEL and Update
#yum -y install epel-release 
#yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux

cat > /etc/yum.repos.d/zabbix-3.2.repo << EOF
[zabbix]
name=Zabbix Official Repository - 3.2
baseurl=http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/
enabled=1
gpgcheck=0

[zabbix-non-supported]
name=Zabbix Official Repository non-supported  
baseurl=http://repo.zabbix.com/non-supported/rhel/7/x86_64/
enabled=1
gpgcheck=0
EOF

cat >> /etc/yum.repos.d/postgresql95.repo << EOF
[postgresql95]
name=PostgreSQL 9.5 CentoOS 7
baseurl=https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64
gpgcheck=0
enabled=1
EOF

yum -y install postgresql-server zabbix-server-pgsql zabbix-web-pgsql

postgresql-setup initdb

cat > /var/lib/pgsql/data/pg_hba.conf << EOF
local zabbix     zabbix                  trust
host  zabbix     zabbix     127.0.0.1/32 trust
host  zabbix     zabbix     ::1/128      trust
local all        all                     ident
host  all        all        127.0.0.1/32 ident
host  all        all        ::1/128      ident
EOF

systemctl enable postgresql
systemctl start postgresql

cd /tmp
sudo -u postgres psql -c "CREATE DATABASE zabbix ENCODING 'UTF8';"
zcat /usr/share/doc/zabbix-server-pgsql-*/create.sql.gz | sudo -u postgres psql zabbix 
sudo -u postgres psql -c "CREATE USER zabbix WITH PASSWORD 'zabbix';"
sudo -u postgres psql -c "GRANT ALL ON DATABASE zabbix TO zabbix;"
sudo -u postgres psql zabbix -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO zabbix;"
sudo -u postgres psql zabbix -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO zabbix;"

#sudo -u postgres psql -c "CREATE ROLE zabbix WITH LOGIN PASSWORD 'zabbix'"
#sudo -u postgres createdb -O zabbix -E UTF8 zabbix
#zcat //usr/share/doc/zabbix-server-pgsql-*/create.sql.gz | sudo -u postgres psql -U zabbix -d zabbix 

systemctl restart postgresql

sed -i -e "s%# php_value date.timezone Europe/Riga%php_value date.timezone Europe/Amsterdam%"  /etc/httpd/conf.d/zabbix.conf

systemctl enable zabbix-server
systemctl start zabbix-server
systemctl enable httpd
systemctl start httpd

