#!/bin/bash
set -e
docker run  --rm  -it  -v $(pwd)/secrets:/tmp/secrets \
  -u 1000  docker.io/bitnami/elasticsearch:8.12.1-debian-11-r17 \
		/bin/sh -c " \
			elasticsearch-certutil ca --out /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' && \
			elasticsearch-certutil cert --name security-master  --ca /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /tmp/secrets/pki/elastic-certificates.p12" 

