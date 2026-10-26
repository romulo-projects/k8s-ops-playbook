# Escopo e impacto operacional

## Antes de consultar

```bash
kubectl config current-context
kubectl config view --minify -o jsonpath='{..namespace}'
kubectl auth can-i list pods -n <namespace>
```

Namespace vazio normalmente significa default. Os relatórios usam todos os namespaces quando
o namespace não é informado; prefira escopo local durante investigação.
Para fixar um contexto, use `kubectl --context <contexto> ...` nas consultas manuais.
Os scripts herdam o contexto atual e não alteram o kubeconfig.

## Classificação das ações

| Ação | Impacto | Verificação |
| --- | --- | --- |
| get, describe, logs | Consulta; saída pode conter informações sensíveis | Escopo e permissões |
| top | Consulta; depende da API de métricas | Disponibilidade de metrics-server ou equivalente |
| exec | Executa processo no container; pode alterar a aplicação | Comando e container escolhidos |
| run | Cria Pod e consome recursos; --rm tenta removê-lo ao sair | Pod criado e eventual limpeza |
| rollout restart | Modifica workload e substitui Pods | Disponibilidade, PDBs e rollout status |
| rollout undo | Modifica workload para revisão anterior | Revisão desejada, compatibilidade e rollout status |

Read-only first é a abordagem inicial; procedimentos administrativos são identificados separadamente.
Não capture Secrets nem publique logs/configurações sem revisar dados sensíveis.
Consultas globais também consomem API e podem ser caras em clusters grandes.

## Alterações de workload

Confirme contexto, namespace, revisão e impacto antes de restart ou rollback.
Consulte `kubectl rollout history deployment/<name> -n <namespace>` antes de um undo.
Depois, acompanhe `kubectl rollout status deployment/<name> -n <namespace> --timeout=120s`.
Timeout não desfaz a operação: investigue o estado atual.
