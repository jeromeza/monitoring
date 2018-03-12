#!/bin/bash
# WRITTEN BY: JEROME SHEED AND DANIEL KOSZEGI
# SCRIPT WRAPPER AROUND ANOTHER SCRIPT TO REPORT ERROR CODE FOR REPORTING TO MONITORING SYSTEM
env=`echo $HOSTNAME | cut -c5`
if [ "$env" = "P" ]
then
        user="prod"
elif [ "$env" = "D" ]
then
        user="dev"
else
        user="pprod"
fi

sudo -u $user /mypath/script.sh -t 2700 2> /dev/null
if [ $? -eq 0 ]
then
   echo "Task returned an exit code 0"
   exit 0
else
   echo "Task returned a non zero exit code"
   exit 1
fi

