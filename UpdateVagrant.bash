#!/bin/bash
VA_VERSION=2.1.2
curl -O https://releases.hashicorp.com/vagrant/${VA_VERSION}/vagrant_${VA_VERSION}_x86_64.dmg
hdiutil attach ./vagrant_${VA_VERSION}_x86_64.dmg
sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /Volumes/Macintosh\ HD
hdiutil detach /Volumes/Vagrant/
rm -f ./vagrant_${VA_VERSION}_x86_64.dmg
