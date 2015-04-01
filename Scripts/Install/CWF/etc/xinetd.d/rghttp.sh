#!/bin/bash
#
#  This is a file to run NETSERV WEB SERVER as a Linux service
#
export HOME=/home/osehra
source $HOME/etc/env
LOG=$HOME/log/netserv.log

echo "$$ Job begin `date`"                                      >>  ${LOG}
echo "$$  Starting NETSERV web server"                         >>  ${LOG}
${gtm_dist}/mumps -run GTMEP^RGNETTCP HTTP\ ENDPOINT
echo "$$  NETSERV web server stopped with exit code $?"                 >>  ${LOG}
echo "$$ Job ended `date`"
