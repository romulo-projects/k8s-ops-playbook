# Finding Idle Deployments

## Contexto

Identificar deployments que não estão sendo utilizados e podem ser candidatos à remoção.

---

## Comando

```bash
kubectl get deploy -A -o json | jq -r \
--arg cutoff "$(date -u -d '1 month ago' +%Y-%m-%dT%H:%M:%SZ)" '
["namespace","deployment","replicas","availableReplicas","creationTimestamp"],
(.items[]
| select(.spec.replicas==0)
| select((.status.availableReplicas // 0) == 0)
| select(.metadata.creationTimestamp < $cutoff)
| [
    .metadata.namespace,
    .metadata.name,
    (.spec.replicas // 0),
    (.status.availableReplicas // 0),
    .metadata.creationTimestamp
  ])
| @csv'
```

---

## Explicação

### Coleta

```bash
kubectl get deploy -A -o json
```

Retorna todos os deployments do cluster.

---

### Cutoff

Define um timestamp (1 mês atrás em UTC).

---

### Filtros

* `.spec.replicas == 0` → sem pods desejados
* `.status.availableReplicas == 0` → nenhum pod disponível
* `creationTimestamp < cutoff` → evita recursos novos

---

### Output

`@csv` → formato pronto para análise/exportação

---

## Cuidados

* Pode haver scale-to-zero legítimo
* Validar antes de deletar

---

## Variações

### 7 dias

```bash
date -u -d '7 days ago'
```

### Namespace específico

```bash
kubectl get deploy -n <namespace> -o json
```
