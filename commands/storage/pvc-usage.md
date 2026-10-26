# PVC: solicitação versus capacidade provisionada

## Contexto e requisitos

Comparar o storage solicitado com a capacidade reportada pelo PVC.
Requer Bash, kubectl, jq e leitura de PVCs. Impacto: somente leitura.

## Comando

Da raiz do repositório:

```bash
bash scripts/report.sh pvc-capacity
bash scripts/report.sh pvc-capacity meu-namespace
```

## Saída e limitações

CSV: namespace, pvc, requestedStorage, provisionedCapacity, phase.
Capacidade ausente aparece vazia em PVCs ainda não vinculados.
Valores mantêm as unidades Kubernetes (por exemplo, Gi e Mi); não compare essas strings numericamente.

Nenhuma coluna representa espaço efetivamente ocupado no filesystem.
Para consumo real, consulte métricas do kubelet/CSI quando disponíveis, como
`kubelet_volume_stats_used_bytes` e `kubelet_volume_stats_capacity_bytes`.
A disponibilidade depende do driver e do tipo de volume.
Durante expansão, solicitação e capacidade podem divergir temporariamente.

[Referência: PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
