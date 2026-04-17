# PVC Usage (Capacity vs Request)

## Contexto

Comparar capacidade provisionada dos volumes.

---

## Comando

```bash
kubectl get pvc -A -o json | jq -r '
[
  "namespace","pvc","requested_storage"
],
(
  .items[]
  | [
      .metadata.namespace,
      .metadata.name,
      .spec.resources.requests.storage
    ]
)
| @csv'
```

---

## Explicação

* Mostra storage solicitado
* Base para análise de consumo

---

## Limitação

* kubectl não mostra uso real
* precisa de métricas externas (Prometheus)
