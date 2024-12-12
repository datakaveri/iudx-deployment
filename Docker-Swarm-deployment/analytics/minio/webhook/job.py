from numpy import random
import pandas as pd
import uuid
from pathlib import Path
from minio import Minio
import json
import datetime
from io import BytesIO
from config import env 
import pika
import random 
def fetch_minio_data( object_name):
    client = Minio(
        endpoint=env.minio_endpoint,
        access_key=env.minio_access_key,
        secret_key=env.minio_secret_key,
        secure=env.minio_use_ssl
    )
    try:
        data = client.get_object(env.minio_bucket_name, object_name)
        return data.read()
    except Exception as e:
        print(f"Error fetching data from Minio: {e}")
        return None

def parse_data(file_content, file_type):
    try:
        if file_type == '.csv':
            df = pd.read_csv(BytesIO(file_content),sep=";")
        elif file_type == '.xlsx':
            df = pd.read_excel(BytesIO(file_content))
        elif file_type == '.json':
            df = pd.read_json(BytesIO(file_content))
        else:
            raise ValueError(f"Unsupported file type: {file_type}")
        json=df.to_json(orient='records',lines=True)
        if json == None: 
            return None
        json_list=json.split("\n")
        return json_list
    except Exception as e:
        print(f"Error parsing data: {e}")
        return None

def send_to_rabbitmq(json_list: list[str],withdraw:bool):
    # Establish connection to RabbitMQ
    correlation_id = str(uuid.uuid4())

    properties = pika.BasicProperties(
            correlation_id=correlation_id
    )
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=env.rabbitmq_host,
            port=env.rabbitmq_port,
            credentials=pika.PlainCredentials(env.rabbitmq_username, env.rabbitmq_password),
            virtual_host=env.rabbitmq_vhost,
        )
    )
    channel = connection.channel()
    for json_message in json_list:
        js=json_message.strip();
        if not json_message:
            print(f"Skipping empty JSON message")
            continue
        acc_info=json.loads(js)
        amount=int(acc_info["Amount"].replace(",",""),10)
        if withdraw:
          amount=-amount
        date_obj= datetime.datetime.strptime(acc_info["TransactionDate"], "%Y-%m-%d %H:%M:%S")
        date = date_obj.strftime("%Y-%m-%d %H:%M:%S.%f")
        account={
            "txid":acc_info["TransactionID"],
            "taxid":random.randint(0, 1_000_000),
            "timestamp":date,
            "amount":amount,
            "operator":"interomegaltd",
            "game_acc_id":acc_info["AccountNumber"],
        }
        account_string=json.dumps(account)
        correlation_id = str(uuid.uuid4())

        properties = pika.BasicProperties(
            content_type='application/json',
            correlation_id=correlation_id
        )
        channel.basic_publish(
            exchange=env.rabbitmq_exchange,
            routing_key=env.rabbitmq_routing_key,
            body=account_string,
            properties=properties
        )
    print(f"Sent {len(json_list)} messages to RabbitMQ")
    connection.close()

def job(key:str):
    object_name= key.replace("{}".format(env.minio_bucket_name), "", 1)
    file_content = fetch_minio_data(object_name)
    if not file_content:
        print("Failed to fetch data")
        sys.exit(1)
    file = Path(key)
    parsed_data = parse_data(file_content, file.suffix)
    if parsed_data is None:
        print("Failed to parse data")
        sys.exit(1)
    send_to_rabbitmq(parsed_data,"withdraw" in key)

