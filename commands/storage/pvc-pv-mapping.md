# PVC to PV Mapping

## Contexto

Mapear relação completa de storage no cluster.

---

## Comando

```bash
kubectl get pvc -A -o json | jq -r '
[
  "namespace","pvc","pv","storageClass"
],
(
  .items[]
  | [
      .metadata.namespace,
      .metadata.name,
      (.spec.volumeName // "none"),
      (.spec.storageClassName // "none")
    ]
)
| @csv'
```

---

## Explicação

Mostra:

* PVC
* PV associado
* StorageClass

---

## Uso real

* Auditoria
* Debug de provisionamento
* Governança de storage
