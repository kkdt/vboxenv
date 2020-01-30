#!/bin/bash
#
# Copyright 2020 kkdt
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

# ASSUMES NODE IS ALREADY INSTALLED

initial_scope="prototypes"
if [ -z "$1" ]; then
  echo "Using default scope ${initial_scope}"
else
  initial_scope="$1"
fi

echo "Installing Bit server"
npm install bit-bin --global

echo "Turning on Bit analytics reporting"
sudo -i -u vagrant bit config set analytics_reporting false
sudo -i -u vagrant bit config set error_reporting false

echo "Initializating Bit directories"
mkdir -p /opt/bit
chown vagrant:vagrant /opt/bit
chmod 755 /opt/bit

sudo -i -u vagrant mkdir -p /opt/bit/${initial_scope}
cd /opt/bit/${initial_scope}
sudo -i -u vagrant bit init --bare
