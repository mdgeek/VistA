#!/bin/bash
#
#  This is a file to run NETSERV Broker as a Linux service
#
export HOME=/home/osehra
source $HOME/etc/env
LOG=$HOME/log/netserv.log

echo "$$ Job begin `date`"                                      >>  ${LOG}
echo "$$  Starting NETSERV broker listener"                         >>  ${LOG}
${gtm_dist}/mumps -run GTMEP^RGNETTCP RPC\ BROKER
echo "$$  NETSERV Broker stopped with exit code $?"                 >>  ${LOG}
echo "$$ Job ended `date`"
