import pika
import sys
import time
import os
import json
import datetime

username = 'admin' # RMQ username
password = 'GrZ4y(5Zc2K9N%j3SX5v7d2!WmJ' # RNQ password
host = '20.204.143.233' # RMQ host
port = 24568        # RMQ AMQP port
vhost= 'IUDX'
exchange = 'test-itms'  # RMQ exchange name 
exchange_type = 'direct'  
route = 'key'  # RMQ routing key
# rabbitmq amqp connection details

connection = pika.BlockingConnection(
    pika.URLParameters(f'amqp://{username}:{password}@{host}:{port}/{vhost}'))

channel = connection.channel()

count=0
# sample itms data packet
json_packet=   {
          "trip_direction" : "NT",
          "trip_id" : "24374871",
          "route_id" : "17AD",
          "trip_delay" : 948,
          "last_stop_arrival_time" : "15:09:58",
          "actual_trip_start_time" : "2020-11-03T14:22:30+05:30",
          "vehicle_label" : "A09",
          "observationDateTime" : "2020-11-03T15:12:08+05:30",
          "speed" : 25.0,
          "license_plate" : "GJ05BX1916",
          "last_stop_id" : "2028",
          "location" : {
            "coordinates" : [
              72.870511,
              21.218943
            ],
            "type" : "Point"
          },
          "id" : "test-itms-s"
        }
json_obj=json.loads(json.dumps(json_packet))

base = []
while count < 10:
    count=count+1
    json_obj['license_plate']=str(count)
    json_obj['observationDateTime']=datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()
    base.append(json_obj.copy())
    # publishing the packet to the exchange
    channel.basic_publish(
    exchange=exchange,
    routing_key=route,
    body=json.dumps(json_obj),
    properties=pika.BasicProperties(content_type="application/json",
    delivery_mode=1),
    mandatory=True
    )
    print(count)
    time.sleep(1)

connection.close()
r = rejson.Client(host='20.204.143.233',port=6381, decode_responses=True, password='MkLZJlwyQSmorecdpsHK')
x = r.jsonget('test_itms_s')
print(x)
