# Quick Commands (Em construção...)

## Restart deployment

```bash
kubectl rollout restart deployment <name>
```

---

## Pods com erro

```bash
kubectl get pods -A | grep -E 'CrashLoopBackOff|Error'
```

---

## Eventos

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## Uso de CPU

```bash
kubectl top pod -A --sort-by=cpu
```
