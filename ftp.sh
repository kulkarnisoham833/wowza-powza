#!/bin/bash
# this only has configuration file stuff for now

# Pure-FTPD
if dpkg -l | grep "pure-ftpd"; 
then
  echo "update pure-ftpd configurations? answering no will delete pure-ftpd."
  read yn
  if [ "$yn" = "y" ]; 
  then
    echo "changing pure-ftpd configurations"
    cd /etc/pure-ftpd
    echo yes > ./conf/ChrootEveryone
    echo yes > ./conf/DontResolve
    echo yes > ./conf/NoChmod
    echo yes > ./conf/ProhibitDotFilesWrite
    echo yes > ./conf/CustomerProof
    echo '20000 20099' > ./conf/PassivePortRange
    echo "restarting the service"
    systemctl restart pure-ftpd
    cd
  else
    apt autoremove -y --purge pure-ftpd
    echo "pure-ftpd deleted."
  fi
fi

#ProFTPD
if dpkg -l | grep "pro-ftpd";
then
  echo "update proftpd configurations? answering no will delete proftpd."
  read yn
  if [ "$yn" = "y" ]; 
  then
    echo "changing proftpd configurations"
    cp proftpd /etc/proftpd/proftpd.conf
    echo "restarting the service"
    systemctl restart proftpd
  else
    apt autoremove -y --purge proftpd
    echo "proftpd deleted."
  fi
fi

#VSFTPD
if dpkg -l | grep "vsftpd";
then
  echo "update vsftpd configurations? answering no will delete vsftpd."
  read yn
  if [ "$yn" = "y" ]; 
  then
    echo "changing vsftpd configurations"
    cp vsftpd /etc/vsftpd.conf
    echo "restarting the service"
    systemctl restart vsftpd
  else
    apt autoremove -y --purge vsftpd
    echo "vsftpd deleted."
  fi
fi
