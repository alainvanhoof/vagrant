# EPEL and Update
yum -y install epel-release
#yum -y update

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

# Install Drupal
yum -y install drupal7 drush php-pgsql

sed -i -e "s/Require local/Require all granted/" /etc/httpd/conf.d/drupal7.conf

su postgres -c "createuser --no-adduser --no-createdb drupaluser"
su postgres -c "createdb --encoding=UNICODE --owner=drupaluser drupal7"

cd /usr/share/drupal7
drush site-install standard --account-name=admin --account-pass=admin --db-url='pgsql://drupaluser@localhost/drupal7' --site-name=Drupal7-Site --no-clean-url -y

systemctl enable httpd
systemctl start httpd
