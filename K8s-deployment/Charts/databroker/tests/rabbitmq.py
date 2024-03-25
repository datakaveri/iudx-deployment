import urllib.parse
import pika
import sys
import time
import ssl
import os
import json
import datetime
username = 'admin'
password = 'qmjs@XW-Y<#vr5#c4jslyI^run?P@s'
host = 'staging.databroker.iudx.io'
encoded_password=urllib.parse.quote(password)
port = '24567'
vhost='IUDX'
#vhost = '/'
#if len(sys.argv) < 2 else sys.argv[1]
exchange = 'test-itms'
exchange_type = 'direct'
route = 'key'
dirname = os.path.realpath('..')
# ca_cert_file=os.path.join(dirname, 'rabbitmq-python-test/secrets/pki/ca-cert.pem')
# print(ca_cert_file)
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
# context.verify_mode = ssl.CERT_REQUIRED
# context.load_verify_locations(ca_cert_file)
ssl_options=pika.SSLOptions(context)
credentials = pika.PlainCredentials(username,password)
# cp = pika.ConnectionParameters(f'{host}',f'{port}','/',credentials=credentials)

connection = pika.BlockingConnection(
    pika.URLParameters(f'amqps://{username}:{encoded_password}@{host}:{port}/{vhost}'))
    # cp)

channel = connection.channel()
#channel.exchange_declare(exchange=exchange, exchange_type=exchange_type)
count=0
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
          "id" : "test-itms"
        }
json_obj=json.loads(json.dumps(json_packet))

while count < 10:
    count=count+1
    json_obj['license_plate']=str(count)
    json_obj['observationDateTime']=datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()
    channel.basic_publish(  
    exchange=exchange,
    routing_key=route,
    body=json.dumps(json_obj),
    properties=pika.BasicProperties(content_type="application/json",
    delivery_mode=1),
    mandatory=True
    )
    
    print(count)
    # connection.close()
    # time.sleep(0.02)

