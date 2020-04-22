#!/bin/bash
#
# Node Release: https://nodejs.org/en/download/

set -e

installLocation="/opt/nodejs"

if [ -z "${1}" -o ! -f "${1}" ]; then
  echo "Please provide a valid nodejs binary file"
  exit 1
fi

if [ ! -z "${2}" ]; then
  installLocation="${2}"
fi

filename=$(basename -s .tar "$(basename -s .xz ${1})")
distro=$(echo ${filename} | cut -d'-' -f 3)-$(echo ${filename} | cut -d'-' -f 4)
version=$(echo ${filename} | cut -d'-' -f 2)
echo "Installing nodejs $version-${distro} to ${installLocation}"
mkdir -p ${installLocation}
tar -xJvf ${1} -C ${installLocation}

globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
echo "Setting up $globalsource"
echo "# nodejs" >> $globalsource
echo "export PATH=${installLocation}/node-${version}-${distro}/bin:$""PATH" >> $globalsource
chmod 755 $globalsource
