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
# Install KIDS builds
#
cd kid
unzip *.zip
for f in *.kid
do
echo "Installing build $f..."
python ../../DefaultKIDSBuildInstaller.py $f -S 2
done
cd ..

#
#  NETSERV broker configuration
#
# sudo cp -r ./etc/xinetd.d/rgbroker-service /home/osehra/etc/xinetd.d/rgbroker-service
# sudo ln -s /home/osehra/etc/xinetd.d/rgbroker-service /etc/xinetd.d/rgbroker-service
# sudo cp ./etc/xinetd.d/rgbroker.sh /home/osehra/bin
# sudo chown osehra /home/osehra/bin/rgbroker.sh
# sudo chgrp osehra /home/osehra/bin/rgbroker.sh
sudo iptables -A INPUT -p tcp --dport 9300 -j ACCEPT

#
#  NETSERV web server configuration
#
# sudo cp -r ./etc/xinetd.d/rghttp-service /home/osehra/etc/xinetd.d/rghttp-service
# sudo ln -s /home/osehra/etc/xinetd.d/rghttp-service /etc/xinetd.d/rghttp-service
# sudo cp ./etc/xinetd.d/rghttp.sh /home/osehra/bin
# sudo chown osehra /home/osehra/bin/rghttp.sh
# sudo chgrp osehra /home/osehra/bin/rghttp.sh
sudo iptables -A INPUT -p tcp --dport 9080 -j ACCEPT

#
# Web app installation
#
sudo cp ./www/cwf-vista.war /var/lib/tomcat7/webapps/cwf-vista.war

#
# Startup/shutdown service configuration
#
sudo cp -r ./etc/init.d/cwf-service /home/osehra/etc/init.d/cwf-service
sudo ln -s /home/osehra/etc/init.d/cwf-service /etc/init.d/cwf-service
sudo service cwf-service start
#
# Install supplemental routines
#
python ../../VistARoutineImport.py ./rou/cwf.rsa -S 2 -o /home/osehra/r

#
# Setup user(s)
#
gtm -run AUTO^RGZINIT

#
# Configure apache
sudo cp ./etc/apache/cwf.conf /etc/apache2/sites-available
sudo sed s/myhost/$HOSTNAME/ ./etc/apache/apache.inp > /tmp/apache.tmp
sudo openssl genrsa -out /etc/ssl/private/cwf.key 2048
sudo openssl req -new -x509 -key /etc/ssl/private/cwf.key -out /etc/ssl/certs/cwf.pem -days 1095 < /tmp/apache.tmp
sudo iptables -A INPUT -p tcp --dport 9081 -j ACCEPT
sudo a2enmod proxy proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html xml2enc ssl
sudo a2ensite cwf
# sudo service xinetd restart
sudo service apache2 restart
