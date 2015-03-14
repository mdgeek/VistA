#!/bin/bash
#
# Fix line endings
#
dos2unix ./etc/init.d/cwf > /dev/null
dos2unix ./etc/xinetd.d/osehra-vista-ciabroker > /dev/null
dos2unix ./kid/*.kid > /dev/null
dos2unix ./rou/*.rsa > /dev/null
dos2unix ./www/*.xml > /dev/null
dos2unix ./www/*.inp > /dev/null
#
#  CIA broker configuration
#
sudo cp -r ./etc/xinetd.d/osehra-vista-ciabroker /home/osehra/etc/xinetd.d/osehra-vista-ciabroker
sudo ln -s /home/osehra/etc/xinetd.d/osehra-vista-ciabroker /etc/xinetd.d/osehra-vista-ciabroker
sudo cp ./etc/xinetd.d/ciabroker.sh /home/osehra/bin
sudo chown osehra /home/osehra/bin/ciabroker.sh
sudo chgrp osehra /home/osehra/bin/ciabroker.sh
sudo iptables -A INPUT -p tcp --dport 9300 -j ACCEPT
sudo service xinetd restart

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

