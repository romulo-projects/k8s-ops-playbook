# Containers com requests ou limits incompletos

## Contexto e requisitos

Auditar CPU e memória em containers de aplicação. Requer Bash, kubectl, jq e leitura de pods.
Execute da raiz do repositório. Impacto: somente leitura.

## Comando

```bash
bash scripts/report.sh missing-resources
# Restringir o escopo:
bash scripts/report.sh missing-resources meu-namespace
```

## Saída esperada

CSV: namespace, pod, container, requestCPU, requestMemory, limitCPU, limitMemory.
Mostra apenas containers com pelo menos um dos quatro campos ausente; campos ausentes ficam vazios.
Objetos vazios não são considerados configurações completas.

## Cuidados e próximos passos

Este relatório cobre `spec.containers`, não init containers nem recursos no nível do Pod.
Ausência de CPU limit pode ser intencional. Não aplique limits automaticamente:
avalie política da equipe, throttling, histórico de uso e capacidade do cluster.
O relatório reflete o Pod admitido, incluindo defaults aplicados por LimitRange.

[Referência: gerenciamento de recursos](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
