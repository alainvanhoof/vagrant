# EPEL and Update
yum -y install epel-release

# Katello  (foreman puppet and more)
yum -y localinstall http://fedorapeople.org/groups/katello/releases/yum/3.2/katello/el7/x86_64/katello-repos-latest.rpm
yum -y localinstall http://yum.theforeman.org/releases/1.13/el7/x86_64/foreman-release.rpm
yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y install foreman-release-scl
yum -y update
foreman-installer --scenario katello 
