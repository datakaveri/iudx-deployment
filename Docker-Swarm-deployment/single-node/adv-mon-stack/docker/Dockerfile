FROM python:3.10.6-slim-buster
WORKDIR /usr/share/app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY adv-monstack.py .
RUN useradd -r -u 1001 -g root ams-user
USER ams-user
EXPOSE 8089

ENTRYPOINT ["python3","adv-monstack.py"]
