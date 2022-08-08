FROM python:3.8-slim

RUN /usr/local/bin/python -m pip install --upgrade pip && pip3 install immudb-py==1.3.0.post1

COPY immudb-config-generator.py /home/

CMD ["python","home/immudb-config-generator.py"]
