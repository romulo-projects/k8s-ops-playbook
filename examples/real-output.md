# Example Outputs

## Idle Deployments

```csv
namespace,deployment,replicas,availableReplicas,creationTimestamp
dev,api-test,0,0,2025-01-10T10:00:00Z
hml,worker-old,0,0,2024-12-01T08:30:00Z
```

---

## High Restart Pods

```csv
namespace,pod,container,restartCount
prod,api-xyz,app,12
```
