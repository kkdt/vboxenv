#!/bin/bash
# https://docs.docker.com/engine/install/rhel/

set -e

if [ "${1}" == "" ]; then
  echo "ERROR: Missing non-root user for running docker"
  exit 1
fi

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -G docker ${1}