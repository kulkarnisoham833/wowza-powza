#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

touch /var/log/script.log

# backups
mkdir -p ~/Desktop/backups/
chmod 700 ~/Desktop/backups/

cp /etc/passwd ~/Desktop/backups
cp /etc/group ~/Desktop/backups

#unattended upgrades
touch auto-upgrades
cat "APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";" > auto-upgrades
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
cat "PASS_MAX_DAYS	15
PASS_MIN_DAYS	7
PASS_WARN_AGE	7" >> /etc/login.defs
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

#find filetypes
find . -name *.jpg
find . -name *.png
find . -name *.mp3
find . -name *.mp4
find . -name *.wav
find . -name *.mov
find . -name *.gif
find . -name *.bmp

#list manually installed packages
apt-mark showmanual
