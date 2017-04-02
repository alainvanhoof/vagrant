sudo sed -i -e "s@#http://dl-cdn.alpinelinux.org/alpine/v@http://dl-cdn.alpinelinux.org/alpine/v@" /etc/apk/repositories
sudo apk update 
sudo apk upgrade
sudo apk add haveged
sudo apk add openssl
sudo apk add bash
sudo apk add python
sudo apk add iproute2
mkdir /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
mv vagrant.pub authorized_keys 
chmod -R go-rwsx /home/vagrant/.ssh
sudo sed -i -e "s/^ttyS0/#ttyS0/" /etc/inittab
