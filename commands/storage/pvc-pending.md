# PVC Pending with StorageClass

## Contexto

Listar PVCs Pending para investigar provisionamento; o estado isolado não comprova falha.

---

## Comando

```bash
kubectl get pvc -A -o json | jq -r '
[
  "namespace","pvc","storageClass","status"
],
(
  .items[]
  | select(.status.phase == "Pending")
  | [
      .metadata.namespace,
      .metadata.name,
      .spec.storageClassName,
      .status.phase
    ]
)
| @csv'
```

---

## Possíveis causas

`Pending` não comprova falha. Com `WaitForFirstConsumer`, o provisionamento pode aguardar
um Pod consumidor e suas restrições de scheduling. O filtro lista todos os PVCs Pending,
inclusive aqueles sem StorageClass explícita.

* StorageClass inexistente
* Problema no provisioner
* Permissões de cloud

## Próximos passos

```bash
kubectl describe pvc <pvc> -n <namespace>
kubectl get storageclass <storageclass> -o yaml
kubectl describe pod <pod-consumidor> -n <namespace>
```

Confira eventos, volumeBindingMode, provisioner e restrições de topologia.

[Referência: StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
