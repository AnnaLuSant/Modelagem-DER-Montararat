# BI e uso de IA: o que o banco entrega e o que é proposta

> Honestidade de escopo: nesta entrega **não há dashboard nem modelo de IA implementados**. O banco fornece os dados e as consultas que os alimentariam. O que está abaixo de "Proposta" não existe em código.

## 1. Indicadores (BI) já respondidos por consulta SQL

| Indicador | Consulta | Decisão que apoia |
|---|---|---|
| Faturamento e ticket médio por dia / semana | G01, G13 | Meta de vendas, escala |
| Receita líquida por canal e modalidade (descontando taxas) | G02 | Vale a pena depender do iFood/99food? |
| Produtos mais vendidos | G03 | Cardápio e compras |
| Margem bruta teórica por produto | G04 | Preço e promoções |
| Pedidos por horário | G05 | Escala de equipe |
| Tempo de espera e preparo vs. tempo padrão | G06 | Ajuste do tempo padrão (RF08) |
| Efeito da prioridade do salão na fila | G07 | Verificar RDN09 |
| Insumos abaixo do mínimo | G08 | Compra de reposição |
| Lotes a vencer | G09 | Evitar perdas |
| Gasto e dívida por fornecedor | G10 | Negociação de prazos |
| Satisfação e reclamações pendentes | G11 | Atendimento |
| Custo das promoções | G12 | Política de descontos |
| Divergências e violações | AUD01-AUD10 | Controle interno |

Painel sugerido (RF06): uma tela com os cartões G01/G13 (faturamento), G03 (top produtos), G06 (tempo médio), G08 (reposição) e a lista de alertas das consultas de auditoria que retornaram linhas.

## 2. Onde a IA poderia entrar (PROPOSTA, não implementado)

| Ideia | Dados de entrada (já existem) | Cuidado |
|---|---|---|
| Previsão de demanda semanal por insumo para sugerir a quantidade de compra | `v_consumo_pedido_insumo`, `movimentacao_estoque`, calendário | Só 3 semanas de dados sintéticos: o modelo exige histórico real |
| Alerta de anomalias (caixa, estoque, descontos) | AUD01-AUD10 | Regras já resolvem; IA só ajudaria em padrões que não se conhece |
| Estimativa de tempo de preparo aprendida | `data_hora_inicio_preparo/pronto`, fila | Substitui a fórmula de D02 se houver dados reais |
| Assistente que escreve consultas a partir de perguntas do gerente | Dicionário de dados | Risco de SQL errado: exigir revisão e somente leitura |

## 3. Como a IA foi usada na elaboração deste material

Ver `docs/ia/uso-de-ia.md`.
