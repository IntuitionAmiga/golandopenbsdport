#!/bin/ksh
#Quickly hacked together script to install GoLand IDE on OpenBSD

#Download Goland archive
echo Downloading Goland 2021.2.4
ftp -ogoland.tgz https://download.jetbrains.com/go/goland-2021.2.4.tar.gz

#Extract goland archive
echo Extracting archive, please wait...
tar xvfz goland.tgz>/dev/null

#Rename goland20xx.xx folder to goland
rm -fr goland
mv GoLand-2021.2.4 goland

#Copy go.sh and goland.sh into goland/bin folder
echo Applying patches
chmod +x patches/go.sh
chmod +x patches/goland.sh
cp patches/go.sh goland/bin
cp patches/goland.sh goland/bin

#Move goland folder to /usr/local
echo Delete old installation if any
doas rm -fr /usr/local/goland
echo Installing to /usr/local/goland/
doas mv goland /usr/local/

#Copy .desktop file to ~/.local/share/applications/
echo Creating desktop GUI launcher item
cp patches/jetbrains-goland.desktop ~/.local/share/applications

#Install JDK
echo Installing JDK16
doas pkg_add jdk-16.0.2.7.1v0

echo Installation of GoLand complete
echo Check your desktop menu for launcher or run /usr/local/goland/go.sh
