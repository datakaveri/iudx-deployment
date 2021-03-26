#!/bin/bash
# --no-cache maybe removed once this is shifted to UI repo (i.e. not git clone  command)
docker build --no-cache  -t dockerhub.iudx.io/iudx/cat-ui:latest -f docker/Dockerfile  .
docker push dockerhub.iudx.io/iudx/cat-ui:latest

