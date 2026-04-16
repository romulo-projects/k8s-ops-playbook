# Pods Distribution per Node

## Contexto

Analisar distribuição de carga no cluster.

---

## Comando

```bash
kubectl get pods -A -o json | jq -r '
[
  "node","pod","namespace"
],
(
  .items[]
  | select(.spec.nodeName != null)
  | [
      .spec.nodeName,
      .metadata.name,
      .metadata.namespace
    ]
)
| @csv'
```

---

## Explicação

* `.spec.nodeName` → onde o pod está rodando
* Permite identificar:

  * imbalance
  * hotspots
  * problemas de scheduling

---

## Dica

Pipe com `sort | uniq -c` para ver concentração:

```bash
kubectl get pods -A -o json | jq -r '.items[].spec.nodeName' | sort | uniq -c
```
