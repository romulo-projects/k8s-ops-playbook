# Orphan PersistentVolumes

## Contexto

Detectar volumes que não estão sendo utilizados.

Impacto:

* Consumo desnecessário de storage
* Custo

---

## Comando

```bash
kubectl get pv -o json | jq -r '
[
  "pv","status","claim"
],
(
  .items[]
  | select(.status.phase == "Available")
  | [
      .metadata.name,
      .status.phase,
      (.spec.claimRef.name // "none")
    ]
)
| @csv'
```

---

## Explicação

* `Available` → não está vinculado a nenhum PVC

---

## Cuidados

* Pode ser pool de storage
* Validar antes de remover
