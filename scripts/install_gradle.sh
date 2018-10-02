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

# Installs to /opt/gradle-{version} and create symbolic link at /opt/gradle.
# Argument
#   gradleversion (default to 3.5)
#

gradleversion=3.5
if [ -z "$1" ]; then
  echo "Using default version $gradleversion"
else
  gradleversion="$1"
fi

GRADLE_HOME=/opt/gradle
downloadLocation=$HOME/downloads/gradle
mkdir -p $downloadLocation

echo "Downloading Gradle $gradleversion"
wget -N https://services.gradle.org/distributions/gradle-${gradleversion}-all.zip \
--directory-prefix=$downloadLocation -nv

if [ $? -ne 0 ]; then
  echo "Error obtaining gradle version $gradleversion"
  exit 1
fi

echo "Extracting Gradle to /opt"
unzip $downloadLocation/gradle-${gradleversion}-all.zip -d /opt

echo "Creating symbolic link /opt/gradle"
ln -s /opt/gradle-${gradleversion} /opt/gradle

globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
echo "Setting up $globalsource for Gradle"
echo "export GRADLE_HOME=$GRADLE_HOME" >> $globalsource
echo "export PATH=$""GRADLE_HOME/bin:$""PATH" >> $globalsource

# check installation
source $globalsource
gradle -v
