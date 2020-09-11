FROM python:3-alpine

WORKDIR /usr/share/app
RUN apk update && apk add curl && apk add openssh-client && pip install watchdog
COPY backup_watch.py .
COPY backup.sh .
ENTRYPOINT ["python", "backup_watch.py"]
