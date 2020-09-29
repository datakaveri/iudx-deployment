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

release="https://github.com/grafana/loki/releases/download/v1.6.0/promtail-linux-amd64.zip"
bin_dst="/usr/local/bin"
bin="promtail"
service_path="/etc/systemd/system/$bin.service"
config_path="/usr/local/etc/promtail-local-config.yaml"
positions_log_path="/var/log/promtail/"
if [[ $action == "install" ]]; then
	apt update && apt install unzip 
	curl -s  -L $release --output promtail.zip
	unzip promtail.zip -d $bin_dst
	mv $bin_dst/promtail-linux-amd64 $bin_dst/$bin
#	cp ../../promtail/conf/promtail-local-config.yaml $config_path
	mkdir $positions_log_path
	rm promtail.zip
	cat > $service_path <<EOF
[Unit]
Description=Promtail
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=$bin_dst/$bin  -config.file=$config_path -log.format json

[Install]
WantedBy=default.target
EOF

	systemctl daemon-reload
	systemctl start $bin
	systemctl enable $bin

elif [[ $action == "uninstall" ]]; then
	systemctl stop $bin
	systemctl disable $bin
	rm $service_path
	rm $config_path
	rm -rf $positions_log_path
	rm $bin_dst/$bin

elif [[ $action == "start" ]]; then
	systemctl start $bin

elif [[ $action == "stop" ]]; then
	systemctl stop $bin

elif [[ $action == "status" ]]; then
	systemctl is-active $bin
fi
