# Example Outputs

Dados sintéticos para ilustrar os relatórios; não são capturas de um cluster real.
Os exemplos abaixo seguem o CSV produzido pelo jq, que coloca strings entre aspas.

## Idle Deployments

```csv
"namespace","deployment","replicas","availableReplicas","creationTimestamp"
"dev","api-test",0,0,"2025-01-10T10:00:00Z"
"hml","worker-old",0,0,"2024-12-01T08:30:00Z"
```

---

## High Restart Pods

```csv
"namespace","pod","container","restartCount"
"prod","api-xyz","app",12
```

## OOMKilled

```csv
"namespace","pod","container","source","finishedAt"
"dev","api-xyz","app","previous","2026-10-20T10:00:00Z"
```

## PVC: solicitação e capacidade

```csv
"namespace","pvc","requestedStorage","provisionedCapacity","phase"
"dev","data","2Gi","1Gi","Bound"
"dev","pending-data","1Gi",,"Pending"
```

O primeiro PVC pode estar em expansão. O segundo ainda não reporta capacidade.
Nenhum desses valores mede bytes ocupados no filesystem.

## Nenhum resultado

Somente o cabeçalho é emitido quando não há correspondências.
Confira também o código de saída: uma consulta que falha não equivale a um cluster saudável.
