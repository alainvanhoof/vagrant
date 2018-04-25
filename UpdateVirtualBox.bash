#!/bin/bash
VB_VERSION=5.2.10
VB_RELEASE=122088
VB_DMG=VirtualBox-${VB_VERSION}-${VB_RELEASE}-OSX.dmg
curl -O http://download.virtualbox.org/virtualbox/${VB_VERSION}/${VB_DMG}
hdiutil attach ./${VB_DMG}
sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /Volumes/Macintosh\ HD
hdiutil detach /Volumes/VirtualBox/
rm -f ./${VB_DMG}
