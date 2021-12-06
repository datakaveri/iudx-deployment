import pika
import sys
import time
import ssl
import os
import json
import datetime
import rejson

username = 'admin'
password = 'admin'
host = 'localhost'
port = 5672
vhost= 'IUDX'
exchange = 'test-itms'
exchange_type = 'direct'
route = 'key'
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
          "id" : "iisc.ac.in/89a36273d77dac4cf38114fca1bbe64392547f86/rs.iudx.io/surat-itms-realtime-information/surat-itms-live-eta"
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

r = rejson.Client(host='localhost',port=6381, decode_responses=True, password="password")

x = r.jsonget('iisc_ac_in_89a36273d77dac4cf38114fca1bbe64392547f86_rs_iudx_io_surat_itms_realtime_information_surat_itms_live_eta')
compar = []

for key in x:
  compar.append(x[key])

compar.pop(0)


compar = sorted(compar, key = lambda x: int(x['license_plate']))
base = sorted(base, key = lambda x: int(x['license_plate']))


if compar == base:
  print("LIP succsefully completed end to end testing")
else:
  print("Failed !!!!!!")