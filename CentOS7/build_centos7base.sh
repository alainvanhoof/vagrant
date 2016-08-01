vagrant plugin install vagrant-vbguest
mkdir centos7base
cd centos7base
vagrant init

cat > Vagrantfile << EOF
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision "shell", inline: "sudo yum -y update"
end
EOF

vagrant up
vagrant halt
vagrant up
vagrant package
vagrant box add centos7base ./package.box
vagrant destroy -f
cd ..
rm -rf centos7base
vagrant plugin uninstall vagrant-vbguest
