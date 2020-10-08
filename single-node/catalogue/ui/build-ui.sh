#!/bin/bash

docker build -t iudx/cat-ui:latest -f ui.dockerfile .
docker run -v /usr/share/app/:/dist -i -t iudx/cat-ui:latest /bin/sh -c "cp -r dist/ ../"
