#!/bin/bash

set -e 
echo -n  $(cat /dev/urandom |  tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 30) > secrets/passwords/grafana-super-admin-username
echo -n  $(cat /dev/urandom |  tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 30) > secrets/passwords/grafana-super-admin-passwd
