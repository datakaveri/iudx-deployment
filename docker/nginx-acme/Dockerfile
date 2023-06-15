ARG nginx_version
FROM ghcr.io/datakaveri/nginx:${nginx_version}

RUN set -ex \
    && apt update \
    && apt install -y --no-install-suggests --no-install-recommends \
      openssh-client \
      socat \
      oathtool \
      jq \
      cron \
    && rm -rf /var/lib/apt/lists/

ENV LE_CONFIG_HOME /acme.sh

ARG AUTO_UPGRADE=1

ENV AUTO_UPGRADE $AUTO_UPGRADE

#Install
COPY ./ /install_acme.sh/
RUN cd /install_acme.sh && ([ -f /install_acme.sh/acme.sh ] && /install_acme.sh/acme.sh --install || curl https://get.acme.sh | sh) && rm -rf /install_acme.sh/

RUN ln -s /root/.acme.sh/acme.sh /usr/local/bin/acme.sh && crontab -l | grep acme.sh | sed 's#> /dev/null#> /proc/1/fd/1 2>/proc/1/fd/2#' | crontab -

COPY ./entrypoint-wrapper.sh /entrypoint-wrapper.sh
COPY ./generate-certs.sh /generate-certs.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]