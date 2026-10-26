# Contribuindo

Abra uma branch e descreva o problema operacional que o comando resolve.
Use [o template](commands/_template.md) e adicione o procedimento ao [índice](commands/index.md).

## Validação local

Requisitos: Bash, jq 1.6+ e ShellCheck. Não é necessário cluster:

```bash
bash tests/run.sh
shellcheck -x scripts/*.sh tests/*.sh cheatsheet/aliases.sh
```

Filtros reutilizáveis ficam em filters/; os testes executam os mesmos arquivos usados por scripts/report.sh.
Ao mudar um filtro, adicione casos com campos ausentes e falsos positivos relevantes.
Exemplos devem ser sintéticos, sem identificadores ou dados sensíveis de produção.

Diferencie consultas de alterações. Documente RBAC necessário, dependências, saída,
limitações e próximos passos. Não transforme um indício em autorização para excluir recursos.
