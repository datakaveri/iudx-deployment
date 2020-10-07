# Base 
FROM node:current-alpine
RUN apk update && apk add  --no-cache git
RUN echo n | npm install -g --silent @angular/cli
COPY docker/build-ui.sh /usr/bin/
WORKDIR /usr/bin/
ENTRYPOINT ["./build-ui.sh"]
