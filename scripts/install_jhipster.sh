#!/bin/bash
#
# Perform a yarn install of jhipster.
#

which yarn
if [ $? -ne 0 ]; then
    echo "Error: Cannot install jhipster without yarn"
    exit 1
fi

echo "Install jhipster"
sudo yarn global add generator-jhipster
sudo yarn global add yo
