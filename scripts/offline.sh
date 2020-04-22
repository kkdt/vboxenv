#!/bin/bash

set -e

echo "Disabling network"
route -n
chkconfig network off
chkconfig --list
route del default