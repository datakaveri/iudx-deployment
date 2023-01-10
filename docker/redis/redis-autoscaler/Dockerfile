FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps wget tar jq bc
RUN wget https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz && \
    tar -xvf helm-v3.5.4-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm
RUN rm -rf helm-v3.5.4-linux-amd64.tar.gz linux-amd64

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis" "7.0.2-0" --checksum fdf76de0b9ec9840e6ca259fb5abcc9d6e883294de1c8388bf1f7c4952a6cc21
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/redis-cluster/postunpack.sh
ENV APP_VERSION="7.0.2" \
    BITNAMI_IMAGE_VERSION="7.0.2-debian-11-r8" \
    BITNAMI_APP_NAME="redis-cluster" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/common/bin:$PATH"

USER 0

ENTRYPOINT [ "/opt/bitnami/scripts/redis-cluster/entrypoint.sh" ]
