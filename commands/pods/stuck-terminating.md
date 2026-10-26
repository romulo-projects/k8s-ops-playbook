# Pods com finalização atrasada

## Contexto e requisitos

Encontrar candidatos à investigação, excluindo deleções recentes.
Requer Bash, kubectl, jq e leitura de pods. Impacto: somente leitura.

## Comando

Da raiz do repositório:

```bash
bash scripts/report.sh stuck-terminating
TERMINATING_THRESHOLD_SECONDS=600 bash scripts/report.sh stuck-terminating meu-namespace
```

## Explicação

O filtro compara o horário UTC atual com `deletionTimestamp`.
Só mostra recursos cujo timestamp foi ultrapassado há mais de 300 segundos por padrão.
O campo pode refletir o período de graça; não representa necessariamente o início do pedido de deleção.
A coluna `overdueSeconds` mede o atraso em relação a esse timestamp.

## Próximos passos

```bash
kubectl describe pod <pod> -n <namespace>
kubectl get pod <pod> -n <namespace> -o json
kubectl get events -n <namespace> --field-selector involvedObject.name=<pod> --sort-by=.metadata.creationTimestamp
```

Inspecione finalizers, hooks preStop, volumes e disponibilidade do node.
O limite é uma heurística: operações demoradas podem ser legítimas.
Não remova finalizers ou force deleção sem entender a proteção e o estado do workload.

[Referência: ciclo de vida de Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
