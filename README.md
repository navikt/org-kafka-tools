# Org Kafka Tools

## Oppsett for pre-commit trigger
Sett opp slik at pre-commit trigger kjøres lokalt på din maskin ved commit for å søke etter secrets, credentials og personinfo i endringer som sjekkes inn.

### Installering
Installer pre-commit på maskinen (trenger kun å kjøres én gang) (https://pre-commit.com/#install)
```shell
pip install pre-commit
```
Installer GitLeaks på maskinen (trenger kun å kjøres én gang) (https://github.com/gitleaks/gitleaks)
Eksempel:
```shell
brew install gitleaks
```
#### Installasjon med nix
```shell
nix profile add nixpkgs#pre-commit
nix profile add nixpkgs#gitleaks
```
### Verifiser installering
```shell
pre-commit --version
gitleaks version
```

### Aktivere pre-commit i prosjektet
Installer pre-commit hooks i github-prosjektet (trenger kun å kjøres én gang per prosjekt)
```shell
pre-commit install
```
Nå skal GitLeaks kjøre på alle endringer som forsøkes å commit'es. Finner den noe mistenkelig vil den stoppe commit'en og vise hva som er funnet.

Commit output skal vise noe slikt som dette:

    Detect hardcoded secrets using Gitleaks..................................Passed


## Config

### Reset streams application
Reset topologi (kafka strømmen), application-id er laget av nais og finnes som env-var i poden

kafka.cli pod må deployes med aiven secret som har rettigheter på partisjonen. Det vil si aiven secret til streams appen. F.eks. aiven-nom-orgenhet-eventsrc-to-state-senon7u8

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
:bangbang: Dette fungerer ikke. kafka-cli har ikke rettighetene til å gjøre dette

NB! Flere steg.
1. Lag json fil for sletting. <br>
 Sett riktig topic, og offset å slette frem til.
 Offset = -1 er slett alt
2. Kopier den inn i kafka-cli pod
3. Dobbeltsjekk slette-filen i pod'en 
4. Kjør slette commando

Se også *Option 2* i https://www.oak-tree.tech/blog/kafka-admin-remove-messages
og https://stackoverflow.com/questions/46209666/how-do-i-delete-clean-kafka-queued-messages-without-deleting-topic

kafka.cli pod må deployes med aiven secret som har rettigheter på partisjonen.
F.eks. gi org-kafka-manger readwrite på topic, og bruk denne appens k8s aiven secret (f.eks. aiven-org-kafka-manager-cg37ax1v) 

```shell
echo '{"partitions": [{"topic": "mytest", "partition": 0, "offset": -1}], "version":1 }' > topic.json  

kubectl cp topic.json kafka-cli-7954b679c6-cqpdw:/tmp

kubectl exec -i deploy/kafka-cli -- cat /tmp/topic.json  

kubectl exec -i deploy/kafka-cli -- kafka-delete-records --offset-json-file /tmp/topic.json
```
