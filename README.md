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
