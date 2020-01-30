#!/bin/bash
#
# Copyright 2017 kkdt
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Base virtual machine initialization script.
# - hostname setup
# - install base packages from yum
#

#echo "Changing hostname to $virtualname"
#sudo hostnamectl set-hostname $virtualname.local
#sudo hostnamectl status
#sudo /etc/init.d/network restart

echo "Updating box image"
sudo yum -y update

echo "Installing Extra Package for Enterprise Linux (EPEL)"
sudo yum -y install epel-release

echo "Installing system utilities"
sudo yum -y install pciutils
sudo yum -y install policycoreutils
sudo yum -y install policycoreutils-python
sudo yum -y install wget
sudo yum -y install unzip
sudo yum -y install mlocate
sudo yum -y install dkms
sudo yum -y install fontconfig
sudo yum -y install gcc-c++

yum list installed | grep "mariadb-libs" 2>&1
if [ $? -eq 0 ]; then
    echo "Removing mariadb-lib"
    yum -y remove mariadb-libs.x86_64
fi

#echo "Installing VirtualBox repo"
#cd /etc/yum.repos.d
#wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
#cd -

echo "Setting up /opt/bin"
mkdir -p /opt/bin
chmod 755 /opt/bin

globalsource=/etc/profile.d/$(hostname -s).sh
if [ ! -f "${globalsource}" ]; then
    echo "Setting up $globalsource defaults"
    touch $globalsource
    chmod 755 $globalsource
    echo "export VAGRANTENV=1" >> $globalsource
    echo "export PATH=/usr/local/bin:/opt/bin:$""PATH" >> $globalsource
fi
