FROM python:3.10.6-slim-buster
WORKDIR /usr/share/app
COPY src src
RUN pip3 install --no-cache-dir -r src/requirements.txt
RUN useradd -r -u 1001 -g root ams-user
USER ams-user
EXPOSE 8089

ENTRYPOINT ["python3","src/adv-monstack.py"]
