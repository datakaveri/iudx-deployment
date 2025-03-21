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

# Fetch the multicorn and OGR code
ADD --chmod=644 https://github.com/pgsql-io/multicorn2/archive/refs/tags/v3.0.tar.gz /tmp/build/multicorn.tar.gz
ADD --chmod=644 https://github.com/pramsey/pgsql-ogr-fdw/archive/refs/tags/v1.1.5.tar.gz /tmp/build/ogr.tar.gz

# Build multicorn and OGR extensions
RUN tar -xf multicorn.tar.gz && \
    cd multicorn2-3.0 && \
    make && \
    cd .. && \
    tar -xf ogr.tar.gz && \
    cd pgsql-ogr-fdw-1.1.5 && \
    make

# Final stage
FROM bitnami/postgresql:16.1.0

USER root

# Copy Built Extensions
COPY --from=builder /tmp/build/pgsql-ogr-fdw-1.1.5 /pgsql-ogr-fdw-1.1.5
COPY --from=builder /tmp/build/multicorn2-3.0 /multicorn2-3.0

# Install dependencies and extensions and clean up.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gdal-bin \
    python3 \
    python3-dev \
    python3-pip \
    make \
    gcc && \
    cd /pgsql-ogr-fdw-1.1.5 && \
    make install && \
    cd /multicorn2-3.0 && \
    make install && \
    rm -rf /pgsql-ogr-fdw-1.1.5 /multicorn2-3.0 && \
    apt-get remove -y gcc make && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fetch and Install multicorn scripts
ADD https://github.com/datakaveri/gdi-multicorn-scripts/archive/refs/heads/main.tar.gz /scripts.tar.gz
RUN pip install --no-cache-dir /scripts.tar.gz && rm scripts.tar.gz

USER 1001
