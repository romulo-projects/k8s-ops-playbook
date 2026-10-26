# Pods Pending e falhas de scheduling

## Contexto e requisitos

Distinguir falta de agendamento de espera por imagem, inicialização ou volume.
Requer kubectl e leitura de Pods e eventos. Impacto: somente leitura.

## Comandos

```bash
kubectl get pods -A --field-selector=status.phase=Pending -o wide
kubectl describe pod <pod> -n <namespace>
kubectl get events -n <namespace> --field-selector involvedObject.name=<pod> --sort-by=.metadata.creationTimestamp
```

## Interpretação

Sem node atribuído: procure FailedScheduling, recursos insuficientes, taints, affinity e PVCs.
Com node atribuído: investigue image pull, montagem de volumes e init containers.
Pending não significa exclusivamente falha no scheduler.

## Limitações e próximos passos

Eventos têm retenção limitada e o filtro por nome pode incluir um Pod anterior com o mesmo nome.
Correlacione timestamps e UID. Ajuste requests ou regras de scheduling somente após entender
a capacidade e os requisitos do workload.

[Referência: debug de Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)
