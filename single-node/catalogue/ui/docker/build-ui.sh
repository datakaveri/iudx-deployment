#!/bin/sh
set -e 
#mountpoint of UI files is /usr/share:/mnt
git clone https://github.com/datakaveri/dk-customer-ui.git /dk-customer-ui
cd /dk-customer-ui
echo n | npm install
ng build --configuration=production
mkdir -p /mnt/app/dk-customer-ui
cp -r dist/* /mnt/app/dk-customer-ui/
