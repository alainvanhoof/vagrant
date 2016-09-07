# EPEL and Update
yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/selinux/config

yum -y install graphite-web graphite-web-selinux mariadb mariadb-server MySQL-python python-carbon python-whisper

systemctl start mariadb
systemctl enable mariadb

mysql -e "CREATE DATABASE graphite;"
mysql -e "GRANT ALL PRIVILEGES ON graphite.* TO 'graphite'@'localhost' IDENTIFIED BY 'graphitePW01Vxzsigavms';"
mysql -e 'FLUSH PRIVILEGES;'

cat >> /etc/graphite-web/local_settings.py <<EOF
SECRET_KEY = 'AfwaesgjhsgFDRAG45'
DATABASES = {
 'default': {
 'NAME': 'graphite',
 'ENGINE': 'django.db.backends.mysql',
 'USER': 'graphite',
 'PASSWORD': 'graphitePW01Vxzsigavms',
 }
}
EOF

/usr/lib/python2*/site-packages/graphite/manage.py syncdb --noinput

sed -i -e "s/Require local/Require all granted/" /etc/httpd/conf.d/graphite-web.conf

systemctl start carbon-cache
systemctl enable carbon-cache
systemctl start httpd
systemctl enable httpd
