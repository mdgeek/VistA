#!/bin/bash
#
# Fix line endings
#
dos2unix /vagrant/DDG/*.RSA > /dev/null
#
# Replace globals
#
curl -L -s https://www.dropbox.com/s/yy8v3mo2xhnm4io/dewdrop.zwr.zip?dl=1 -o /tmp/dewdrop.zwr.zip
unzip /tmp/dewdrop.zwr.zip -d /tmp
python /scripts/Scripts/VistARoutineImport.py ./RGZDDG.RSA -S 2 -o /home/osehra/r
gtm -run DDG^RGZDDG /tmp/dewdrop.zwr
rm /tmp/dewdrop.*

