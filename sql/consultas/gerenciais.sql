-- =====================================================================
-- MontArarat ERP - Consultas gerenciais (apoio à decisão do gerente/proprietário)
-- Cada consulta declara: PERGUNTA DE NEGÓCIO, REQUISITO que atende, REGRA aplicada.
-- Convenção: faturamento = pagamentos CONFIRMADOS (estornos não contam); pedido CANCELADO não é venda.
-- =====================================================================
USE montararat_erp;

-- G01 | Pergunta: quanto faturamos por dia e qual o ticket médio? | Atende RF05, RF06
SELECT DATE(pg.data_hora_pagamento)            AS dia,
       COUNT(DISTINCT pg.id_pedido)            AS pedidos_pagos,
       SUM(pg.valor)                           AS faturamento,
       ROUND(SUM(pg.valor) / COUNT(DISTINCT pg.id_pedido), 2) AS ticket_medio
FROM pagamento pg
WHERE pg.status_pagamento = 'CONFIRMADO'
GROUP BY DATE(pg.data_hora_pagamento)
ORDER BY dia;

-- G02 | Pergunta: qual canal e modalidade trazem mais receita (líquida das taxas)? | Atende RF06 (faturamento) e RF02 (formas de pagamento)
SELECT p.canal, p.modalidade,
       COUNT(DISTINCT p.id_pedido)                                   AS pedidos,
       SUM(pg.valor)                                                 AS receita_bruta,
       ROUND(SUM(pg.valor * fp.taxa_percentual / 100), 2)            AS taxas_pagamento,
       ROUND(SUM(pg.valor - pg.valor * fp.taxa_percentual / 100), 2) AS receita_liquida
FROM pedido p
JOIN pagamento pg      ON pg.id_pedido = p.id_pedido AND pg.status_pagamento = 'CONFIRMADO'
JOIN forma_pagamento fp ON fp.id_forma_pagamento = pg.id_forma_pagamento
GROUP BY p.canal, p.modalidade
ORDER BY receita_liquida DESC;

-- G03 | Pergunta: quais produtos mais vendem e quanto cada um contribui? (itens avulsos de pedidos não cancelados) | Atende RF06 (pratos mais vendidos)
SELECT pr.nome AS produto, cp.nome AS categoria,
       SUM(ip.quantidade)                        AS unidades,
       SUM(ip.quantidade * ip.preco_unitario)    AS receita_itens
FROM item_pedido ip
JOIN pedido p            ON p.id_pedido = ip.id_pedido AND p.status_pedido <> 'CANCELADO'
JOIN produto pr          ON pr.id_produto = ip.id_produto
JOIN categoria_produto cp ON cp.id_categoria_produto = pr.id_categoria_produto
GROUP BY pr.id_produto, pr.nome, cp.nome
ORDER BY receita_itens DESC;

-- G04 | Pergunta: qual a margem bruta teórica por produto (preço de venda - custo da ficha técnica)? | Atende RF06 (análise de desempenho) usando a ficha técnica de RF04
SELECT nome AS produto, preco_venda,
       ROUND(custo_teorico, 2)  AS custo_teorico,
       ROUND(margem_bruta, 2)   AS margem_bruta,
       ROUND(100 * margem_bruta / preco_venda, 1) AS margem_pct
FROM v_custo_produto
ORDER BY margem_pct DESC;

-- G05 | Pergunta: em quais horários a casa vende mais? (apoia escala de pessoal) | Atende RF05, RF06
SELECT HOUR(p.data_hora_pedido) AS hora, COUNT(*) AS pedidos
FROM pedido p
WHERE p.status_pedido <> 'CANCELADO'
GROUP BY HOUR(p.data_hora_pedido)
ORDER BY hora;

-- G06 | Pergunta: quanto tempo o cliente espera do pedido até o pronto, por modalidade? E o tempo real excede o tempo base? | Atende RF06 (tempo médio) e RF08
SELECT p.modalidade,
       COUNT(*)                                                                    AS pedidos,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.data_hora_pedido, p.data_hora_pronto)), 1) AS espera_media_min,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.data_hora_inicio_preparo, p.data_hora_pronto)), 1) AS preparo_medio_min,
       ROUND(AVG(t.tempo_base_min), 1)                                             AS tempo_base_medio_min
FROM pedido p
JOIN v_tempo_base_pedido t ON t.id_pedido = p.id_pedido
WHERE p.data_hora_pronto IS NOT NULL AND p.status_pedido <> 'CANCELADO'
GROUP BY p.modalidade;

-- G07 | Pergunta: a prioridade do salão está funcionando? (espera na fila por prioridade) | Atende RDN09 (prioridade do consumo local)
SELECT CASE WHEN p.modalidade = 'LOCAL' THEN 'LOCAL (prioridade 1)' ELSE 'RETIRADA/DELIVERY (prioridade 2)' END AS grupo,
       COUNT(*) AS pedidos,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.data_hora_pedido, p.data_hora_inicio_preparo)), 1) AS espera_media_ate_iniciar_min,
       MAX(TIMESTAMPDIFF(MINUTE, p.data_hora_pedido, p.data_hora_inicio_preparo))           AS maior_espera_min
FROM pedido p
WHERE p.data_hora_inicio_preparo IS NOT NULL AND p.status_pedido <> 'CANCELADO'
GROUP BY CASE WHEN p.modalidade = 'LOCAL' THEN 'LOCAL (prioridade 1)' ELSE 'RETIRADA/DELIVERY (prioridade 2)' END;

-- G08 | Pergunta: quais insumos precisam de reposição e quanto falta para atingir o mínimo? | Atende RF04
SELECT id_insumo, nome, marca, unidade_medida, saldo_atual, estoque_minimo,
       estoque_minimo - saldo_atual AS falta_para_o_minimo
FROM v_saldo_estoque
WHERE situacao = 'ABAIXO_DO_MINIMO'
ORDER BY falta_para_o_minimo DESC;

-- G09 | Pergunta: quais lotes vencem nos próximos 30 dias (referência: data da última movimentação do banco)? | Atende RF04 (validade)
SELECT l.codigo_lote, i.nome AS insumo, l.data_validade, l.quantidade_recebida
FROM lote l
JOIN insumo i ON i.id_insumo = l.id_insumo
WHERE l.data_validade IS NOT NULL
  AND l.data_validade BETWEEN '2026-10-13' AND '2026-11-12'
ORDER BY l.data_validade;

-- G10 | Pergunta: quanto gastamos com cada fornecedor e quanto está em aberto? | Atende RF12 (compras) e RF13 (contas a pagar)
SELECT f.razao_social,
       COUNT(DISTINCT c.id_compra)                                   AS compras,
       SUM(cp.valor)                                                 AS total_contas,
       SUM(CASE WHEN cp.status_conta = 'ABERTA' THEN cp.valor ELSE 0 END) AS em_aberto
FROM fornecedor f
JOIN compra c       ON c.id_fornecedor = f.id_fornecedor AND c.status_compra <> 'CANCELADA'
JOIN conta_pagar cp ON cp.id_compra = c.id_compra
GROUP BY f.id_fornecedor, f.razao_social
ORDER BY total_contas DESC;

-- G11 | Pergunta: qual a satisfação média e quantas reclamações seguem sem tratamento? | Atende RF10 (avaliação)
SELECT tipo_avaliacao,
       COUNT(*)              AS registros,
       ROUND(AVG(nota), 2)   AS nota_media,
       SUM(CASE WHEN status_tratamento IN ('ABERTA', 'EM_ANALISE') THEN 1 ELSE 0 END) AS pendentes
FROM avaliacao
GROUP BY tipo_avaliacao;

-- G12 | Pergunta: quanto o desconto promocional custou à casa, por promoção? | Atende RF15 (promoções) e RDN11
SELECT pr.nome AS promocao, COUNT(*) AS pedidos, SUM(p.valor_desconto) AS total_descontos
FROM pedido p
JOIN promocao pr ON pr.id_promocao = p.id_promocao
WHERE p.status_pedido <> 'CANCELADO'
GROUP BY pr.id_promocao, pr.nome;

-- G13 | Pergunta: como foi cada semana (pedidos, faturamento, ticket médio)? Relatório semanal | Atende RF05
SELECT YEARWEEK(pg.data_hora_pagamento, 1)  AS ano_semana_iso,
       MIN(DATE(pg.data_hora_pagamento))    AS primeiro_dia,
       COUNT(DISTINCT pg.id_pedido)         AS pedidos_pagos,
       SUM(pg.valor)                        AS faturamento,
       ROUND(SUM(pg.valor) / COUNT(DISTINCT pg.id_pedido), 2) AS ticket_medio
FROM pagamento pg
WHERE pg.status_pagamento = 'CONFIRMADO'
GROUP BY YEARWEEK(pg.data_hora_pagamento, 1)
ORDER BY ano_semana_iso;

-- G14 | Pergunta: como foi cada turno de caixa, no formato da fita de fechamento (venda, serviço, recebimentos por grupo, tickets, cancelamentos de mesa, diferença)? | Atende RF14, RF05
WITH rec AS (
    SELECT pg.id_caixa,
           SUM(CASE WHEN fp.grupo_fechamento = 'DINHEIRO' THEN pg.valor ELSE 0 END) AS dinheiro,
           SUM(CASE WHEN fp.grupo_fechamento = 'CARTAO'   THEN pg.valor ELSE 0 END) AS cartao,
           SUM(CASE WHEN fp.grupo_fechamento = 'OUTRAS'   THEN pg.valor ELSE 0 END) AS outras,
           SUM(pg.valor) AS soma_recebimentos
    FROM pagamento pg
    JOIN forma_pagamento fp ON fp.id_forma_pagamento = pg.id_forma_pagamento
    WHERE pg.status_pagamento = 'CONFIRMADO'
    GROUP BY pg.id_caixa
), vendas AS (
    SELECT pp.id_caixa,
           COUNT(*)                          AS tickets,
           SUM(t.valor_total - t.valor_servico) AS venda,
           SUM(t.valor_servico)              AS servico
    FROM (SELECT DISTINCT id_pedido, id_caixa FROM pagamento WHERE status_pagamento = 'CONFIRMADO') pp
    JOIN v_total_pedido t ON t.id_pedido = pp.id_pedido
    GROUP BY pp.id_caixa
), canc AS (
    SELECT DATE(p.data_hora_pedido) AS dia, COUNT(*) AS qtde_canc_mesa, SUM(ip.quantidade * ip.preco_unitario) AS cancelamentos_mesa
    FROM item_pedido ip
    JOIN pedido p ON p.id_pedido = ip.id_pedido AND p.id_mesa IS NOT NULL
    WHERE ip.cancelado = 1
    GROUP BY DATE(p.data_hora_pedido)
)
SELECT cx.id_caixa AS turno, cx.terminal, DATE(cx.data_hora_abertura) AS dia, cx.valor_abertura,
       v.venda, v.servico, r.soma_recebimentos AS registrado,
       r.dinheiro, r.cartao, r.outras,
       v.tickets, ROUND(r.soma_recebimentos / v.tickets, 2) AS valor_medio_ticket,
       COALESCE(c.cancelamentos_mesa, 0) AS cancelamentos_mesa, COALESCE(c.qtde_canc_mesa, 0) AS qtde_canc_mesa,
       cx.valor_fechamento,
       cx.valor_fechamento - (cx.valor_abertura + r.soma_recebimentos) AS diferenca_caixa
FROM caixa cx
JOIN rec r     ON r.id_caixa = cx.id_caixa
JOIN vendas v  ON v.id_caixa = cx.id_caixa
LEFT JOIN canc c ON c.dia = DATE(cx.data_hora_abertura)
ORDER BY cx.id_caixa;

