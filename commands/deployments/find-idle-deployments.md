# Finding Idle Deployments

## Contexto

Listar deployments antigos com réplicas desejadas zeradas para revisão operacional. A idade do recurso não indica há quanto tempo ele está zerado.

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
* creationTimestamp mede idade do recurso, não duração da inatividade
* Verifique HPA, KEDA, GitOps e histórico de mudanças antes de considerar remoção
* O exemplo usa GNU date; no macOS instale coreutils e use gdate no lugar de date

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
