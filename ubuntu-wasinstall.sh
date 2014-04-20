#!/bin/sh
# update & upgrade #
sudo apt-get -y -q update
sudo apt-get -y -q upgrade

# From site http://www.stoeps.de/websphere-application-server-8-0-0-5-on-ubuntu-12-04-64-bit/
# Relink /bin/sh
sudo dpkg-reconfigure -u dash

# use the standard Bash shell as /bin/sh
mv /bin/sh /bin/sh.ORIG
ln -s /bin/bash /bin/sh

# Install Firefox & SSH
sudo apt-get -y -q install firefox
sudo apt-get -y -q install openssh-server
sudo apt-get -y -q install mkpasswd

# Add 32 bit libraries for Install Manager
sudo apt-get -y -q install libxtst6
sudo apt-get -y -q install ia32-libs

sudo apt-get -y -q install subversion

# Uninstall AppArmor
sudo apt-get -y -q remove --purge apparmor*


cd /home/s28109/Downloads/

# Removes warning 'strings: '/lib/libc.so.6': No such file'
ln -s /lib64/x86_64-linux-gnu/libc.so.6 /lib64/libc.so.6

# Download Was community edition
wget http://192.168.227.1:8081/wasce_ibm60sdk_setup-3.0.0.4-x86_64linux.tar.bz2

tar -xvf /home/s28109/Downloads/wasce_ibm60sdk_setup-3.0.0.4-x86_64linux.tar.bz2

wget http://192.168.227.1:8081/Linux-Solaris-install.properties /home/s28109/Downloads/Linux-Solaris-install.properties

wget http://192.168.227.1:8081/wrt-3.0-6.1-linux-x86_64-sdk.bin /home/s28109/Downloads/wrt-3.0-6.1-linux-x86_64-sdk.bin

chmod +x /home/s28109/Downloads/wrt-3.0-6.1-linux-x86_64-sdk.bin

# Install Java (Silent install)
/home/s28109/Downloads/wrt-3.0-6.1-linux-x86_64-sdk.bin -i silent

export PATH=$PATH:/opt/ibm/javawrt3_64/bin

# Silent Install WAS Community edition
/home/s28109/Downloads/wasce_setup-3.0.0.4-unix.bin -i silent -f /home/s28109/Downloads/Linux-Solaris-install.properties

# Add as service(s)

# cd /opt/IBM/WebSphere/AppServer/bin

./wasservice.sh 
  -add Dmgr 
  -serverName dmgr 
  -profilePath /opt/IBM/WebSphere/AppServer/profiles/Dmgr01
  -wasHome /opt/IBM/WebSphere/AppServer 
  -stopArgs "-username system -password manager"

./wasservice.sh 
  -add nodeagent 
  -serverName nodeagent 
  -profilePath /opt/IBM/WebSphere/AppServer/profiles/AppSrv01 
  -wasHome /opt/IBM/WebSphere/AppServer 
  -stopArgs "-username  system -password manager"

