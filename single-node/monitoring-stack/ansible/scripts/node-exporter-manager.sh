#!/bin/bash

action="install"

while getopts ":a:" opt; do
	case $opt in
	a)
		action=$OPTARG
		;;
	\?)
		printf "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	:)
		printf "Option -$OPTARG requires an argument" >&2
		exit 1
		;;
	esac
done

release="https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz"
bin_dst="/usr/local/bin"
bin="node_exporter"
service_path="/etc/systemd/system/$bin.service"

if [[ $action == "install" ]]; then
	curl -L $release --output ne.tar.gz
	tar -xzvf ne.tar.gz -C $bin_dst "node_exporter-1.0.1.linux-amd64/$bin" --strip-components 1
	rm ne.tar.gz

	cat > $service_path <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=$bin_dst/$bin --web.listen-address="127.0.0.1:9100" --log.format=json --collector.filesystem.ignored-mount-points="^/(dev|proc|sys|run|boot|etc|var/lib/docker/.+)($|/)" ----collector.filesystem.ignored-fs-types="^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"  
[Install]
WantedBy=default.target
EOF
	private_ip=`ifconfig | grep 'inet 10.139.\d*.\d*' | awk '{print $2}'`
	sed -i "/--web.listen-address/c\ExecStart=$bin_dst/$bin --web.listen-address=\"$private_ip:9100\"" $service_path
	systemctl daemon-reload
	systemctl start $bin
	systemctl enable $bin
	# ufw allow 9100

elif [[ $action == "uninstall" ]]; then
	systemctl stop $bin
	systemctl disable $bin
	rm $service_path
	rm $bin_dst/$bin
	# ufw deny 9100

elif [[ $action == "start" ]]; then
	systemctl start $bin
	# ufw allow 9100

elif [[ $action == "stop" ]]; then
	systemctl stop $bin
	# ufw deny 9100

elif [[ $action == "status" ]]; then
	systemctl is-active $bin
fi
