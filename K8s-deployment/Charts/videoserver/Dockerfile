FROM node:14-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache ffmpeg
COPY ./package*.json .
RUN npm i 
COPY . .
RUN npm run build