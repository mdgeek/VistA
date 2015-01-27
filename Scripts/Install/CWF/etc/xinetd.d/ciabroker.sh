#!/bin/bash
#
#  This is a file to run CIA Broker as a Linux service
#
export HOME=/home/osehra
source $HOME/etc/env
LOG=$HOME/log/cia.log

echo "$$ Job begin `date`"                                      >>  ${LOG}
echo "$$  Starting CIA broker listener"                         >>  ${LOG}
${gtm_dist}/mumps -run GSERVER^CIANBLIS
echo "$$  CIA Broker stopped with exit code $?"                 >>  ${LOG}
echo "$$ Job ended `date`"
