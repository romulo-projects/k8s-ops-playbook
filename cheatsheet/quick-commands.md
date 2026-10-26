# Quick Commands (Em construção...)

Comandos rápidos para troubleshooting e operação no dia a dia.

Confira [contexto, namespace e impacto](../docs/operational-safety.md) antes de executar.
`rollout restart` altera workloads; o teste DNS cria um Pod temporário.

---

## Triage inicial

### Pods com erro

```bash
kubectl get pods -A | grep -E 'CrashLoopBackOff|Error|ImagePullBackOff'
```

---

### Eventos recentes

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

### Pods com muitos restarts

```bash
kubectl get pods -A
```

(Ver coluna RESTARTS)

---

## Workloads

### Restart de deployment

```bash
# ALTERA O CLUSTER: confirme contexto e namespace antes do restart.
kubectl rollout restart deployment <name> -n <namespace>
```

---

### Status de rollout

```bash
kubectl rollout status deployment <name>
```

---

## Recursos

### Uso de CPU (pods)

```bash
kubectl top pod -A --sort-by=cpu
```

---

### Uso de CPU (nodes)

```bash
kubectl top node
```

---

## Debug de pod

### Describe

```bash
kubectl describe pod <pod> -n <namespace>
```

---

### Logs

```bash
kubectl logs <pod> -n <namespace> --tail=100
```

---

### Logs em tempo real

```bash
kubectl logs -f <pod> -n <namespace>
```

---

### Logs de container específico

```bash
kubectl logs <pod> -n <namespace> -c <container>
```

---

## Scheduling

### Pods Pending

```bash
kubectl get pods -A --field-selector=status.phase=Pending
```

---

### Nodes

```bash
kubectl get nodes
```

---

## Rede

### Teste de DNS

```bash
# CRIA POD: use namespace de diagnóstico autorizado.
kubectl run dns-test -n <namespace> --restart=Never --image=busybox:1.37.0 --rm -it -- nslookup kubernetes.default
```

---

## Storage

### PVC status

```bash
kubectl get pvc -A
```

---

## Dica

Use este arquivo como ponto inicial. Para análise detalhada, consulte os comandos em `commands/`.
