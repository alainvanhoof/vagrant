# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
#cat > /etc/yum.repos.d/NAME.repo << EOF
#EOF

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

# Install OTRS
yum -y install perl-DBD-Pg mod_perl perl-JSON-XS perl-YAML-LibYAML perl-Text-CSV_XS perl-Mail-IMAPClient perl-Crypt-Eksblowfish perl-Encode-HanExtra 
yum -y install http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.15-01.noarch.rpm

su postgres -c "createuser --no-adduser --no-createdb otrsuser"
su postgres -c "createdb --encoding=UNICODE --owner=otrsuser otrs"

systemctl enable httpd
systemctl start httpd
