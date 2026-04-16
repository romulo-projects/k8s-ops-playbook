# k8s-ops-playbook

Real-world Kubernetes commands for SREs and DevOps Engineers.

Este repositório é um playbook operacional com comandos utilizados no dia a dia para troubleshooting, análise e operação de clusters Kubernetes.

---

## Objetivo

Fornecer um conjunto de comandos práticos para:

* Debug rápido em ambientes reais
* Investigação de comportamento do cluster
* Identificação de problemas operacionais
* Execução segura de ações administrativas

---

## Command Index

Browse completo dos comandos disponíveis:

[commands/index.md](./commands/index.md)

---

## Estrutura

```
commands/     → comandos organizados por domínio operacional
scripts/      → automações reutilizáveis
cheatsheet/   → referência rápida para uso diário
docs/         → guias e modelos mentais
examples/     → saídas reais dos comandos
```

Cada comando segue um padrão:

* Contexto
* Comando
* Explicação detalhada
* Cuidados
* Variações

---

## Exemplo

### Identificar deployments inativos elegíveis para análise

```bash
kubectl get deploy -A -o json | jq -r \
--arg cutoff "$(date -u -d '1 month ago' +%Y-%m-%dT%H:%M:%SZ)" '
["namespace","deployment","replicas","availableReplicas","creationTimestamp"],
(.items[]
| select(.spec.replicas == 0)
| select((.status.availableReplicas // 0) == 0)
| select(.metadata.creationTimestamp < $cutoff)
| [
    .metadata.namespace,
    .metadata.name,
    (.spec.replicas // 0),
    (.status.availableReplicas // 0),
    .metadata.creationTimestamp
  ])
| @csv'
```

Identifica deployments com réplicas zeradas, sem pods disponíveis e criados antes do cutoff definido.

---

## Princípios

* Read-only first
* Entenda antes de executar
* Contexto importa mais que o comando

If you don’t understand the command, don’t run it in production.

---

## Mental Model (Kubernetes Debug)

Antes de executar qualquer comando:

1. Scheduling (nodes, recursos, taints)
2. Runtime (crash de containers)
3. Network (services, DNS, ingress)
4. Config (env, ConfigMaps, Secrets)

---

## Requisitos

* kubectl
* jq
* Permissões de leitura no cluster

---

## Roadmap

* [ ] Expansão de comandos por domínio (pods, nodes, networking)
* [ ] Scripts reutilizáveis
* [ ] Integração com ferramentas de observabilidade
* [ ] Evolução para CLI

---

## Licença

MIT

---

## Autor

Romulo Della Libera