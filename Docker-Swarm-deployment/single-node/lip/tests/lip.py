import pika
import json
import datetime
import redis

username = 'username' # RMQ username
password = 'password' # RNQ password
host = 'localhost' # RMQ host
port = 5672        # RMQ AMQP port
vhost= 'IUDX'
exchange = 'lip-test'  # RMQ exchange name 
exchange_type = 'direct'  
queue_name = 'redis-latest'
route = 'lip-test'  # RMQ routing key

# Redis connection details
redis_host= 'localhost'
redis_port= '<port>'
redis_password= 'password'
# rabbitmq amqp connection details
connection = pika.BlockingConnection(
    pika.URLParameters(f'amqp://{username}:{password}@{host}:{port}/{vhost}'))
channel = connection.channel()

# Declare an exchange named "lip-test"
channel.exchange_declare(exchange=exchange, exchange_type=exchange_type)

# Bind the exchange with the existing queue 'redis-latest'
channel.queue_bind(exchange=exchange, queue=queue_name, routing_key=route)


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
          "id" : "lip-test"
        }
json_obj=json.loads(json.dumps(json_packet))

json_obj['observationDateTime']=datetime.datetime.now().astimezone().replace(microsecond=0).isoformat()
# publishing the packet to the exchange
channel.basic_publish(
exchange=exchange,
routing_key=route,
body=json.dumps(json_obj),
properties=pika.BasicProperties(content_type="application/json",
delivery_mode=1),
mandatory=True
)

r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True, password=redis_password)
x = r.json().get('lip_test')
if x[list(x.keys())[1]]==json_obj:
  print("LIP succsefully completed end to end testing")
else:
  print("Failed !!!!!!")


channel.exchange_delete(exchange='lip-test')
r.close()
connection.close()

