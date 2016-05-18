# Setting up Kafka in Kubernetes

Dynamically getting the IPs for the Kafka brokers is somewhat complex so instead I create a load balancer for each Kafka broker and choose to hardcode the IP/port combination for each broker in the replication controller configs in `kafka.yml`.

The Kafka brokers are on different external ports because I'd like to have them all on the same IP like the docker-compose example eventually. I think I could do it more easily using Ingress controllers in the future.

## Usage

1. Attach labels to nodes

  ```sh
  $ count=0; for node in $(kubectl get nodes -o=jsonpath="{.items[*].metadata.name}"); do count=$(((count+1))); kubectl label nodes $node custom/node-id=$count; done
  ```

1. Create the Zookeeper services, Zookeeper replication controllers, and Kafka services

  ```sh
  $ kubectl create -f kubernetes/zookeeper.yml
  ...
  $ kubectl create -f kubernetes/kafka-svc.yml
  ...
  ```

1. Run `kubectl get svc -w` and wait for the Kafka services to be assigned their external IPs

  ```sh
  $ kubectl get svc -w
  NAME      CLUSTER_IP     EXTERNAL_IP      PORT(S)    SELECTOR                AGE
  kafka-1   10.0.0.2                        9092/TCP   app=kafka,server-id=1   47s
  kafka-1   10.0.0.2       192.168.99.100   9092/TCP   app=kafka,server-id=1   54s
  ...
  ```

1. Add the IPs as the `KAFKA_ADVERTISED_HOST_NAME`s in `kubernetes/kafka.yml`

1. Create the Kafka replication controllers

  ```sh
  $ kubectl create -f deploy/k8s/kafka.yml
  ...
  ```

## Future Work

- Kafka brokers and Zookeeper servers that support dynamic scaling
- Dynamic but cross-instance persistent broker IDs for Kafka
- Change to properly tagged latest Zookeeper and Kafka images
