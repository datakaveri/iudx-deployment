# Base 
FROM node:current-alpine as builder 
RUN echo n | npm install -g --silent @angular/cli
RUN apk update && apk add  --no-cache git

# no need of git clone when shifted to dk-customer-ui repo
RUN git clone https://github.com/datakaveri/dk-customer-ui.git 
WORKDIR dk-customer-ui
RUN echo n | npm install && npm audit fix 
RUN ng build --configuration=production


FROM alpine:latest
WORKDIR /usr/share/app/
COPY --from=builder /dk-customer-ui/dist/dk-customer-ui ./dk-customer-ui
COPY docker/copy-ui.sh .
ENTRYPOINT ["./copy-ui.sh"]
 
