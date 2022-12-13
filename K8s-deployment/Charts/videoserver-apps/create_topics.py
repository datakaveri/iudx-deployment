from confluent_kafka.admin import AdminClient, NewTopic
import os
import json

kafka_host = os.environ["KAFKA_HOST"]
kafka_port = os.environ["KAFKA_PORT"]

kafka_topic_cfg = "topics.json"

kafka_topics = {}

with open(kafka_topic_cfg, "r") as f:
    kafka_topics = json.load(f)


admin_client = AdminClient({"bootstrap.servers":
                                kafka_host + ":" + kafka_port,
                                "socket.timeout.ms": 10000})

topic_list = []

for topic in kafka_topics["topics"]:
    topic_list.append(NewTopic(topic["name"],
                        num_partitions=topic["num.partitions"],
                        replication_factor=topic["replication"],
                        config={"retention.ms":
                                str(topic["retention.ms"])}))



fs = admin_client.create_topics(new_topics=topic_list)

for topic, f in fs.items():
    try:
        f.result()  # The result itself is None
        print("Topic {} created".format(topic))
    except Exception as e:
        print("Failed to create topic {}: {}".format(topic, e))