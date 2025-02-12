ARG VERSION="0.0.1-SNAPSHOT"

# Using minideb:bullseye to build the required packages since it's what bitnami images are based off
FROM bitnami/minideb:bullseye as builder

WORKDIR /tmp/build

# install postgres-common packages to add the postgres PPA so that we can install the postgres-server-dev-16 packages
RUN apt update && apt install -y --no-install-recommends gnupg2 postgresql-common && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -v 16

# install all required packages to build the multicorn and OGR extension 
RUN apt install -y --no-install-recommends build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc postgresql-server-dev-16 python3 python3-dev python3-setuptools python3-pip wget libgdal-dev

# fetch the multicorn code, uncompress and build
RUN wget https://github.com/pgsql-io/multicorn2/archive/refs/tags/v3.0.tar.gz && tar -xvf v3.0.tar.gz && cd multicorn2-3.0 && make

# fetch the OGR code, uncompress and build
RUN wget https://github.com/pramsey/pgsql-ogr-fdw/archive/refs/tags/v1.1.5.tar.gz && tar -xvf v1.1.5.tar.gz && cd pgsql-ogr-fdw-1.1.5 && make

# fetch the GDI Python scripts and uncompress
RUN cd /tmp/build && wget https://github.com/datakaveri/gdi-multicorn-scripts/archive/refs/heads/main.tar.gz && tar -xvf main.tar.gz 

FROM bitnami/postgresql:16.1.0
USER root

# copy the built OGR extension, install gdal-bin and then run make install to install the extension into the final container.
COPY --from=builder /tmp/build/pgsql-ogr-fdw-1.1.5 /pgsql-ogr-fdw-1.1.5
RUN apt update && apt install -y make gdal-bin --no-install-recommends && cd /pgsql-ogr-fdw-1.1.5 && make install

# copy the built multicorn extension, install python and then run make install to install the extension into the final container.
COPY --from=builder /tmp/build/multicorn2-3.0 /multicorn2-3.0
RUN apt install -y python3 python3-dev python3-pip gcc --no-install-recommends && cd /multicorn2-3.0 && make install && rm -rf /var/lib/apt/lists/* && apt remove -y gcc make && apt autoremove -y && apt clean -y

# copy the GSX/GDI Python scripts and install them to the global Python install using pip
COPY --from=builder /tmp/build/gdi-multicorn-scripts-main /gdi-multicorn-scripts-main
RUN cd /gdi-multicorn-scripts-main && pip install .

# drop down to the low-priv user that the original bitnami:postgresql image uses
USER 1001
