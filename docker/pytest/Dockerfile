FROM python:3.10.6-slim-buster
WORKDIR /usr/share/app
COPY /src/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY /src/ .
RUN useradd -r -u 1001 -g root pytest-user
USER pytest-user
ENTRYPOINT ["pytest", "--html=/share/test/reports/report.html"]

