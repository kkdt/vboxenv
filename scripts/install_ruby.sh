#!/usr/bin/env bash

source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh

version=2.5.0
if [ -z "$1" ]; then
   echo "Using default version $version"
else
   version="$1"
fi

echo "Installing Ruby"
rvm use --default --install $version
