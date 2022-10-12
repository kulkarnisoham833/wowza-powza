#! /bin/bash

# https://github.com/k4yt3x/sshd_config
chmod 640 /etc/ssh
chmod 700 ~/.ssh
chmod 644 ~/.ssh/rsa.pub
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/authorized_keys

cat betterssh > /etc/ssh/sshd_config
echo "SSH config file updated"
systemctl restart ssh
ufw allow 1234

ssh-keygen

find -name .rhosts -print | xargs -i -t rm{} 

