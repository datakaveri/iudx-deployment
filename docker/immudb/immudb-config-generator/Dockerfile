FROM python:3.8-slim
WORKDIR /usr/share/app
RUN /usr/local/bin/python -m pip install --upgrade pip && pip3 install --no-cache-dir immudb-py==1.4.0
COPY src  src
RUN useradd -r -u 1001 -g root immudb-config
USER immudb-config
CMD ["python","src/immudb-config-generator.py"]

