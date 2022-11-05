#!/bin/bash
# this only has configuration file stuff for now

# Pure-FTPD
echo "-----SHOULD I CONFIGURE PURE-FTP?-----"
read me
if [[ $me == "y" ]]; then
  apt install pure-ftpd
  echo "changing pure-ftpd configurations"
  cd /etc/pure-ftpd/conf
  echo yes > ChrootEveryone
  echo yes > DontResolve
  echo yes > NoChmod
  echo yes > ProhibitDotFilesWrite
  echo yes > CustomerProof
  echo '20000 20099' > PassivePortRange
  echo 2 > TLS
  mkdir /etc/ssl/private
  openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
  chmod 600 /etc/ssl/private/pure-ftpd.pem

  echo "Should this ftp server be anonymous? (usually not) y/n"
  read yn
  if [ $yn = "n" ]; then
  echo yes > NoAnonymous
  echo no > AnonymousOnly
  fi
  if [ $yn = "y" ]; then
  echo no > NoAnonymous
  echo yes > AnonymousOnly
  fi
  echo no > UnixAuthentication
  echo yes > PamAuthentication
  echo "restarting the service"
  systemctl restart pure-ftpd
  cd
 
  
  echo no > BrokenClientsCompatibility 
  echo 50 > MaxClientsNumber
  echo 2 >  MaxClientsPerIP
  echo yes > VerboseLog
  echo no > DisplayDotFiles
  echo yes > ProhibitDotFilesWrite

  echo yes > NoChmod
  echo no > DontResolve
  echo 15 > MaxIdleTime
  echo yes > LimitRecursion
  echo yes > AntiWarez
  echo no > AnonymousCanCreateDirs
  echo 1 > MaxLoad
  echo no > AllowUserFXP
  echo no > AllowAnonymousFXP
  echo yes > AnonymousCantUpload
  
  else
    if [ dpkg -l | grep pure-ftpd ]; then
    apt autoremove -y --purge pure-ftpd
    echo "pure-ftpd deleted."
    fi
fi

#ProFTPD
echo "-----SHOULD I CONFIGURE PRO-FTP?-----"
read me
if [[ $me == "y"]]; then
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
echo "-----SHOULD I CONFIGURE VSFTPD?-----"
read me
if [[ $me == "y"]]; then
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
