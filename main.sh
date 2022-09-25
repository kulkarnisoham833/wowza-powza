if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#!/bin/bash


#unattended upgrades
dpkg-reconfigure -plow unattended-upgrades

#bash upgrade
apt install --only-upgrade bash
#kernel upgrade
apt-get dist-upgrade
#remove unnecessary dependencies
apt autoremove
#remove unsupported pkgs
apt autoclean

#user management ---- https://askubuntu.com/questions/1291961/how-to-take-input-from-user-until-a-specific-character-appears
echo "Starting user management"

for i in $(cat /etc/passwd | awk -F: '{print $7}');
do
    echo sheesh
done