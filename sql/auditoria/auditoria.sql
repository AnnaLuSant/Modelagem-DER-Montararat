-- =====================================================================
-- MontArarat ERP - Consultas de AUDITORIA (detectam violação de política ou erro operacional)
-- Resultado esperado em base saudável: ZERO linhas. A massa de dados contém anomalias
-- INTENCIONAIS (A..F) para provar que a auditoria as encontra; cada consulta diz qual espera achar.
-- =====================================================================
USE montararat_erp;

-- AUD01 | Recebimento com quantidade diferente da comprada, item não comprado ou recebimento parcial (anomalias A e B + 1 recebimento parcial de cheddar cremoso) | Atende RF12
SELECT r.id_recebimento, c.id_compra, i.nome AS insumo,
       COALESCE(ic.quantidade, 0) AS qtd_comprada,
       SUM(l.quantidade_recebida) AS qtd_recebida
FROM recebimento r
JOIN compra c  ON c.id_compra = r.id_compra
JOIN lote l    ON l.id_recebimento = r.id_recebimento
JOIN insumo i  ON i.id_insumo = l.id_insumo
LEFT JOIN item_compra ic ON ic.id_compra = c.id_compra AND ic.id_insumo = l.id_insumo
GROUP BY r.id_recebimento, c.id_compra, i.id_insumo, i.nome, ic.quantidade
HAVING SUM(l.quantidade_recebida) <> COALESCE(ic.quantidade, 0)
ORDER BY r.id_recebimento;

-- AUD02 | Pedido com desconto de aniversário sem documento conferido (anomalia C) | Atende RF15 e RDN11
SELECT p.id_pedido, p.data_hora_pedido, p.id_pessoa, p.valor_desconto, p.id_funcionario_autorizador
FROM pedido p
JOIN promocao pr ON pr.id_promocao = p.id_promocao
WHERE pr.exige_documento = 1 AND p.documento_conferido = 0;

-- AUD03 | Fechamento de caixa com diferença: valor de fechamento informado x (abertura + soma de recebimentos), fórmula da fita (anomalia D; também pequenas diferenças) | Atende RF14
SELECT cx.id_caixa, cx.terminal, DATE(cx.data_hora_abertura) AS dia,
       cx.valor_abertura + COALESCE(SUM(pg.valor), 0) AS esperado,
       cx.valor_fechamento AS informado,
       cx.valor_fechamento - (cx.valor_abertura + COALESCE(SUM(pg.valor), 0)) AS diferenca
FROM caixa cx
LEFT JOIN pagamento pg ON pg.id_caixa = cx.id_caixa AND pg.status_pagamento = 'CONFIRMADO'
WHERE cx.valor_fechamento IS NOT NULL
GROUP BY cx.id_caixa, cx.terminal, cx.data_hora_abertura, cx.valor_abertura, cx.valor_fechamento
HAVING cx.valor_fechamento <> cx.valor_abertura + COALESCE(SUM(pg.valor), 0)
ORDER BY ABS(cx.valor_fechamento - (cx.valor_abertura + COALESCE(SUM(pg.valor), 0))) DESC;

-- AUD04 | Reservas sobrepostas na mesma mesa, ignorando canceladas (anomalia E) | Atende RDN02
SELECT a.id_reserva AS reserva_a, b.id_reserva AS reserva_b, a.id_mesa,
       a.data_hora_inicio AS inicio_a, a.data_hora_fim AS fim_a, b.data_hora_inicio AS inicio_b
FROM reserva a
JOIN reserva b ON b.id_mesa = a.id_mesa AND a.id_reserva < b.id_reserva
WHERE a.status_reserva <> 'CANCELADA' AND b.status_reserva <> 'CANCELADA'
  AND a.data_hora_inicio < b.data_hora_fim AND b.data_hora_inicio < a.data_hora_fim;

-- AUD05 | Contas a pagar vencidas e ainda em aberto (anomalia F); referência = data da última atividade da base | Atende RF13
SELECT cp.id_conta_pagar, cp.descricao, cp.valor, cp.data_vencimento,
       DATEDIFF('2026-10-13', cp.data_vencimento) AS dias_atraso
FROM conta_pagar cp
WHERE cp.status_conta = 'ABERTA' AND cp.data_vencimento < '2026-10-13'
ORDER BY dias_atraso DESC;

-- AUD06 | Pedido de retirada/delivery que entrou em produção sem pagamento integral (RDN01) - esperado: 0 linhas | Atende RDN01
SELECT p.id_pedido, p.modalidade, p.status_pedido, v.valor_total, v.valor_pago
FROM pedido p
JOIN v_pedido_pagamento v ON v.id_pedido = p.id_pedido
WHERE p.modalidade <> 'LOCAL'
  AND p.data_hora_inicio_preparo IS NOT NULL
  AND p.status_pedido <> 'CANCELADO'
  AND ROUND(v.valor_pago, 2) < ROUND(v.valor_total, 2);

-- AUD07 | Pedido concluído que não está integralmente pago - esperado: 0 linhas | Atende RDN15
SELECT p.id_pedido, p.status_pedido, v.valor_total, v.valor_pago
FROM pedido p
JOIN v_pedido_pagamento v ON v.id_pedido = p.id_pedido
WHERE p.status_pedido = 'CONCLUIDO' AND ROUND(v.valor_pago, 2) <> ROUND(v.valor_total, 2);

-- AUD08 | Cancelamento/reembolso sem estorno correspondente, ou estorno sem ocorrência - esperado: 0 linhas | Atende RDN10
SELECT p.id_pedido, p.status_pedido
FROM pedido p
WHERE p.status_pedido = 'CANCELADO' AND p.modalidade <> 'LOCAL'
  AND NOT EXISTS (SELECT 1 FROM ocorrencia o WHERE o.id_pedido = p.id_pedido AND o.tipo_ocorrencia = 'REEMBOLSO')
UNION ALL
SELECT pg.id_pedido, 'ESTORNO_SEM_OCORRENCIA'
FROM pagamento pg
WHERE pg.status_pagamento = 'ESTORNADO'
  AND NOT EXISTS (SELECT 1 FROM ocorrencia o WHERE o.id_pedido = pg.id_pedido AND o.tipo_ocorrencia = 'REEMBOLSO');

-- AUD09 | Divergência entre consumo teórico (ficha técnica) e baixas lançadas no estoque - esperado: 0 linhas | Atende RDN13
SELECT c.id_pedido, c.id_insumo, c.quantidade_consumida AS teorico,
       COALESCE(-SUM(m.quantidade), 0) AS baixado
FROM v_consumo_pedido_insumo c
JOIN pedido p ON p.id_pedido = c.id_pedido AND p.data_hora_inicio_preparo IS NOT NULL
LEFT JOIN movimentacao_estoque m ON m.id_pedido = c.id_pedido AND m.id_insumo = c.id_insumo AND m.tipo_movimentacao = 'CONSUMO'
GROUP BY c.id_pedido, c.id_insumo, c.quantidade_consumida
HAVING c.quantidade_consumida <> COALESCE(-SUM(m.quantidade), 0);

-- AUD10 | Perdas e ajustes de estoque no período (acompanhamento gerencial de desperdício) | Atende RF04
SELECT i.nome AS insumo, m.tipo_movimentacao, COUNT(*) AS lancamentos, SUM(m.quantidade) AS quantidade_total
FROM movimentacao_estoque m
JOIN insumo i ON i.id_insumo = m.id_insumo
WHERE m.tipo_movimentacao IN ('PERDA', 'AJUSTE_INVENTARIO')
GROUP BY i.id_insumo, i.nome, m.tipo_movimentacao
ORDER BY quantidade_total;

-- AUD11 | Caixa em que venda + serviço dos pedidos pagos difere da soma de recebimentos (a fita exige REGISTRADO = SOMA DE RECEBIMENTOS) - esperado: 0 linhas | Atende RF14
SELECT cx.id_caixa, DATE(cx.data_hora_abertura) AS dia, x.registrado, r.soma_recebimentos
FROM caixa cx
JOIN (SELECT pp.id_caixa, SUM(t.valor_total) AS registrado
      FROM (SELECT DISTINCT id_pedido, id_caixa FROM pagamento WHERE status_pagamento = 'CONFIRMADO') pp
      JOIN v_total_pedido t ON t.id_pedido = pp.id_pedido
      GROUP BY pp.id_caixa) x ON x.id_caixa = cx.id_caixa
JOIN (SELECT id_caixa, SUM(valor) AS soma_recebimentos
      FROM pagamento WHERE status_pagamento = 'CONFIRMADO' GROUP BY id_caixa) r ON r.id_caixa = cx.id_caixa
WHERE ROUND(x.registrado, 2) <> ROUND(r.soma_recebimentos, 2);
