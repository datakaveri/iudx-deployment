FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps wget tar jq bc
RUN wget https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz && \
    tar -xvf helm-v3.5.4-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm
RUN rm -rf helm-v3.5.4-linux-amd64.tar.gz linux-amd64

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis" "6.2.5-0" --checksum c669dd5ca4c8536e1b644ad860b6e2fcb16acd15505ddaa49bda2a7142a18a6b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/redis-cluster/postunpack.sh
ENV BITNAMI_APP_NAME="redis-cluster" \
    BITNAMI_IMAGE_VERSION="6.2.5-debian-10-r23" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/common/bin:$PATH"

USER 0

ENTRYPOINT [ "/opt/bitnami/scripts/redis-cluster/entrypoint.sh" ]
