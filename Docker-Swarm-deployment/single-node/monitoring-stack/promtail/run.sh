#!/bin/sh
exec /usr/bin/promtail -config.file=/usr/share/promtail-conf/promtail-config.yaml -log.format json -client.external-labels=host=${NODE_HOSTNAME}
