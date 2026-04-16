# Pods Stuck in Terminating

## Contexto

Identificar pods presos em finalização (muito comum em produção).

---

## Comando

```bash
kubectl get pods -A -o json | jq -r '
[
  "namespace","pod","deletionTimestamp"
],
(
  .items[]
  | select(.metadata.deletionTimestamp != null)
  | [
      .metadata.namespace,
      .metadata.name,
      .metadata.deletionTimestamp
    ]
)
| @csv'
```

---

## Explicação

* `deletionTimestamp != null` → pod está sendo finalizado
* Se fica muito tempo → problema de finalizer / volume / node

---

## Possíveis causas

* Finalizers travados
* Volume detach lento
* Node indisponível
