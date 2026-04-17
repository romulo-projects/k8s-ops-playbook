# PVC Pending with StorageClass

## Contexto

Identificar falhas de provisionamento dinâmico.

---

## Comando

```bash
kubectl get pvc -A -o json | jq -r '
[
  "namespace","pvc","storageClass","status"
],
(
  .items[]
  | select(.status.phase == "Pending")
  | [
      .metadata.namespace,
      .metadata.name,
      .spec.storageClassName,
      .status.phase
    ]
)
| @csv'
```

---

## Possíveis causas

* StorageClass inexistente
* Problema no provisioner
* Permissões de cloud
