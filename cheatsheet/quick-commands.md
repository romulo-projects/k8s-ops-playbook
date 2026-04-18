# Quick Commands (Em construção...)

Comandos rápidos para troubleshooting e operação no dia a dia.

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
kubectl rollout restart deployment <name>
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
kubectl run dns-test --image=busybox:latest --rm -it -- nslookup kubernetes.default
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
