#!/bin/bash
#
#  CIA broker configuration
#
sudo cp -r /vagrant/CWF/etc/xinetd.d/osehra-vista-ciabroker /home/osehra/etc/xinetd.d/osehra-vista-ciabroker
sudo ln -s /home/osehra/etc/xinetd.d/osehra-vista-ciabroker /etc/xinetd.d/osehra-vista-ciabroker
sudo cp ./etc/xinetd.d/ciabroker.sh /home/osehra/bin
sudo chown osehra /home/osehra/bin/ciabroker.sh
sudo chgrp osehra /home/osehra/bin/ciabroker.sh
sudo iptables -A INPUT -p tcp --dport 9300 -j ACCEPT
sudo service xinetd restart

#
# Web app installation
#
sudo cp /vagrant/CWF/www/cwf-vista.war /var/lib/tomcat7/webapps/cwf-vista.war

#
# Install CWF KIDS builds
#
python /scripts/Scripts/DefaultKIDSBuildInstaller.py ./kid/cwf-vista-1.0.kid -S 2
python /scripts/Scripts/DefaultKIDSBuildInstaller.py ./kid/rged-3.0.kid -S 2

#
# Setup user(s)
#
python /scripts/Scripts/VistARoutineImport.py ./rou/RGZINIT.RSA -S 2 -o /home/osehra/r
gtm -run ^RGZINIT "MANAGER,SYSTEM"
gtm -run ^RGZINIT "USER,ONE"
gtm -run ^RGZINIT "USER,TWO"
gtm -run ^RGZINIT "USER,THREE"

#
# Install M Web Server (with mods)
#
sudo curl -L https://raw.github.com/shabiel/M-Web-Server/0.1.1/dist/WWWINIT.RSA > ./rou/WWWINIT.RSA
python /scripts/Scripts/VistARoutineImport.py ./rou/WWWINIT.RSA -S 2 -o /home/osehra/r
gtm -run ^WWWINIT < ./www/wwwinit.inp
gtm -run WWWINIT^RGZINIT
python /scripts/Scripts/VistARoutineImport.py ./rou/VPRJRSP.RSA -S 2 -o /home/osehra/r

#
# Install/Start CareWeb Services
sudo cp -r /vagrant/CWF/etc/init.d/cwf /home/osehra/etc/init.d/cwf
sudo ln -s /home/osehra/etc/init.d/cwf /etc/init.d/cwf
sudo update-rc.d cwf defaults 99
sudo service cwf start

