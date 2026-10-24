# Registro de uso de IA (exigência do curso: documentar e validar)

## Declaração

A revisão crítica da 1ª entrega e a primeira versão dos artefatos desta pasta (catálogo de requisitos, DDL, views, triggers, gerador de massa de dados, consultas, testes e documentos) foram produzidas com apoio do assistente Claude (Anthropic), a pedido do grupo. A IA **não** substitui o entendimento do grupo: tudo deve ser lido, entendido e defendido pelos integrantes.

## O que a IA fez e o que foi validado automaticamente

| Etapa | Produto | Validação feita |
|---|---|---|
| Análise crítica da 1ª entrega | Relatório de falhas contra a devolutiva | Conferido linha a linha com a devolutiva (`docs/historico-alteracoes.md`) |
| DDL, views, triggers | `sql/ddl/*` | Executados em SQLite com adaptador (34 tabelas, 10 views); 43 testes de restrição com controles positivos |
| Massa de dados | `sql/dados` | 18 invariantes verificadas por consulta (FKs, estoque, pagamentos, consumo = ficha técnica, etc.) |
| Consultas | `sql/consultas`, `sql/auditoria` | Executadas; auditorias encontram exatamente as anomalias plantadas |
| Documentação técnica | dicionário, modelo lógico, rastreabilidade | Derivados do DDL, para não divergirem |

## O que a IA NÃO validou (responsabilidade do grupo)

- Execução em MySQL/MariaDB real (ver `docs/limitacoes.md`).
- Aderência ao funcionamento real da hamburgueria (ver `docs/decisoes-a-confirmar.md`).
- Os prompts efetivamente usados pelo grupo: **preencha abaixo com a verdade**.

## Tabela de prompts do grupo (preencher)

| Data | Integrante | Prompt (resumo fiel) | Resposta usada? | Como foi validada |
|---|---|---|---|---|
| | | | | |