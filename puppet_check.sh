#!/bin/bash
# Author: Jerome Sheed
# Usage: ./puppet_check.sh
# Notes: Checks to see if the last time the Puppet agent applied config is within the last two hours.

# SET VARIABLES #
lastpuppetrun=$(grep "Applied catalog" /var/log/messages | tail -n1)
lastpuppetrun_date=$(grep "Applied catalog" /var/log/messages | tail -n1 | awk {'print $1 $2'})
lastpuppetrun_hour=$(grep "Applied catalog" /var/log/messages | tail -n1 | awk {'print $3'} | colrm 3)
lastpuppetrun_hour=$((10#$lastpuppetrun_hour)) # FIXES ISSUES WITH 24 HOUR TIME - FORCES DECIMAL (base10) SO 08 BECOMES 8 WHICH ALLOWS FOR COMPARISON
today_date=$(date | awk {'print $2 $3'})
today_hour=$(date | awk {'print $4'} | colrm 3)
today_hour=$((10#$today_hour)) # FIXES ISSUES WITH 24 HOUR TIME - FORCES DECIMAL (base10) SO 08 BECOMES 8 WHICH ALLOWS FOR COMPARISON

# COMPARE TO SEE IF LAST RUN OCCURED TODAY AND IF IT OCCURED WITHIN THE LAST TWO HOURS #
if (( $lastpuppetrun_date == $today_date )) && (( $lastpuppetrun_hour == $today_hour || $lastpuppetrun_hour - $today_hour == -1 )); then
echo "LAST APPLIED PUPPET CONFIG: $lastpuppetrun"
exit 0
else
echo "LAST APPLIED PUPPET CONFIG: $lastpuppetrun"
exit 1
fi

