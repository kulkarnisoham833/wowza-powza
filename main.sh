#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

touch /var/log/script.log

#unattended upgrades
dpkg-reconfigure -plow unattended-upgrades
cp auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

#bash upgrade
apt install --only-upgrade bash
#kernel upgrade
apt-get dist-upgrade
#remove unnecessary dependencies
apt autoremove
#remove unsupported pkgs
apt autoclean


# adduser.conf TODO

#deluser.conf TODO

passwd -l root

#password policies
cp login.defs /etc/login.defs
apt install libpam-cracklib -y
cp common-password /etc/pam.d/common-password
cp common-auth /etc/pam.d/common-auth

#file perms
chmod 640 /etc/*

#crontabs
echo "CRONTABS HAVE BEEN FOUND IN:"
cat /etc/cron.d/* | grep -l "\* \* \* \* \*"
cat /etc/crontab | grep -l "\* \* \* \* \*"
cat /var/spool/cron/crontabs/* | grep "\* \* \* \* \*"
echo "END CRONTAB LIST"

#networking
ufw enable
wget https://klaver.it/linux/sysctl.conf -P /etc/sysctl.conf
sysctl -ep
cp resolv.conf /etc/resolv.conf
cp host.conf /etc/host.conf
