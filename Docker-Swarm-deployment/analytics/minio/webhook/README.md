# MinIO Webhook

## Introduction
MinIO Webhook is a lightweight service that integrates with MinIO to enable event-driven workflows. When data is uploaded to a MinIO bucket, an event is triggered that invokes the webhook. This webhook then pushes the event data to the appropriate RabbitMQ exchange.

## Installation

### 1. Configure the .env File

Substitute appropriate values in the .env file to configure the webhook service. Replace placeholders (<>) with actual values as per your environment. Below is an example of the .env file:

```bash
RABBITMQ_HOST=tasks.rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=admin
RABBITMQ_PASSWORD=admin-password
RABBITMQ_VHOST="INTERNAL"
RABBITMQ_EXCHANGE="demo"
RABBITMQ_ROUTING_KEY="demo_key"

MINIO_ENDPOINT=minio.com
MINIO_ACCESS_KEY=minio-username
MINIO_SECRET_KEY=minio-password
MINIO_USE_SSL=true
MINIO_BUCKET_NAME=webhook

AUTH_TOKEN="minio-auth-token"
```

### 2. Deploy Using Docker Stack


Once the image is built and the .env file is configured, deploy the webhook service in a Docker stack using below command:

```bash
docker stack deploy -c webhook-stack.yaml minio-webhook
```

The upstream code for minio-webhook is available at **[here](https://github.com/datakaveri/minio-webhook-handler)**.
