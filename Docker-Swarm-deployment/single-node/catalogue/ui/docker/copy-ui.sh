#!/bin/sh
set -e 
#mountpoint of UI files is /usr/share:/mnt
mkdir -p /mnt/app/
cp -r dk-customer-ui/ /mnt/app/
echo "successfully copied the files"

