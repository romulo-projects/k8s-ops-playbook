# Pods with High Restart Count

## Contexto

Identificar pods instáveis (crash loops, OOM, falhas intermitentes).

---

## Comando

```bash
kubectl get pods -A -o json | jq -r '
[
  "namespace","pod","container","restartCount"
],
(
  .items[]
  | .metadata.namespace as $ns
  | .metadata.name as $pod
  | .status.containerStatuses[]
  | select(.restartCount > 5)
  | [
      $ns,
      $pod,
      .name,
      .restartCount
    ]
)
| @csv'
```

---

## Explicação

* `.containerStatuses[]` → nível de container (não só pod)
* `restartCount > 5` → threshold ajustável
* Mostra exatamente qual container está instável

---

## Cuidados

* Restart pode ser esperado (jobs, sidecars)
* Sempre validar contexto antes de agir
