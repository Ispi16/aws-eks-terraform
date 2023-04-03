$ kubectl apply -f testclient.yaml
Then, using the testclient, we create the first topic, which we are going to use to post messages:

$ kubectl -n tools exec -ti testclient -- ./bin/kafka-topics.sh --zookeeper kafka-zookeeper:2181 --topic app --create --partitions 1 --replication-factor 1
Created topic "app".
Here we need to use the correct hostname for zookeeper cluster and the topic configuration.

Next, verify that the topic exists:

$ kubectl -n tools exec -ti testclient -- ./bin/kafka-topics.sh --zookeeper kafka-zookeeper:2181 --list
app
Now we can create one consumer and one producer instance so that we can send and consume messages.

First create one or two listeners, each on its own shell:

$ kubectl -n tools exec -ti testclient -- ./bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic app --from-beginning
Then create the producer session and type some messages. You will be able to see them propagate to the consumer sessions:

$ kubectl -n tools exec -ti testclient -- ./bin/kafka-console-producer.sh --broker-list kafka:9092 --topic app
>Hi
>How are you?
>Hope you're well
>
Hi
How are you?
Hope you're well
