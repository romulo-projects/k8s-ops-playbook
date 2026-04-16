# Kubernetes Commands Index

Navegação central dos comandos disponíveis no playbook.

---

## Como usar este índice

1. Identifique o tipo de problema:

   * Falha em pod
   * Problema de deployment
   * Degradação de node
   * Comportamento do cluster

2. Acesse a categoria correspondente

3. Execute o comando com entendimento do contexto

---

## Deployments

| Comando                                                         | Descrição                                                       |
| --------------------------------------------------------------- | --------------------------------------------------------------- |
| [Find Idle Deployments](./deployments/find-idle-deployments.md) | Identifica deployments com réplicas zeradas, sem pods e antigos |

---

## Pods

| Comando                                            | Descrição                                      |
| -------------------------------------------------- | ---------------------------------------------- |
| [High Restart Count](./pods/high-restart-count.md) | Detecta containers com alto número de restarts |
| [Missing Resources](./pods/missing-resources.md)   | Identifica pods sem requests/limits definidos  |
| [Stuck Terminating](./pods/stuck-terminating.md)   | Lista pods presos em estado de finalização     |

---

## Nodes

| Comando                                   | Descrição                                      |
| ----------------------------------------- | ---------------------------------------------- |
| [Node Pressure](./nodes/node-pressure.md) | Detecta nodes com Memory, Disk ou PID pressure |

---

## Cluster

| Comando                                           | Descrição                              |
| ------------------------------------------------- | -------------------------------------- |
| [Pod Distribution](./cluster/pod-distribution.md) | Mostra a distribuição de pods por node |

---

## Fluxos comuns de troubleshooting

### Pod reiniciando

1. Verificar restarts
   → [High Restart Count](./pods/high-restart-count.md)

2. Validar recursos
   → [Missing Resources](./pods/missing-resources.md)

---

### Pod não finaliza

1. Identificar pods stuck
   → [Stuck Terminating](./pods/stuck-terminating.md)

---

### Cluster degradado

1. Verificar pressão nos nodes
   → [Node Pressure](./nodes/node-pressure.md)

2. Analisar distribuição
   → [Pod Distribution](./cluster/pod-distribution.md)

---

### Limpeza de ambiente

1. Identificar deployments inativos
   → [Find Idle Deployments](./deployments/find-idle-deployments.md)

---

## Convenções

* Todos os comandos são read-only por padrão
* Saídas priorizam formatos estruturados (CSV/JSON)
* Filtros são explícitos e auditáveis

---

## Próximos itens

* Debug de rede (DNS, Service, Ingress)
* Detecção de OOMKilled
* Análise de eventos avançada
* Falhas de scheduling

---

## Navegação

* [Voltar para README](../README.md)
