#!/bin/bash
VB_VERSION=5.1.22
VB_DMG=VirtualBox-5.1.22-115126-OSX.dmg
curl -O http://download.virtualbox.org/virtualbox/${VB_VERSION}/${VB_DMG}
hdiutil attach ./${VB_DMG}
sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /Volumes/Macintosh\ HD
hdiutil detach /Volumes/VirtualBox/
rm -f ./${VB_DMG}