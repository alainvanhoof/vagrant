apt-get -y install git screen

cd /root

wget --quiet https://dl.gogs.io/gogs_v0.9.113_linux_amd64.tar.gz

tar -zxvf gogs_v0.9.113_linux_amd64.tar.gz

screen /root/gogs web 
