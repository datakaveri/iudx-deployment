#!/bin/bash
# backup_dir: rabbitmq backup directory in the current machine
#Assumption that backup is only modified at creation of backup and no time else, this ensured by making the backups read_only 
# retention_time: deletion of files after the specified retention time, in months(m) and days(d)
# usage eg: backup-deletion.sh -d /root/rabbitmq-backup -t 12m, deletion of all  files after 12months of backup creation
# usage eg: backup-deletion.sh -d /root/rabbitmq-backup -t 60d, deletion of all  files after  60days or 2 months of backup creation
while getopts ":d:t:" opt; do
  case $opt in
    d)
     backup_dir=$OPTARG
      ;;
    t)
     retention_time=$OPTARG
     ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
time_unit=`echo "$retention_time" | grep -o [md]`
case $time_unit in 
    m)
      retention_time_no=`echo "$retention_time" |  cut -d 'm' -f 1 `
      retention_time_no=`expr $retention_time_no \* 30` #converting into days
      find "$backup_dir" -mtime +$retention_time_no -type f -exec rm -fv {} \;
      ;;
    d)
      retention_time_no=`echo "$retention_time" |  cut -d 'd' -f 1`
      find "$backup_dir" -mtime +$retention_time_no -type f -exec rm -fv {} \;
      ;;
    *)
      echo "Invalid time_unit" >&2
      exit 1
      ;;
esac



