#!/bin/bash
#
# Fix line endings
#
dos2unix /vagrant/DDG/*.RSA > /dev/null
#
# Replace globals
#
curl -L -s http://www.carewebframework.org/downloads/dewdrop.zwr_ -o /tmp/dewdrop.zwr_
unzip /tmp/dewdrop.zwr_ -d /tmp
python /scripts/Scripts/VistARoutineImport.py ./RGZDDG.RSA -S 2 -o /home/osehra/r
python /scripts/Scripts/VistARoutineImport.py ./XUSHSH.RSA -S 2 -o /home/osehra/r
gtm -run DDG^RGZDDG /tmp/dewdrop.zwr
rm /tmp/dewdrop.*

