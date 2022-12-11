FROM alpine:3.16.2
RUN apk update && apk add --no-cache jq curl bash
WORKDIR /usr/share/app
COPY init-scripts/rmq-init-script.sh .
RUN adduser --disabled-password --no-create-home --uid 1001 rmq-automation
USER rmq-automation
CMD ["bash","-c", "./rmq-init-script.sh"]
