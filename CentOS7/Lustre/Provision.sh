# EPEL and Update
# yum -y install epel-release
yum -y update

# Disable SELinux
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/sysconfig/selinux

# Create YUM Repo

cat > /etc/yum.repos.d/lustre.repo << EOF
[hpddLustreserver]
name=CentOS-\$releasever - Lustre
baseurl=http://build.hpdd.intel.com/job/lustre-master/arch=x86_64%2Cbuild_type=server%2Cdistro=el7%2Cib_stack=inkernel/lastSuccessfulBuild/artifact/artifacts/
gpgcheck=0
  
[e2fsprogs]
name=CentOS-\$releasever - Ldiskfs
baseurl=http://build.hpdd.intel.com/job/e2fsprogs-master/arch=x86_64%2Cdistro=el7/lastSuccessfulBuild/artifact/_topdir/RPMS/
gpgcheck=0
 
[hpddLustreclient]
name=CentOS-\$releasever - Lustre
baseurl=http://build.hpdd.intel.com/job/lustre-master/arch=x86_64%2Cbuild_type=client%2Cdistro=el7%2Cib_stack=inkernel/lastSuccessfulBuild/artifact/artifacts/
gpgcheck=0
EOF

sed -i -e "/lustre/d" /etc/hosts

cat >> /etc/hosts << EOF
# Lustre
10.0.0.201 lustre01 
10.0.0.202 lustre02
10.0.0.203 lustre03
EOF

cat >> /etc/modprobe.d/lustre.conf << EOF
options lnet networks=tcp(eth1)
EOF

yum -y install lustre
yum -y update
yum -y update
yum -y install lustre
reboot