#!/bin/bash

if [ "$EUID" -ne 0 ];then
    echo "Please run this script as root user"
    exit 1
fi

apt install software-properties-gtk -y

cp /etc/apt/sources.list sources.list.bak
dpkg-reconfigure -plow unattended-upgrades
