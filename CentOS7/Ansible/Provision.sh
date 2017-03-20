export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")
if [ $IP == "10.0.0.50" ];  then 
yum -y install epel-release
yum -y install ansible git
fi
