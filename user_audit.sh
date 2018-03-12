#!/bin/bash
# WRITTEN BY: JEROME SHEED
# DATE: 18/12/2017
# TASK: PRINT OUT MEMBERS OF GROUP AND EMAIL OUTPUT TO RECIPIENTS
environment="dev"
group="$(sudo grep $environment /etc/group | cut -d: -f4 | tr ',' '\n' | sort)"
accounts_total="$(sudo grep $environment /etc/group | cut -d: -f4 | tr ',' '\n' | sort | wc -w)"
date=$(date)
hostname=$(hostname)
filename="/home/rpadmin/$environment.txt"
email="me@me.com"
echo "DATE: $date" > $filename
echo "HOSTNAME: $hostname" >> $filename
echo "------------------------------------------------" >> $filename
echo "$group" >> $filename
echo "------------------------------------------------" >> $filename
echo "NUMBER OF ACCOUNTS: $accounts_total" >> $filename
printf "$environment users attached" | mail -a $filename -s "Dev Group Audit - $environment" $email

