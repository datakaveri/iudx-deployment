FROM python:3.13-alpine3.21

WORKDIR /app

RUN pip install --no-cache-dir fastapi minio "fastapi[standard]" pika python-dotenv uvicorn pandas 
RUN pip install pydantic-settings openpyxl

COPY src/ .

EXPOSE 8000

CMD ["fastapi", "dev", "/app/main.py", "--host", "0.0.0.0"]
