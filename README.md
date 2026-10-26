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

## Comece aqui

Confira o contexto e escolha o namespace antes de investigar:

```bash
kubectl config current-context
bash scripts/report.sh high-restarts meu-namespace
bash scripts/report.sh oomkilled meu-namespace
bash scripts/report.sh missing-resources meu-namespace
bash scripts/report.sh stuck-terminating meu-namespace
bash scripts/report.sh pvc-capacity meu-namespace
```

Execute os scripts da raiz do repositório. Sem namespace, consultam todos os namespaces.
São relatórios somente de leitura com saída CSV; erros da API retornam código diferente de zero.
Uma saída contendo apenas cabeçalho significa que nenhum item correspondeu ao filtro.
O limiar de restarts é maior que 5; o atraso de finalização padrão é 300 segundos,
configurável com `TERMINATING_THRESHOLD_SECONDS`.

| Sintoma | Procedimento |
| --- | --- |
| Container reiniciando | [Restarts](commands/pods/high-restart-count.md) e [OOMKilled](commands/pods/oomkilled.md) |
| Pod não inicia | [Pending e scheduling](commands/pods/pending.md) |
| Service não responde | [Service e EndpointSlices](commands/networking/service-endpoints.md) |
| Pod demora a finalizar | [Finalização atrasada](commands/pods/stuck-terminating.md) |
| Dúvida sobre storage | [PVC: solicitação e capacidade](commands/storage/pvc-usage.md) |

Leia também o [guia de escopo e impacto operacional](docs/operational-safety.md).
Os exemplos de DNS criam Pods; restart e rollback modificam workloads.

## Índice completo

Browse completo dos comandos disponíveis:

[commands/index.md](./commands/index.md)

---

## Troubleshooting Guide

[docs/k8s-troubleshooting-playbook.md](./docs/k8s-troubleshooting-playbook.md)

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
* jq 1.6+
* Bash 4.4+ (Linux, macOS com Bash atualizado ou Git Bash no Windows) para scripts; GNU date para os exemplos com date -d
* Permissões de leitura nos recursos e namespaces consultados

---

## Roadmap

* [x] Relatórios reutilizáveis com saída CSV
* [x] Testes offline dos filtros e validação no GitHub Actions
* [x] Diagnóstico de OOMKilled, Pending e Service/EndpointSlices
* [ ] Expansão de comandos por domínio (pods, nodes, networking)
* [ ] Integração com ferramentas de observabilidade
* [ ] Evolução para CLI

## Desenvolvimento

Os testes usam dados sintéticos e um kubectl simulado, sem acessar clusters:

```bash
bash tests/run.sh
shellcheck -x scripts/*.sh tests/*.sh cheatsheet/aliases.sh
```

Requer jq e ShellCheck instalados. Veja [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Mais informações

Para aprofundar nos conceitos e recursos utilizados neste repositório, consulte a documentação oficial do Kubernetes:

* Kubernetes Documentation: https://kubernetes.io/docs/
* kubectl Reference: https://kubernetes.io/docs/reference/kubectl/
* API Reference: https://kubernetes.io/docs/reference/kubernetes-api/

---

Este repositório foca em uso prático em ambientes reais.
Para detalhes completos de comportamento e configuração, a documentação oficial deve ser a principal referência.

---

## Licença

MIT

---

## Autor

Romulo Della Libera
