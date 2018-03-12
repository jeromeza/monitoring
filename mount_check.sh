#!/bin/bash
# AUTHOR: Jerome Sheed
# USAGE: ./check_mount.sh
# WRITTEN: 02/10/2017
# NOTES: * The script checks if it can 'touch $CHECK_FILE'
#        * If it CAN then it exits with an exit 0 and informs that "$CHECK_MOUNT is mounted!".
#        * If it CAN'T then it exits with an exit 1 and informs that the "$CHECK_MOUNT is not mounted!".
#        * OP5 then reads these exit codes (when the script is called up through the NRPE check and issues an OK / WARNING / CRITICAL as needed.

### SET CHECK VARIABLES ###
CHECK_FILE=/my_mount/VaultStat.txt
CHECK_MOUNT=/my_mount

### TOUCH FILE TO DETERMINE IF MOUNT IS UP OR NOT AND EXIT 0 OR EXIT 1 BASED ON RESULT ###
touch $CHECK_FILE
if [ $? -eq 0 ] ; then
        echo "$CHECK_MOUNT is mounted!"
        exit 0;
elif [ $? -eq 1 ] ; then
        echo "$CHECK_MOUNT is not mounted!"
        exit 1;
fi

