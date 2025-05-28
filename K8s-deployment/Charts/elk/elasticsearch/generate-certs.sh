#!/bin/bash
set -e
docker run  --rm  -it  -v $(pwd)/secrets:/tmp/secrets \
  -u 1000  docker.io/bitnami/elasticsearch:8.17.3-debian-12-r2 \
                /bin/sh -c " \
                        elasticsearch-certutil ca --out /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' && \
                        elasticsearch-certutil cert --name security-master  --ca /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /tmp/secrets/pki/elastic-certificates.p12"