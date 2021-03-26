#!/bin/sh
exec /usr/bin/promtail -config.file=/usr/share/promtail-conf/promtail-config.yml -log.format json -client.external-labels=host=${NODE_HOSTNAME}
