# Service sem backends prontos

## Contexto e requisitos

Investigar falhas de acesso a um Service antes de testar DNS ou ingress.
Requer kubectl e leitura de Services, Pods e EndpointSlices no namespace.
Impacto: somente leitura.

## Comandos

Substitua os placeholders e use o mesmo namespace em todas as consultas:

```bash
kubectl get service <service> -n <namespace> -o yaml
kubectl get endpointslices -n <namespace> -l kubernetes.io/service-name=<service> -o yaml
kubectl get pods -n <namespace> -o wide --show-labels
```

## O que validar

- Selector do Service corresponde às labels dos Pods?
- EndpointSlices contêm endereços e condições de readiness coerentes?
- port, targetPort e protocolo correspondem ao container?
- NetworkPolicies permitem o tráfego de origem e destino?

## Cuidados e próximos passos

Services ExternalName não usam backends dessa forma. Services sem selector podem ter
EndpointSlices administrados manualmente. Considere também publishNotReadyAddresses.
Um endpoint presente não prova que a aplicação responde.
Se os backends estão corretos, investigue DNS, políticas e implementação de rede.

[Referência: debug de Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
