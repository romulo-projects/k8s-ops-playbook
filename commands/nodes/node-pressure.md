# Nodes Under Resource Pressure

## Contexto

Detectar nodes degradados antes de virar incidente.

---

## Comando

```bash
kubectl get nodes -o json | jq -r '
[
  "node","condition","status"
],
(
  .items[]
  | .metadata.name as $node
  | .status.conditions[]
  | select(
      (.type == "MemoryPressure") or
      (.type == "DiskPressure") or
      (.type == "PIDPressure")
    )
  | select(.status == "True")
  | [
      $node,
      .type,
      .status
    ]
)
| @csv'
```

---

## Explicação

* Filtra condições críticas de node
* Mostra apenas quando estão ativas (`True`)

---

## Impacto

* Pods podem não ser agendados
* Evictions podem ocorrer
* Cluster entra em degradação silenciosa
