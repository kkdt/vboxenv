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

virtualname=centos7b
if [ -z "$1" ]; then
  echo "Using default hostname $virtualname"
else
  virtualname="$1"
fi

echo "Changing hostname to $virtualname"
sudo hostnamectl set-hostname $virtualname.local
sudo hostnamectl status
sudo /etc/init.d/network restart

#echo "Updating box image"
#sudo yum -y install

echo "Installing Extra Package for Enterprise Linux (EPEL)"
sudo yum -y install epel-release

echo "Installing system utilities"
sudo yum -y install pciutils
sudo yum -y install policycoreutils policycoreutils-python
sudo yum -y install wget unzip
sudo yum -y install mlocate

echo "Setting up /opt/bin"
mkdir -p /opt/bin
chmod 755 /opt/bin

globalsource=/etc/profile.d/h01.sh
echo "Setting up $globalsource defaults"
touch $globalsource
chmod 755 $globalsource
echo "export PATH=/usr/local/bin:/opt/bin:$""PATH" >> $globalsource
