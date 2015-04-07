#!/bin/bash
#
#  This is a file to run NETSERV WEB SERVER as a Linux service
#
export HOME=/home/osehra
source $HOME/etc/env
${gtm_dist}/mumps -run GTMEP^RGNETTCP HTTP\ ENDPOINT
