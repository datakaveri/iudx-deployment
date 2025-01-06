FROM ghcr.io/datakaveri/superset:4.0.2-5
USER root
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* 
RUN pip3 install psycopg2
USER 1000

