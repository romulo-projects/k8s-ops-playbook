# Pods with High Restart Count

## Use Case

Troubleshooting

## Severity

High

---

## Contexto

Identificar pods instáveis com alto número de restarts.

Cenários comuns:

* CrashLoopBackOff
* OOMKilled
* Falhas intermitentes de aplicação
* Dependências externas indisponíveis

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

## Output

Formato: CSV

Colunas:

* namespace
* pod
* container
* restartCount

---

## Explicação

* `.status.containerStatuses[]` → nível de container (mais granular que pod)
* `restartCount > 5` → threshold ajustável conforme ambiente
* Uso de `jq` permite filtragem precisa e saída estruturada

---

## Common Root Causes

* CrashLoopBackOff (erro na aplicação)
* OOMKilled (falta de memória)
* Problemas de configuração (env, secret, configmap)
* Dependências externas indisponíveis (DB, API)
* Healthchecks mal configurados

---

## When NOT to use

* Jobs batch com restart esperado
* Pods efêmeros com ciclo curto
* Ambientes com autoscaling agressivo

---

## Next Steps

1. Inspecionar o pod:

```bash
kubectl describe pod <pod> -n <namespace>
```

2. Ver logs do container:

```bash
kubectl logs <pod> -n <namespace> -c <container>
```

3. Verificar eventos:

```bash
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
```

4. Validar uso de recursos:

```bash
kubectl top pod <pod> -n <namespace>
```

---

## Alternative (without jq)

```bash
kubectl get pods -A
```

(Filtrar manualmente pela coluna RESTARTS)

---

## Performance Impact

* Baixo impacto (read-only)
* Pode ser lento em clusters grandes (muitos pods)

---

## Triage Command

Este comando é recomendado como ponto inicial para identificar instabilidade em workloads.
