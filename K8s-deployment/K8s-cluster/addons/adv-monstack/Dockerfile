FROM python:3.10.6-slim-buster

COPY requirements.txt .
COPY finalcode.py /home/ubuntu/
RUN pip3 install -r requirements.txt
RUN useradd -r -u 1001 -g root ams-user
USER ams-user
EXPOSE 8089

ENTRYPOINT ["python3","/home/ubuntu/finalcode.py"]
