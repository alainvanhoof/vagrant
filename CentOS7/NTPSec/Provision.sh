# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
#cat > /etc/yum.repos.d/NAME.repo << EOF
#EOF

# Install
#yum -y install NAME
#systemctl enable NAME
#systemctl start NAME

yum -y groupinstall 'Development Tools' libevent-devel libcap-devel git

cd /root
git clone https://github.com/ntpsec/ntpsec
cd ntpsec
./waf --prefix=/usr configure
./waf build
./waf install

mkdir -p /var/lib/ntp
mkdir -p /var/log/ntpstats

cat > /etc/ntp.conf << EOF
driftfile /var/lib/ntp/ntp.drift
statsdir /var/log/ntpstats/
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
logfile /var/log/ntpd.log
logconfig =syncall +clockall +peerall +sysall
restrict default kod limited nomodify nopeer noquery
restrict -6 default kod limited nomodify nopeer noquery
restrict 127.0.0.1
restrict -6 ::1
server chime1.surfnet.nl
server chime2.surfnet.nl
EOF

ntpd

# ntpviz

yum -y install gnuplot liberation* httpd
cat >> /root/crontab.ntpviz << EOF
*/5 * * * * ntpviz -o /var/www/html/ > /dev/null 2>&1
EOF
crontab /root/crontab.ntpviz

systemctl enable httpd
systemctl start httpd

