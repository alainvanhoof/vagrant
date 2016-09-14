# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Icinga2
yum -y install https://packages.icinga.org/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm

yum -y install icinga2 postgresql-server postgresql icinga2-ido-pgsql httpd icingaweb2 icingacli nagios-plugins-all mailx

sed -i -e "s#;date.timezone =#date.timezone = UTC#" /etc/php.ini

postgresql-setup initdb

cat > /var/lib/pgsql/data/pg_hba.conf << EOF
local icinga2    icinga2                 trust
host  icinga2    icinga2    127.0.0.1/32 trust
host  icinga2    icinga2    ::1/128      trust
local icingaweb2 icingaweb2              trust
host  icingaweb2 icingaweb2 127.0.0.1/32 trust
host  icingaweb2 icingaweb2 ::1/128      trust
local all        all                     ident
host  all        all        127.0.0.1/32 ident
host  all        all        ::1/128      ident
EOF

systemctl enable postgresql
systemctl start postgresql

cd /tmp
sudo -u postgres psql -c "CREATE ROLE icinga2 WITH LOGIN PASSWORD 'icinga2'"
sudo -u postgres createdb -O icinga2 -E UTF8 icinga2
#sudo -u postgres createlang plpgsql icinga2
sudo -u postgres psql -U icinga2 -d icinga2 < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql

sudo -u postgres psql -c "CREATE ROLE icingaweb2 WITH LOGIN PASSWORD 'icingaweb2'";
sudo -u postgres createdb -O icingaweb2 -E UTF8 icingaweb2
#sudo -u postgres createlang plpgsql icingaweb2
sudo -u postgres psql -U icingaweb2 -d icingaweb2 < /usr/share/doc/icingaweb2/schema/pgsql.schema.sql

systemctl restart postgresql

export PASWD=`openssl passwd -1 "admin"`
sudo -u postgres psql icingaweb2 -c "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('admin', 1, '$PASWD')";

cat > /etc/icingaweb2/authentication.ini << EOF
[icingaweb2]
backend             = "db"
resource            = "icingaweb_db"
EOF

cat > /etc/icingaweb2/config.ini << EOF
[logging]
log                 = "file"
level               = "DEBUG"
file                = "/var/log/icingaweb2/icingaweb2.log"

[preferences]
store               = "db"
resource            = "icingaweb_db"
EOF

cat > /etc/icingaweb2/roles.ini << EOF
[admins]
users               = "admin"
permissions         = "*"
EOF

cat > /etc/icingaweb2/resources.ini << EOF
[icingaweb_db]
type                = "db"
db                  = "pgsql"
host                = "localhost"
port                = "5432"
dbname              = "icingaweb2"
username            = "icingaweb2"
password            = "icingaweb2"
prefix              = "icingaweb_"

[icinga_ido]
type                = "db"
db                  = "pgsql"
host                = "localhost"
port                = "5432"
dbname              = "icinga2"
username            = "icinga2"
EOF

mkdir /etc/icingaweb2/modules/monitoring

cat > /etc/icingaweb2/modules/monitoring/backends.ini << EOF
[icinga]
type                = "ido"
resource            = "icinga_ido"
EOF

cat > /etc/icingaweb2/modules/monitoring/config.ini << EOF
[security]
protected_customvars = "*pw*,*pass*,community"
EOF

#cat > /etc/icingaweb2/modules/monitoring/instances.ini << EOF
#[icinga]
#transport           = "local"
#path                = "/var/run/icinga2/cmd/icinga2.cmd"
#EOF

cat > /etc/icingaweb2/modules/monitoring/commandtransports.ini << EOF
[icinga2]
transport           = "local" 
path                = "/var/run/icinga2/cmd/icinga2.cmd" 
EOF

cat > /etc/icinga2/features-available/ido-pgsql.conf << EOF
library "db_ido_pgsql"

object IdoPgsqlConnection "ido-pgsql" {
  user = "icinga2"
  password = "icinga2"
  host = "localhost"
  database = "icinga2"
}
EOF

systemctl enable httpd
systemctl start httpd

systemctl enable icinga2
systemctl start icinga2

icingacli module enable monitoring
icinga2 feature enable command
usermod -a -G icingacmd apache
systemctl restart icinga2
