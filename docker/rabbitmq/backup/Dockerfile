FROM python:3-alpine

WORKDIR /usr/share/app
RUN apk update && apk add curl && apk add openssh-client && pip install --upgrade pip && pip install --no-cache-dir watchdog
COPY  src src
ENTRYPOINT ["python", "./src/backup-watch.py"]
