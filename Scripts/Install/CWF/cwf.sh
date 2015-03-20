#!/bin/bash
#
# Fix line endings
#
if $isVagrant; then
   dos2unix ./etc/init.d/cwf > /dev/null
   dos2unix ./etc/xinetd.d/osehra-vista-ciabroker > /dev/null
   dos2unix ./www/*.inp > /dev/null
fi
#
#  CIA broker configuration
#
sudo cp -r ./etc/xinetd.d/osehra-vista-ciabroker /home/osehra/etc/xinetd.d/osehra-vista-ciabroker
sudo ln -s /home/osehra/etc/xinetd.d/osehra-vista-ciabroker /etc/xinetd.d/osehra-vista-ciabroker
sudo cp ./etc/xinetd.d/ciabroker.sh /home/osehra/bin
sudo chown osehra /home/osehra/bin/ciabroker.sh
sudo chgrp osehra /home/osehra/bin/ciabroker.sh
sudo iptables -A INPUT -p tcp --dport 9300 -j ACCEPT
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
# Install M Web Server (with mods)
#
#sudo curl -L -s https://raw.github.com/shabiel/M-Web-Server/0.1.1/dist/WWWINIT.RSA > ./rou/WWWINIT.RSA
python ../../VistARoutineImport.py ./rou/WWWINIT.RSA -S 2 -o /home/osehra/r
gtm -run ^WWWINIT < ./www/wwwinit.inp
gtm -run WWWINIT^RGZINIT

#
# Install/Start CareWeb Services
sudo cp -r ./etc/init.d/cwf /home/osehra/etc/init.d/cwf
sudo ln -s /home/osehra/etc/init.d/cwf /etc/init.d/cwf
sudo update-rc.d cwf defaults 99
sudo service cwf start

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
