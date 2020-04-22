#!/bin/bash
#
# Latest Release: https://yarnpkg.com/latest.tar.gz
# Yarn Releases: https://github.com/yarnpkg/yarn/releases

set -e

installLocation="/opt/yarn"
file="$(pwd)/latest.tar.gz"

if [ -z "${1}" -o ! -f "${1}" ]; then
  echo "Downloading latest yarn binary to $(pwd)"
  wget https://yarnpkg.com/latest.tar.gz
  if [ $? -ne 0 ]; then
    echo "Download failed, please manually download at https://yarnpkg.com/latest.tar.gz and re-run this script"
    exit 1
  fi
else
  file="${1}"
fi

if [ ! -z "${2}" ]; then
  installLocation="${2}"
fi

echo "Installing yarn ${file} to ${installLocation}"
mkdir -p ${installLocation}
tar xvf ${file} -C ${installLocation}
version=$(ls ${installLocation} | grep -i yarn | cut -d'-' -f 2)

globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
echo "Setting up $globalsource"
echo "# yarn" >> $globalsource
echo "export PATH=${installLocation}/yarn-${version}/bin:$""PATH" >> $globalsource
chmod 755 $globalsource
