from pydantic import  Field
from pydantic_settings import BaseSettings


class Env(BaseSettings):
    # MinIO settings
    minio_endpoint: str = Field(..., description="MinIO server endpoint")
    minio_access_key: str = Field(..., description="MinIO access key")
    minio_secret_key: str = Field(..., description="MinIO secret key")
    minio_use_ssl: bool = Field(..., description="Use SSL for MinIO connection")
    minio_bucket_name: str = Field(..., description="Minio bucket name")

    # RabbitMQ settings
    rabbitmq_host: str = Field(..., description="RabbitMQ host")
    rabbitmq_port: int = Field(..., description="RabbitMQ port")
    rabbitmq_username: str = Field(..., description="RabbitMQ username")
    rabbitmq_password: str = Field(..., description="RabbitMQ password")
    rabbitmq_vhost: str = Field(..., description="RabbitMQ virtual host")
    rabbitmq_routing_key: str = Field(..., description="Rebbitmq routing key")
    rabbitmq_exchange: str = Field(..., description="Rebbitmq exchange")
    auth_token:str=Field(..., description="auth token for minio")

    class Config:
        env_file = '.env'
        env_file_encoding = 'utf-8'
        extra = "ignore"
env=Env()
