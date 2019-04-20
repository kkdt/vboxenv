#!/bin/bash
#
# Copyright (C) 2019 thinh ho
# This file is part of 'vagrant-sandbox' which is released under the MIT license.
# See LICENSE at the project root directory.
#

function install_desktop() {
    yum -y groupinstall "X Window System"

    case "${1}" in
    "xfce")
        yum -y groupinstall xfce
        ;;
    "gnome")
        yum -y install gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts gdm
        systemctl enable gdm
        yum -y groupinstall fonts
        ;;
    *)
        echo "Unknown desktop: $1"
    esac

    systemctl isolate graphical.target
    systemctl set-default graphical.target

    sudo yum -y install firefox
}

if [ ! -z "${1}" ]; then
    install_desktop "${1}"
    exit $?
fi

# systemctl get-default
#    multi-user.target (non graphical)
#    graphical.target (graphical)
# systemctl set-default graphical.target
# yum install gdm|lightdm
# systemctl enable gdm|lightdm
