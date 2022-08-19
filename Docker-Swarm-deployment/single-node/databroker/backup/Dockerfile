FROM python:3-alpine

WORKDIR /usr/share/app
RUN apk update && apk add curl && apk add openssh-client && pip install --upgrade pip && pip install watchdog
COPY  backup-app/ .
ENTRYPOINT ["python", "backup-watch.py"]
