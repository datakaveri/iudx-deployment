FROM python:3.8-slim
WORKDIR /usr/share/app
RUN pip3 install --no-cache-dir psycopg2-binary
COPY src  src
RUN useradd -r -u 1001 -g root db-user-creation
USER db-user-creation
CMD ["python3","src/db-user-creation.py"]

