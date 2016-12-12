# EPEL and Update
yum -y install epel-release
#yum -y update

# Disable SELinux
#setenforce 0
#sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

#cat >> /etc/yum.repos.d/redis.repo << EOF
#EOF

yum -y install redis

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")
sed -i -e "s/^bind.*/bind ${IP}/" /etc/redis.conf

if [ $IP != "10.0.0.151" ]; then echo "slaveof 10.0.0.151 6379" >> /etc/redis.conf; fi

#cat >  redis_repl.te << EOF
#module redis_repl 1.0;
#require {
#        type redis_port_t;
#        type redis_t;
#        class tcp_socket name_connect;
#}
#allow redis_t redis_port_t:tcp_socket name_connect;
#EOF
#checkmodule -m -M -o redis_repl.mod redis_repl.te 
#semodule_package --outfile redis_repl.pp --module redis_repl.mod 
#semodule -i redis_repl.pp

systemctl enable redis
systemctl start redis
