#!/usr/bin/env bash

version=1.29.3
if [ -z "$1" ]; then
  echo "Using default version $version"
else
  version="$1"
fi

echo "Installing RVM"
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s -- --version $version

echo "Adding vagrant user to 'rvm' groupd"
usermod -G rvm vagrant

globalsource=/etc/profile.d/h01.sh
touch $globalsource
chmod 755 $globalsource
echo "Setting up global $globalsource for RVM"
echo "export JAVA_HOME=$JAVA_HOME" >> $globalsource
echo "export PATH=/usr/local/rvm/:$""PATH" >> $globalsource

# checking installation
source $globalsource
rvm --version
