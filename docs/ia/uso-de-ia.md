# Registro de uso de IA (exigência do curso: documentar e validar)

## Declaração

A revisão crítica da 1ª entrega e a primeira versão dos artefatos desta pasta (catálogo de requisitos, DDL, views, triggers, gerador de massa de dados, consultas, testes e documentos) foram produzidas com apoio do assistente Claude (Anthropic), a pedido do grupo. A IA **não** substitui o entendimento do grupo: tudo deve ser lido, entendido e defendido pelos integrantes.

## O que a IA fez e o que foi validado automaticamente

| Etapa | Produto | Validação feita |
|---|---|---|
| Análise crítica da 1ª entrega | Relatório de falhas contra a devolutiva | Conferido linha a linha com a devolutiva (`docs/historico-alteracoes.md`) |
| DDL, views, triggers | `sql*` | Executados em SQL |
| Massa de dados | `sql/DML` | 18 invariantes verificadas por consulta (FKs, estoque, pagamentos, consumo = ficha técnica, etc.) |
| Consultas | `sql/consultas`| Executadas; auditorias encontram exatamente as anomalias plantadas |
| Documentação técnica | dicionário, modelo lógico, rastreabilidade | Derivados do DDL, para não divergirem |

## O que a IA NÃO validou (responsabilidade do grupo)

- Os prompts efetivamente usados pelo grupo: **preencha abaixo com a verdade**.

## Tabela de prompts do grupo (preencher)

| Data | Integrante | Prompt (resumo fiel) | Resposta usada? | Como foi validada |
|---|---|---|---|---|
|30/10 |Anna Luiza |Avalie de maneira criteriosa a nossa modelgem do Banco de dados Mont Ararat levando em consideração O Fluxograma, o DER, o DDR, DML,as consultas, os requisitos e regras de negócio,a documentação |A estrutura demonstra boa compreensão dos processos de uma hamburgueria. O grupo modelou áreas que frequentemente ficam de fora de projetos acadêmicos, como compras, lotes, movimentações de estoque, atendimento, caixa, ocorrências e reembolsos.  | Foi reescrito e corrigido os pontos de atenção do trabalho |
|25/10|Bruno|Consulta de integridade de tabelas associaiva e se fazem sentido|Apresentou uma explicação de ponto que precisam melhorar|Discussões em grupo e tomada de decisões|
