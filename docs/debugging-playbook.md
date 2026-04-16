# Kubernetes Debugging Playbook

## Objetivo

Fornecer um fluxo mental para troubleshooting eficiente.

---

## Passo 1: Identifique o tipo de problema

* Pod não sobe?
* Aplicação crashando?
* Latência?
* Deploy não atualiza?

---

## Passo 2: Classifique

| Categoria  | Exemplos         |
| ---------- | ---------------- |
| Scheduling | Pending pods     |
| Runtime    | CrashLoopBackOff |
| Network    | Timeout / DNS    |
| Config     | Env / Secret     |

---

## Passo 3: Aplique comandos

Nunca comece “no escuro”.

Exemplo:

* Pod reiniciando → ver restarts
* Node lento → ver pressure
* Deploy parado → ver replicas/events

---

## Anti-patterns

* Rodar comando sem entender
* Olhar logs primeiro sem contexto
* Ignorar eventos do cluster

---

## Regra de ouro

> Kubernetes sempre deixa pistas — você só precisa saber onde olhar.
