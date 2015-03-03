#!/bin/bash
#
# Fix line endings
#
dos2unix /vagrant/DDG/*.rsa > /dev/null
#
# Replace globals
#
curl -L -s http://www.carewebframework.org/downloads/dewdrop.zwr.zip -o /tmp/dewdrop.zwr.zip
unzip /tmp/dewdrop.zwr.zip -d /tmp
python /scripts/Scripts/VistARoutineImport.py ./ddg.rsa -S 2 -o /home/osehra/r
gtm -run DDG^RGZDDG /tmp/dewdrop.zwr
rm /tmp/dewdrop.*

