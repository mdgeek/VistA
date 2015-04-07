#!/bin/bash
#
#  This is a file to run NETSERV Broker as a Linux service
#
export HOME=/home/osehra
source $HOME/etc/env
${gtm_dist}/mumps -run GTMEP^RGNETTCP RPC\ BROKER
