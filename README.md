### Config

### Reset streams application
Reset topologi (kafka strømmen), application-id er laget av nais og finnes som env-var i poden
```shell
kubectl exec -i deploy/kafka-cli -- kafka-streams-application-reset --application-id nom-orgenhet-eventsrc-to-state --input-topics nom.orgenhet-eventsource
```

### List consumer groups
```shell
kubectl exec -i deploy/kafka-cli -- kafka-consumer-groups --list
```

### Show consumers in a group
```shell
kubectl exec -i deploy/kafka-cli -- kafka-consumer-groups --group nom-api-849c455c4-sg9q2 --describe
```

### Describe kafka topic

```shell
kubectl exec -i deploy/kafka-cli -- kafka-topics --describe --topic org.nom.ressurs-eventsource
```

### Delete records i kafka topic
NB! Flere steg.
1. Lag json fil for sletting. <br>
 Sett riktig topic, og offset å slette frem til.
 Offset = -1 er slett alt
2. Kopier den inn i kafka-cli pod
3. Dobbeltsjekk slette-filen i pod'en 
4. Kjør slette commando

Se også *Option 2* i https://www.oak-tree.tech/blog/kafka-admin-remove-messages
og https://stackoverflow.com/questions/46209666/how-do-i-delete-clean-kafka-queued-messages-without-deleting-topic

```shell
echo '{"partitions": [{"topic": "mytest", "partition": 0, "offset": -1}], "version":1 }' > topic.json  

kubectl cp topic.json kafka-cli-7954b679c6-cqpdw:/tmp

kubectl exec -i deploy/kafka-cli -- cat /tmp/topic.json  

kubectl exec -i deploy/kafka-cli -- kafka-delete-records --offset-json-file /tmp/topic.json
```
