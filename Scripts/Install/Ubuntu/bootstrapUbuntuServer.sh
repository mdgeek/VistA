#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update the server from repositories
apt-get -y -qq update > /dev/null
apt-get -y -qq upgrade > /dev/null

# Install baseline packages
apt-get install -y -qq git xinetd perl wget curl python ssh mysql-server openjdk-7-jdk maven sshpass tomcat7 tomcat7-admin apache2 libapache2-mod-proxy-html libxml2-dev > /dev/null

#Configure tomcat7
cp ./Ubuntu/tomcat-users.xml /etc/tomcat7
cat /etc/tomcat7/server.xml | sed 's/8080/8180/g' | sed 's/8005/8105/g' | sed 's/8443/8543/g' > /tmp/server.xml
cp /tmp/server.xml /etc/tomcat7/server.xml
service tomcat7 restart
