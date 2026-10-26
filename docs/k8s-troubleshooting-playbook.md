# Kubernetes Troubleshooting Playbook

Guia prático para troubleshooting em clusters Kubernetes usando apenas `kubectl` e análise sistemática.

Antes de executar, consulte [escopo e impacto operacional](operational-safety.md).
`get`, `describe` e `logs` são consultas. `exec` executa processos, `run` cria Pods
e `rollout undo` modifica workloads. Use namespace explícito nas investigações.

---

## Abordagem geral

Antes de executar qualquer comando:

1. Eventos
2. Describe
3. Logs
4. Métricas
5. Rede / dependências externas

> Kubernetes sempre deixa pistas. O problema é ignorar a ordem.

---

## Networking / DNS

### Debug de CoreDNS (latência / timeout / SERVFAIL)

```bash
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl -n kube-system logs -l k8s-app=kube-dns
```

Testar DNS dentro do cluster:

```bash
# CRIA POD: use namespace de diagnóstico autorizado.
kubectl run dns-test -n <namespace> --restart=Never --image=busybox:1.37.0 --rm -it -- nslookup kubernetes.default
```

Indicadores de problema:

* `SERVFAIL`
* `timeout`
* alta latência

---

### Checklist Service / Endpoints / EndpointSlice

```bash
kubectl get svc <svc>
# Consulte EndpointSlices para os backends do Service
kubectl get endpointslice -l kubernetes.io/service-name=<svc>
```

Validar:

* Service aponta para labels corretos?
* Endpoints possuem IPs?
* Pods estão prontos (`READY 1/1`)?

---

### Debug de NetworkPolicy

Checklist:

1. Existe NetworkPolicy no namespace?

```bash
kubectl get networkpolicy -n <ns>
```

2. O tráfego está permitido explicitamente?

3. Teste conectividade:

```bash
kubectl exec -it <pod> -- curl <service>
```

4. Validar portas, labels e selectors

---

## Workloads e Rollout

### rollout status / history / undo

```bash
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
# ALTERA O CLUSTER: confirme contexto, namespace e revisão antes de executar.
kubectl rollout undo deployment/<name> -n <namespace>
```

---

### Deployment não sobe

Checklist:

#### Imagem

```bash
kubectl describe pod <pod>
```

Erros comuns:

* `ImagePullBackOff`
* `ErrImagePull`

---

#### Pull Secret

```bash
kubectl get secret
kubectl describe serviceaccount default
```

---

#### Variáveis / ConfigMap / Secret

```bash
kubectl describe pod <pod>
kubectl get configmap
kubectl get secret
```

---

#### Eventos (sempre olhar)

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

### HPA / VPA

```bash
kubectl get hpa
kubectl describe hpa <name>
```

Validar:

* métricas disponíveis?
* CPU/memory definidos nos pods?
* throttling acontecendo?

---

## Nodes / Scheduling

### Pod Pending

```bash
kubectl describe pod <pod>
```

Verificar:

* taints/tolerations
* nodeSelector
* affinity/anti-affinity
* falta de CPU/memória

---

### Pressure Conditions

```bash
kubectl describe node <node>
```

Buscar:

* MemoryPressure
* DiskPressure
* PIDPressure

---

### Debug de CNI

(depende do cluster)

```bash
kubectl -n kube-system get pods
kubectl -n kube-system logs <cni-pod>
```

Problemas comuns:

* Pod não recebe IP
* Comunicação entre pods falha

---

## Storage

### PVC Pending

```bash
kubectl get pvc -A
kubectl describe pvc <pvc>
```

Verificar:

* StorageClass
* provisioner
* quotas

---

### VolumeMount errors

```bash
kubectl describe pod <pod>
```

Problemas comuns:

* permission denied
* fsGroup incorreto
* volume readOnly

---

## Observabilidade (sem ferramenta externa)

### Se eu só tenho kubectl

Ordem recomendada:

1. Eventos

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

2. Describe

```bash
kubectl describe pod <pod>
```

3. Logs

```bash
kubectl logs <pod>
```

4. Métricas (se metrics-server existir)

```bash
kubectl top pod
kubectl top node
```

---

## Padrão mental

Sempre seguir:

1. Eventos → o que aconteceu
2. Describe → estado atual
3. Logs → comportamento da aplicação
4. Métricas → pressão e consumo
5. Rede → dependências externas

---

## Regra de ouro

> Nunca comece pelos logs sem entender o contexto.
