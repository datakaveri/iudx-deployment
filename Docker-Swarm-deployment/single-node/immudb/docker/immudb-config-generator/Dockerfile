FROM python:3.8-slim

RUN pip install immudb-py

COPY immudb-config-generator.py /home/

CMD ["python","home/immudb-config-generator.py"]
