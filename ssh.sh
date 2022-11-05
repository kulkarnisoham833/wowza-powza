#! /bin/bash

# https://github.com/k4yt3x/sshd_config

echo "doing ssh..."
read me
apt install openssh-server
cp /etc/ssh/sshd_config sshd_config.bak
echo -e "\n"
echo -e "\n"
echo -e "\n"
echo "----BEGIN /ETC/SSH/SSHD_CONFIG----"
cat /etc/ssh/sshd_config
echo "----END /ETC/SSH/SSHD_CONFIG----"
echo -e "\n"
echo -e "\n"
echo -e "\n"
read me
cp betterssh /etc/ssh/sshd_config
echo "SSH config file updated"

chmod 640 /etc/ssh
chmod 700 /.ssh
chmod 644 /.ssh/rsa.pub
chmod 600 /.ssh/id_rsa
chmod 600 /.ssh/authorized_keys

ufw allow ssh
systemctl restart ssh


ssh-keygen

find -name .rhosts -print | xargs -i -t rm{} 

