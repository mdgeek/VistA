#!/bin/bash
#
# Fix line endings
#
if $isVagrant; then
   dos2unix ./etc/init.d/cwf > /dev/null
   dos2unix ./etc/xinetd.d/rgbroker-service > /dev/null
   dos2unix ./www/*.inp > /dev/null
fi
#
#  NETSERV broker configuration
#
sudo cp -r ./etc/xinetd.d/rgbroker-service /home/osehra/etc/xinetd.d/rgbroker-service
sudo ln -s /home/osehra/etc/xinetd.d/rgbroker-service /etc/xinetd.d/rgbroker-service
sudo cp ./etc/xinetd.d/rgbroker.sh /home/osehra/bin
sudo chown osehra /home/osehra/bin/rgbroker.sh
sudo chgrp osehra /home/osehra/bin/rgbroker.sh
sudo iptables -A INPUT -p tcp --dport 9300 -j ACCEPT

#
#  NETSERV web server configuration
#
sudo cp -r ./etc/xinetd.d/rghttp-service /home/osehra/etc/xinetd.d/rghttp-service
sudo ln -s /home/osehra/etc/xinetd.d/rghttp-service /etc/xinetd.d/rghttp-service
sudo cp ./etc/xinetd.d/rghttp.sh /home/osehra/bin
sudo chown osehra /home/osehra/bin/rghttp.sh
sudo chgrp osehra /home/osehra/bin/rghttp.sh
sudo iptables -A INPUT -p tcp --dport 9080 -j ACCEPT

#
# Web app installation
#
sudo cp ./www/cwf-vista.war /var/lib/tomcat7/webapps/cwf-vista.war

#
# Install CWF KIDS builds
#
python ../../DefaultKIDSBuildInstaller.py ./kid/cwf-vista-1.0.kid -S 2
python ../../DefaultKIDSBuildInstaller.py ./kid/rged-3.0.kid -S 2

#
# Install supplemental routines
#
python ../../VistARoutineImport.py ./rou/cwf.rsa -S 2 -o /home/osehra/r

#
# Setup user(s)
#
gtm -run AUTO^RGZINIT

#
# Configure stunnel
sudo cp ./etc/stunnel/stunnel.conf /etc/stunnel
sudo sed s/ENABLED=0/ENABLED=1/ /etc/default/stunnel4 > /tmp/stunnel4.tmp
sudo cat /tmp/stunnel4.tmp > /etc/default/stunnel4
sudo sed s/myhost/$HOSTNAME/ ./etc/stunnel/stunnel.inp > /tmp/stunnel.tmp
sudo openssl genrsa -out /tmp/key.pem 2048
sudo openssl req -new -x509 -key /tmp/key.pem -out /tmp/cert.pem -days 1095 < /tmp/stunnel.tmp
sudo cat /tmp/key.pem /tmp/cert.pem >> /etc/stunnel/stunnel.pem
sudo iptables -A INPUT -p tcp --dport 9081 -j ACCEPT
sudo service xinetd restart
sudo /etc/init.d/stunnel4 restart
