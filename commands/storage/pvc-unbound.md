# Unbound PersistentVolumeClaims

## Contexto

Identificar PVCs que não foram associados a nenhum PV.

Impacto:

* Pods presos em Pending
* Aplicações indisponíveis

---

## Comando

```bash
kubectl get pvc -A -o json | jq -r '
[
  "namespace","pvc","status","volume"
],
(
  .items[]
  | select(.status.phase != "Bound")
  | [
      .metadata.namespace,
      .metadata.name,
      .status.phase,
      (.spec.volumeName // "none")
    ]
)
| @csv'
```

---

## Explicação

* `phase != Bound` → PVC não associado
* `volumeName` vazio → sem PV vinculado

---

## Cuidados

* Pode ser delay normal de provisionamento
* Verificar StorageClass
