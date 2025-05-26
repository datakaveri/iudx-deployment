ARG VERSION="0.0.1-SNAPSHOT"

# Build stage for extensions
FROM bitnami/minideb:bullseye as builder

WORKDIR /tmp/build

# Install all dependencies in a single layer for better cache utilization
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnupg2 \
    postgresql-common \
    build-essential \
    libreadline-dev \
    zlib1g-dev \
    flex \
    bison \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    libxml2-utils \
    xsltproc \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    libgdal-dev && \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -v 16 && \
    apt-get install -y --no-install-recommends postgresql-server-dev-16

# Download required extensions
ADD --chmod=644 https://github.com/pgsql-io/multicorn2/archive/refs/tags/v3.0.tar.gz /tmp/build/multicorn.tar.gz
ADD --chmod=644 https://github.com/pramsey/pgsql-ogr-fdw/archive/refs/tags/v1.1.5.tar.gz /tmp/build/ogr.tar.gz
ADD --chmod=644 https://github.com/pgvector/pgvector/archive/refs/tags/v0.5.1.tar.gz /tmp/build/pgvector.tar.gz
ADD --chmod=644 https://github.com/apache/age/archive/refs/heads/PG17.tar.gz /tmp/build/age.tar.gz

# Build multicorn, OGR, pgvector, and AGE
RUN tar -xf multicorn.tar.gz && \
    cd multicorn2-3.0 && \
    make && \
    cd .. && \
    tar -xf ogr.tar.gz && \
    cd pgsql-ogr-fdw-1.1.5 && \
    make && \
    cd .. && \
    tar -xf pgvector.tar.gz && \
    cd pgvector-0.5.1 && \
    make && \
    cd .. && \
    tar -xf age.tar.gz && \
    cd age-PG17 && \
    make PG_CONFIG=/usr/lib/postgresql/16/bin/pg_config

# Final stage
FROM bitnami/postgresql-repmgr:16.2.0-debian-11-r1

USER root

# Copy built extensions
COPY --from=builder /tmp/build/pgsql-ogr-fdw-1.1.5 /pgsql-ogr-fdw-1.1.5
COPY --from=builder /tmp/build/multicorn2-3.0 /multicorn2-3.0
COPY --from=builder /tmp/build/pgvector-0.5.1 /pgvector-0.5.1
COPY --from=builder /tmp/build/age-PG17 /age-PG17

# Install dependencies and extensions, and clean up
RUN apt update && \
    apt install -y --no-install-recommends \
    gdal-bin \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    make \
    gcc && \
    cd /pgsql-ogr-fdw-1.1.5 && \
    make install && \
    cd /multicorn2-3.0 && \
    make install && \
    cd /pgvector-0.5.1 && \
    make install && \
    cd /age-PG17 && \
    make install && \
    rm -rf /pgsql-ogr-fdw-1.1.5 /multicorn2-3.0 /pgvector-0.5.1 /age-PG17 && \
    apt-get remove -y gcc make && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fetch and install multicorn Python scripts
ADD https://github.com/datakaveri/gdi-multicorn-scripts/archive/refs/heads/main.tar.gz /scripts.tar.gz
RUN pip install --no-cache-dir /scripts.tar.gz && rm scripts.tar.gz

USER 1001
