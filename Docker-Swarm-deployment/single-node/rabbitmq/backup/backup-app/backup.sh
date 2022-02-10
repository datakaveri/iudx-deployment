#!/bin/sh
 # Script called when there change in LATEST.LOG file of rabbtmq and 
 #scp to remote machine on change in backup files
 #Environment variables: that needs to be specified
# rabbitmq_url: rabbitmq management url
# remote_machine: machine to backup to
# remote_user: user of the backup machine 
# rabbitmq_user: rabbitmq username
# rabbitmq_passwd: rabbitmq password
# remote_backup_dir: directory of remote machine to back up to 

check_hash=1
check_scp=0
rabbitmq_passwd=`cat $rabbitmq_passwd_file`
#download of definitions file
curl -k -u "$rabbitmq_user":"$rabbitmq_passwd" "$rabbitmq_url/api/definitions" > /var/lib/backup/definitions.json 2> /usr/share/app/backup.err
check_curl=$?

if [[ $check_curl -eq 0 ]]; then
	
	#checking current downloaded file's hash with the hash of last backed up file, if contents are changed then its backed up	
	md5sum -c /var/lib/backup/backup.md5 2> /dev/null > /dev/null
	check_hash=$?
	
	if [[ $check_hash -ne 0 ]]; then
		timestamp=`date -I'seconds'`
		#making backup file read_only
		chmod a-w /var/lib/backup/definitions.json
		scp -q  -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /var/lib/backup/definitions.json "$remote_user@$remote_machine:$remote_backup_dir/definitions-$timestamp.json"
		check_scp=$?
		chmod u+w /var/lib/backup/definitions.json

		if [[ $check_scp -ne 0 ]]; then
			echo "{\"source\":\"rabbitmq_backup\",\"level\": \"error\",\"message\":\"scp failed\"}"
			exit 1
		fi

		md5sum /var/lib/backup/definitions.json > /var/lib/backup/backup.md5
		echo "{\"source\":\"rabbitmq_backup\",\"level\": \"debug\",\"message\":\"backed up\"}"
	fi
else
	echo "{\"source\":\"rabbitmq_backup\",\"level\": \"error\",\"message\":\"unable to export definitions due to\",\"trace\":\"`cat /usr/share/app/backup.err`\"}"
fi
