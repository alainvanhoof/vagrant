# EPEL and Update
#yum -y install epel-release
#yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF

yum -y install docker kubectl git
systemctl enable docker 
systemctl start docker

export IP=$(cat /etc/sysconfig/network-scripts/ifcfg-eth1 | grep IPADDR | sed -e "s/IPADDR=//")

git clone https://github.com/kubernetes/kube-deploy
cd kube-deploy/docker-multinode
export IP_ADDRESS=${IP}
export MASTER_IP=10.0.0.71
export USE_CNI=true
./worker.sh

