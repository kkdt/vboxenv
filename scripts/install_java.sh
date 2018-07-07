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

# Download JDK version from Oracle's website.
# Install Java to /opt/jdk{version} and symbolic link at /opt/java.
#
# Argument
#   jdkfile The http location of the target jdk tarball.
#
# Need to go the JDK download site to get the link and pass as parameter, or
# the default file will be used.
# http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz
#

# Steps to update java
# 1. Go to the JDK download page
# 2. Accept the lincense radio button
# 3. Copy the link to the java tar.gz file
# 4. Pass the link as the first argument or just update the 'jdkfile' variable below

# below works best
# wget --header "Cookie: oraclelicense=accept-securebackup-cookie" [link from download page]
# http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz

jdkfile="http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz"
if [ -z "$1" ]; then
  echo "Using default file $jdkfile"
else
  jdkfile="$1"
fi

downloadLocation=$HOME/downloads/jdk
mkdir -p $downloadLocation
JAVA_HOME=/opt/java

echo "Downloading $jdkfile..."
wget --no-cookies --header \
"Cookie: oraclelicense=accept-securebackup-cookie" \
--directory-prefix=$downloadLocation "$jdkfile" -nv

filename=$(ls $downloadLocation | grep jdk)
echo "Extracting JDK ($filename) to /opt"
tar -xzf $downloadLocation/$filename -C /opt

version=$(ls /opt | grep jdk)
echo "Creating symlink /opt/$version -> $JAVA_HOME"
ln -s /opt/$version $JAVA_HOME

globalsource=/etc/profile.d/h01.sh
touch $globalsource
chmod 755 $globalsource
echo "Setting up global $globalsource for Java"
echo "export JAVA_HOME=$JAVA_HOME" >> $globalsource
echo "export PATH=$""JAVA_HOME/bin:$""PATH" >> $globalsource

# check installation
source $globalsource
java -version
