# MinIO Webhook

MinIO Webhook is a lightweight service that integrates with MinIO to enable event-driven workflows. When data is uploaded to a MinIO bucket, an event is triggered that invokes the webhook. This webhook then pushes the event data to the appropriate RabbitMQ exchange.


## How to build the Docker image

From the root of the project (where the Dockerfile is located), run:

```bash
# Build the Docker image
docker build -t ghcr.io/datakaveri/minio-webhook:1.0.0 .
```
