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




#yum install -y docker kubelet kubeadm kubectl kubernetes-cni
#systemctl enable kubelet
#systemctl start kubelet
