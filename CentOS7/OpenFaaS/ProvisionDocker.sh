curl -fsSL https://get.docker.com/ | sh

sudo systemctl enable docker
sudo systemctl start docker

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")
if [ $IP == "10.0.0.201" ];  then 
 docker swarm init --advertise-addr 10.0.0.201
 yum -y install git
 git clone https://github.com/openfaas/faas && \
 cd faas && \
 git checkout 0.6.5 && \
 ./deploy_stack.sh
fi


