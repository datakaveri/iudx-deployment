FROM python:3.8-slim
WORKDIR /usr/share/app
RUN pip3 install --no-cache-dir requests
COPY src  src
RUN useradd -r -u 1001 -g root account-creation
USER account-creation
CMD ["python3","src/account-creation.py"]

