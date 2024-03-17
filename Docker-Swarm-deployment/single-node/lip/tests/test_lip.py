import pytest
import requests
import json
import redis
import pika
import datetime
import time
import os

with open('config.json') as file:
    config_data = json.load(file)
    
createVhost = config_data['createVhost']
username = config_data['username'] # RMQ username
password = config_data['password'] # RMQ password
host = config_data['host'] # RMQ host
port = config_data['amqpsPort']        # RMQ AMQP port
hport= config_data['httpsPort']         #RMQ https port
vhost= config_data['vhost']

# RMQ Test Exchange and queue details
exchange = config_data['exchange']  # RMQ exchange name 
exchange_type = config_data['exchangeType'] 
queue_name = config_data['queueName']
route = config_data['route']  # RMQ routing key

# Redis connection details
redis_host= config_data['redisHost']
redis_port= config_data['redisPort']
redis_password= config_data['redisPassword']

# Test configuration block
def test_configuration():
    # Create Vhost named `$vhost`	
    if createVhost:
        url = f'https://{host}:{hport}/api/vhosts/{vhost}'
        response = requests.put(url, auth=(username, password))
    # rabbitmq amqp connection details
    connection = pika.BlockingConnection(
        pika.URLParameters(f'amqps://{username}:{password}@{host}:{port}/{vhost}'))
    channel = connection.channel()
    # create an exchange named in var `exchange`
    channel.exchange_declare(exchange=exchange, exchange_type=exchange_type)
    if createVhost :
        channel.queue_declare(queue=queue_name)
    # Bind the exchange with the existing queue 'redis-latest'
    channel.queue_bind(exchange=exchange, queue=queue_name, routing_key=route)
    connection.close()
    # Check whether binding is success with given queue name
    exchange_bindings_url = f'https://{host}:{hport}/api/exchanges/{vhost}/{exchange}/bindings/source'
    response = requests.get(exchange_bindings_url, auth=(username, password))
    bindings = response.json()
    assert bindings[0]['destination']==queue_name

    #assert queue_name in [binding.queue for binding in channel.queue_bindings(exchange=exchange)]
    #assert response.status_code == 201 or 204

# Test test block
def test_test():
    url = f'https://{host}:{hport}/api/vhosts/{vhost}'
    connection = pika.BlockingConnection(
        pika.URLParameters(f'amqps://{username}:{password}@{host}:{port}/{vhost}'))
    channel = connection.channel()

    # sample itms data packet
    json_packet = {
        "trip_direction": "NT",
        "trip_id": "24374871",
        "route_id": "17AD",
        "trip_delay": 948,
        "last_stop_arrival_time": "15:09:58",
        "actual_trip_start_time": "2020-11-03T14:22:30+05:30",
        "vehicle_label": "A09",
        "observationDateTime": "2020-11-03T15:12:08+05:30",
        "speed": 25.0,
        "license_plate": "GJ05BX1916",
        "last_stop_id": "2028",
        "location": {
            "coordinates": [
                72.870511,
                21.218943
            ],
            "type": "Point"
        },
        "id": "lip-test"
    }
    json_obj = json.loads(json.dumps(json_packet))

    json_obj['observationDateTime'] = datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()

    channel.basic_publish(
        exchange=exchange,
        routing_key=route,
        body=json.dumps(json_obj),
        properties=pika.BasicProperties(content_type="application/json",
                                        delivery_mode=1),
        mandatory=True
    )
    
    time.sleep(3)
    r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True, password=redis_password)
    x = r.json().get('lip_test')
    if createVhost:
        channel.queue_delete(queue=queue_name)
    channel.exchange_delete(exchange=exchange)
    r.close()
    connection.close()
    assert x[list(x.keys())[1]]==json_obj
    


