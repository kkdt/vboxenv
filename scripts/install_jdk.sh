#!/bin/bash

globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
chmod 755 $globalsource

if [ -f "${1}" ]; then
    echo "Install jdk: ${1}"
    rpm -ivh "${1}"
    echo "JAVA_HOME=/usr/java/latest" >> $globalsource
    echo "Removing ${1}"
    rm -f ${1}
else
    echo "JDK not provided"
fi
