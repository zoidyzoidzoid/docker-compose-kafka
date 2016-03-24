# Kafka with docker-compose

Three broker Kafka cluster and three node Zookeeper ensemble running in Docker with docker-compose.

## Overview

Based on @eliaslevy's work on a Zookeeper cluster in Kubernetes [here](https://github.com/eliaslevy/docker-zookeeper), and @wurstmeister's Kafka docker-compose [here](https://github.com/wurstmeister/kafka-docker).

Kafka requires unique `host:port` combinations, and can try assign its own broker IDs, but the issue with it assigning its own broker IDs is that they aren't persistent across container restarts. It would probably be better to hardcode `KAFKA_BROKER_ID` for each instance for now, or you get "Leader Not Available" issues.

I made this while experimenting with setting up Kafka in Kubernetes. I have included the Kubernetes config files and instructions for setting up a multi-broker Kafka cluster and Zookeeper ensemble [here](https://github.com/zoidbergwill/docker-compose-kafka/kubernetes/).

## Usage

To start the Zookeeper ensemble and Kafka cluster, assuming you have docker-compose (>= 1.6) installed:

1. Change the `KAFKA_ADVERTISED_HOST_NAME` to your `DOCKER_HOST` IP
    Note: If you're using [Docker toolbox](https://www.docker.com/products/docker-toolbox) then this is the IP from `env | grep DOCKER_HOST`
1. Run `make up`
1. Once Zookeeper and Kafka are done setting up, you can connect to the Kafka with something like [pykafka](https://github.com/Parsely/pykafka) with your docker host IP:

  ```Python
  > from pykafka import KafkaClient
  > kafka_client = KafkaClient('192.168.99.100:9092') # Or your Docker host IP:9092
  > for topic in kafka_client.topics.values():
      print(topic.partitions[0].leader)

  <pykafka.broker.Broker at 0x1051da080 (host=b'192.168.99.100', port=9094, id=1003)>
  <pykafka.broker.Broker at 0x1051da208 (host=b'192.168.99.100', port=9093, id=1001)>
  <pykafka.broker.Broker at 0x1051da198 (host=b'192.168.99.100', port=9092, id=1002)>
  ```
