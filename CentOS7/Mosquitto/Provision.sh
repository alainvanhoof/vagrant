# EPEL and Update
#yum -y install epel-release 
#yum -y update

cat > /etc/yum.repos.d/mosquitto.repo << EOF
[home_oojah_mqtt]
name=mqtt (CentOS_CentOS-7)
type=rpm-md
baseurl=http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/
gpgcheck=0
enabled=1
EOF

yum -y install mosquitto

systemctl enable mosquitto
systemctl start mosquitto
