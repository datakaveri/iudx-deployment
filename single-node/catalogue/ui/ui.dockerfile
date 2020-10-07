# Base 
FROM node:current-alpine as base
RUN echo n | npm install -g --silent @angular/cli
RUN apk update && apk add  --no-cache git

RUN git clone https://github.com/datakaveri/dk-customer-ui.git
WORKDIR dk-customer-ui
RUN echo n | npm install
RUN ng build --configuration=production
