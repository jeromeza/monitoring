#!/bin/bash
# AUTHOR: Jerome Sheed
# USAGE: ./nfs_mount_check.sh
# WRITTEN: 12/10/2017
# NOTES:
#        * Stops SSHD
#        * Disables SSHD on boot
#        * The script checks if it can 'touch $CHECK_FILE'
#        * If it CAN then it breaks the loop and informs that the NFS mount is UP.
#        * If it CAN'T then it sits in a permanent loop, sleeps and retries until it reaches the correct result (NFS mount being up).
#        * Once the conditions have been met and the loop exited then SSH is set back to port 22 and the SSHD service is restarted.

### SHOW SCRIPT START TIME ###
echo "---------------------------------------------------------------------"
echo "SCRIPT STARTED ON:"
echo "---------------------------------------------------------------------"
echo $(date)
echo

### SHOW BOOT TIME ###
echo "---------------------------------------------------------------------"
echo "SYSTEM BOOTED ON:"
echo "---------------------------------------------------------------------"
echo $(who -b)

### STOP AND DISABLE SSH SERVICE AT BOOT ###
echo
echo "---------------------------------------------------------------------"
echo "STOPPING SSH SERVICE"
echo "---------------------------------------------------------------------"
/sbin/service sshd stop
echo
echo "---------------------------------------------------------------------"
echo "DISABLING SSH SERVICE"
echo "---------------------------------------------------------------------"
/sbin/chkconfig sshd off
echo $(chkconfig --list | grep ssh)

### CHANGE SSH PORT TO 2222 IN CASE WE NEED SSH ###
echo
echo "---------------------------------------------------------------------"
echo "CHANGING SSH TO USE PORT 2222"
echo "---------------------------------------------------------------------"
/bin/sed -i -e 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
echo $(grep "Port " /etc/ssh/sshd_config)

### START SSH ON PORT 2222 ###
echo
echo "---------------------------------------------------------------------"
echo "STARTING SSH ON PORT 2222"
echo "---------------------------------------------------------------------"
/sbin/service sshd start
echo

### SET REMOTE NFS FILE TO CHECK FOR ###
CHECK_FILE1=/mount1/.NFS/NFS_stat.txt
CHECK_FILE2=/mount2/.NFS/NFS_stat.txt
CHECK_FILE3=/mount3/.NFS/NFS_stat.txt
CHECK_FILE4=/mount4/.NFS/NFS_stat.txt

### CHECK FOR FILE AND PERFORM ACTIONS ###
while true; do

if [ -f $CHECK_FILE1 ]; then
   echo "---------------------------------------------------------------------"
   echo "/mount1 MOUNT IS UP - AS OF:"
   echo "---------------------------------------------------------------------"
   echo "" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $2; fflush(); }'
if [ -f $CHECK_FILE2 ]; then
   echo "---------------------------------------------------------------------"
   echo "/mount2 MOUNT IS UP - AS OF:"
   echo "---------------------------------------------------------------------"
   echo "" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $2; fflush(); }'
if [ -f $CHECK_FILE3 ]; then
   echo "---------------------------------------------------------------------"
   echo "/mount3 MOUNT IS UP - AS OF:"
   echo "---------------------------------------------------------------------"
   echo "" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $2; fflush(); }'
if [ -f $CHECK_FILE4 ]; then
   echo "---------------------------------------------------------------------"
   echo "/mount4 MOUNT IS UP - AS OF:"
   echo "---------------------------------------------------------------------"
   echo "" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $2; fflush(); }'
   break
else
   echo "---------------------------------------------------------------------"
   echo " NFS MOUNTS ARE STILL DOWN - AS OF:"
   echo "---------------------------------------------------------------------"
   echo "" | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $2; fflush(); }'
   echo "- SSH DISABLED ON PORT 22"
   echo "- SSH RUNNING ON PORT 2222 FOR EMERGENCY ACCESS"
   echo "- SLEEPING FOR 30 SEC AND RETRYING"
   echo
   sleep 30
fi
fi
fi
fi
done

### CHANGE SSH PORT BACK TO 22 ###
echo
echo "---------------------------------------------------------------------"
echo "CHANGING SSH BACK TO PORT 22"
echo "---------------------------------------------------------------------"
/bin/sed -i -e 's/Port 2222/#Port 22/g' /etc/ssh/sshd_config
echo $(grep "Port " /etc/ssh/sshd_config)

### RESTART SSH ###
echo
echo "---------------------------------------------------------------------"
echo "STARTING SSH ON PORT 22"
echo "---------------------------------------------------------------------"
/sbin/service sshd restart

