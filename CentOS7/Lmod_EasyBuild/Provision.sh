# EPEL and Update
yum -y install epel-release
yum -y update

yum -y install Lmod python-pip git libibverbs-devel
yum -y groupinstall "Development Tools"
pip install easybuild

