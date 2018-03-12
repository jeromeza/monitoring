#!/bin/bash
# AUTHORS: Jerome Sheed / Daniel Koszegi
# USAGE: ./check_permissions.sh -d /path/ -p permission -o owner -g group
# NOTES: USED TO CHECK PERMISSIONS / OWNER / GROUP OF FOLDER AND REPORT BACK IF CORRECT / INCORRECT
# NOTES: USED FOR OP5

### USAGE ###
usage() {
        echo "$0: Unrecognized option $1" >&2
        echo "USAGE ./$(basename $0) -d /path/ -p permission(octal format) -o owner -g group" >&2
        exit 3;
        }

### GET INPUT PARAMETERS ###
while getopts :d:p:o:g: option
do
 case "${option}"
 in
 d) DIRECTORY=${OPTARG};;
 p) CHECK_PERMS=${OPTARG};;
 o) CHECK_OWNER=${OPTARG};;
 g) CHECK_GROUP=${OPTARG};;
 :) usage ;;
 esac
done

shift $((OPTIND-1))

if [ -z "${DIRECTORY}" ] || [ -z "${CHECK_PERMS}" ] || [ -z "${CHECK_OWNER}" ] || [ -z "${CHECK_GROUP}" ]; then
    usage
fi

### CHECK FOLDER PERMISSIONS ###
FOLDER=$(stat -c "%a" $DIRECTORY)

### CHECK FOLDER OWNER ###
OWNER=$(stat -c "%U" $DIRECTORY)

### CHECK FOLDER GROUP ###
GROUP=$(stat -c "%G" $DIRECTORY)

### CHECK EXPECTED PERMISSIONS VS CURRENT PERMISSIONS ###
if [ "$FOLDER" == "$CHECK_PERMS" ] && [ "$OWNER" == "$CHECK_OWNER" ] && [ "$GROUP" == "$CHECK_GROUP" ]; then
  echo "ALL IS OK - FOLDER PERMISSIONS ARE: " $CHECK_PERMS " - FOLDER OWNER IS: " $CHECK_OWNER " - FOLDER GROUP: IS" $GROUP
  exit 0;
else
  if [ "$CHECK_PERMS" != "$FOLDER" ]; then echo "FOLDER PERMISSION ARE NOT RIGHT:" $FOLDER "NOT" $CHECK_PERMS; fi
  if [ "$CHECK_OWNER" != "$OWNER" ]; then echo "FOLDER OWNER IS NOT RIGHT:" $OWNER "IS NOT" $CHECK_OWNER; fi
  if [ "$CHECK_GROUP" != "$GROUP" ]; then echo "FOLDER GROUP OWNER IS NOT RIGHT:" $GROUP "IS NOT" $CHECK_GROUP; fi
  exit 1;
fi

