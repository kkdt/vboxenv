#!/bin/bash
#

__mirror=https://www-us.apache.org/dist/archiva/2.2.3/binaries/apache-archiva-2.2.3-bin.tar.gz
__currentdir=$(pwd)
wget ${__mirror}
if [ $? -ne 0 ]; then
    echo "Error: Cannot download Apache Archiva, please update the link ${__mirror}"
    exit 1
fi

tar zxvf apache-archiva*.tar.gz -C /opt
if [ $? -ne 0 ]; then
    echo "Error: Cannot install Apache Archiva"
    exit 2
fi

chown -R root:vagrant /opt/apache-archiva*
chmod -R g+rwx /opt/apache-archiva*

# clean up
rm -f ${__currentdir}/apache-archiva*
