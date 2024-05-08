#!/bin/bash

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/passwords/admin-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/passwords/auditing-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/passwords/rs-password
