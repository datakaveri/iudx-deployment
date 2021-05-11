# Base 
FROM node:current-alpine as builder
RUN echo n | npm install -g --silent @angular/cli && \
apk update && apk add  --no-cache git

# no need of git clone when shifted to iudx-catalogue-ui repo
RUN git clone https://github.com/datakaveri/iudx-catalogue-ui.git && \
cd /iudx-catalogue-ui && \
 git status && \
echo n | npm install && npm audit fix --force && \
ng build --prod


FROM alpine:latest
WORKDIR /usr/share/app/
COPY --from=builder /iudx-catalogue-ui/dist/iudx-catalogue-ui ./iudx-catalogue-ui
COPY docker/copy-ui.sh .
ENTRYPOINT ["./copy-ui.sh"]


