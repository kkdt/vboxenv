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

# Installs to /opt/aws
# Argument
#   AWS_ACCESS_KEY_ID (mandatory)
#   AWS_SECRET_ACCESS_KEY (mandatory)
#   AWS_REGION (mandatory)
#

downloadLocation=$HOME/downloads/aws
mkdir -p $downloadLocation
awszip="https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"

if [ $# -ne 3 ]; then
  echo "Invalid number of arguments"
  exit 1
fi

echo "Downloading AWS CLI"
wget -N $awszip --directory-prefix=$downloadLocation -nv

echo "Extracting AWS CLI $filename to /opt"
filename=$(ls $downloadLocation | grep zip)
unzip $downloadLocation/$filename -d $downloadLocation

echo "Installing AWS CLI to /usr/local/aws and /opt/bin/aws"
$downloadLocation/awscli-bundle/install -i /usr/local/aws -b /opt/bin/aws

# testing out install
globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
chmod 755 $globalsource
source $globalsource

# installing aws credentials

echo "export AWS_ACCESS_KEY_ID=${1}" >> $globalsource
echo "export AWS_SECRET_ACCESS_KEY=${2}" >> $globalsource
echo "export AWS_DEFAULT_REGION=${3}" >> $globalsource
echo "export AWS_REGION=${3}" >> $globalsource

aws --version
