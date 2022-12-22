#!/bin/bash
set -e
docker run  --rm  -it  -v $(pwd)/secrets:/tmp/secrets \
  -u 0  docker.elastic.co/elasticsearch/elasticsearch:8.3.3\
                /bin/sh -c " \
                        elasticsearch-certutil ca --out /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' && \
                        elasticsearch-certutil cert --name security-master  --ca /tmp/secrets/pki/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /tmp/secrets/pki/elastic-certificates.p12"

~                   
