# Pods Without Resource Requests/Limits

## Contexto

Detectar workloads que podem causar:

* starvation
* overcommit descontrolado
* problemas de scheduling

---

## Comando

```bash
kubectl get pods -A -o json | jq -r '
[
  "namespace","pod","container","hasRequests","hasLimits"
],
(
  .items[]
  | .metadata.namespace as $ns
  | .metadata.name as $pod
  | .spec.containers[]
  | [
      $ns,
      $pod,
      .name,
      (.resources.requests != null),
      (.resources.limits != null)
    ]
)
| @csv'
```

---

## Explicação

* Verifica se há `requests` e `limits`
* Retorna booleano → fácil de filtrar depois

---

## Insight

Se `requests` não existe → scheduler toma decisão ruim

Se `limits` não existe → risco de noisy neighbor
