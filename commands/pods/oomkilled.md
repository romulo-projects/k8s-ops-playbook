# Containers finalizados com OOMKilled

## Contexto e requisitos

Investigar terminações por falta de memória. Requer Bash, kubectl, jq e leitura de pods.
Impacto: somente leitura.

## Comando

Da raiz do repositório:

```bash
bash scripts/report.sh oomkilled
bash scripts/report.sh oomkilled meu-namespace
```

## Explicação e saída

CSV com namespace, pod, container, source e finishedAt.
Inspeciona estado terminado atual e última terminação de containers e init containers.
`source` indica current ou previous. Pods sem status são ignorados.

## Próximos passos

```bash
kubectl describe pod <pod> -n <namespace>
kubectl logs <pod> -n <namespace> -c <container> --previous --tail=100
kubectl top pod <pod> -n <namespace> --containers
```

Logs anteriores podem não estar mais disponíveis. Métricas atuais não mostram necessariamente
o pico que causou a terminação. Correlacione com histórico, limites, consumo do node e comportamento da aplicação.
O status não é um histórico completo: ocorrências antigas podem ter sido substituídas.
Eviction de Pod é um diagnóstico distinto.

[Referência: recursos de containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
