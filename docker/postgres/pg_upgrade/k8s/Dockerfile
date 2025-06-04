FROM bitnami/postgresql-repmgr:17.4.0

USER root

RUN echo "postgres:x:1001:1001::/home/postgresql:/bin/bash" >> /etc/passwd && \
    mkdir -p /home/postgres && chown -R 1001:1001 /home/postgres

RUN chown -R 1001:root /opt/bitnami/postgresql

RUN chown -R 1001:root /opt/bitnami/repmgr

RUN apt update && apt install -y wget net-tools && \
    wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1w-0+deb11u2_amd64.deb && \
    wget http://ftp.de.debian.org/debian/pool/main/i/icu/libicu67_67.1-7_amd64.deb && \
    dpkg -i libicu67_67.1-7_amd64.deb && \
    wget http://http.us.debian.org/debian/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg-3+deb10u7_amd64.deb && \
    apt install -y ./libldap-2.4-2_2.4.47+dfsg-3+deb10u7_amd64.deb

USER 1001 
