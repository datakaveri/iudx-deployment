#!/bin/bash
# put private_ip,user port defualt values if not defined
action="install"
if [[ -z "$private_ip" ]]; then
	private_ip="127.0.0.1"
fi

if [[ -z "$user" ]]; then
	user="root"
fi

if [[ -z "$port" ]]; then
	port="9100"
fi

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

release="https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz"
bin_dst="/usr/local/bin"
bin="node_exporter"
service_path="/etc/systemd/system/$bin.service"

if [[ $action == "install" ]]; then
	curl -L -s $release --output ne.tar.gz
	tar -xzvf ne.tar.gz -C $bin_dst "node_exporter-1.9.1.linux-amd64/$bin" --strip-components 1
	rm ne.tar.gz

	cat > $service_path <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$user
ExecStart=$bin_dst/$bin --web.listen-address="$private_ip:$port" --log.format=json --collector.filesystem.ignored-mount-points="^/(dev|proc|sys|run|boot|etc|var/lib/docker/.+)($|/)" --collector.filesystem.ignored-fs-types="^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"  
[Install]
WantedBy=default.target
EOF
	systemctl daemon-reload
	systemctl start $bin
	systemctl enable $bin
	echo "$bin status `systemctl is-active $bin`"

elif [[ $action == "uninstall" ]]; then
	systemctl stop $bin
	systemctl disable $bin
	rm $service_path
	rm $bin_dst/$bin
	systemctl reset-failed $bin

elif [[ $action == "start" ]]; then
	systemctl start $bin

elif [[ $action == "stop" ]]; then
	systemctl stop $bin

elif [[ $action == "status" ]]; then
	systemctl is-active $bin
fi
