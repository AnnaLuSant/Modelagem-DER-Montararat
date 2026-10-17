-- =====================================================================
-- MontArarat ERP - Script 03: views (informações derivadas)
-- RNF08 - Por que views: valores derivados (total do pedido, saldo de estoque, consumo)
-- NÃO são armazenados em tabelas; isso evita dependências transitivas (3FN)
-- e divergência entre o dado e o seu cálculo.
-- =====================================================================
SET NAMES utf8mb4;
USE montararat_erp;

-- Total do pedido = itens + combos + taxa de entrega - desconto
CREATE VIEW v_total_pedido AS
SELECT p.id_pedido,
       COALESCE(i.subtotal_itens, 0)  AS subtotal_itens,
       COALESCE(c.subtotal_combos, 0) AS subtotal_combos,
       COALESCE(e.taxa_entrega, 0)    AS taxa_entrega,
       p.valor_desconto,
       COALESCE(i.subtotal_itens, 0) + COALESCE(c.subtotal_combos, 0)
         + COALESCE(e.taxa_entrega, 0) - p.valor_desconto AS valor_total
FROM pedido p
LEFT JOIN (SELECT id_pedido, SUM(quantidade * preco_unitario) AS subtotal_itens
           FROM item_pedido GROUP BY id_pedido) i ON i.id_pedido = p.id_pedido
LEFT JOIN (SELECT id_pedido, SUM(quantidade * preco_unitario) AS subtotal_combos
           FROM item_combo_pedido GROUP BY id_pedido) c ON c.id_pedido = p.id_pedido
LEFT JOIN entrega e ON e.id_pedido = p.id_pedido;

-- Situação de pagamento do pedido (só pagamentos CONFIRMADOS contam)
CREATE VIEW v_pedido_pagamento AS
SELECT t.id_pedido,
       t.valor_total,
       COALESCE(pg.valor_pago, 0) AS valor_pago,
       CASE
           WHEN ROUND(COALESCE(pg.valor_pago, 0), 2) >= ROUND(t.valor_total, 2) THEN 'PAGO'
           WHEN COALESCE(pg.valor_pago, 0) > 0 THEN 'PARCIAL'
           ELSE 'NAO_PAGO'
       END AS situacao_pagamento
FROM v_total_pedido t
LEFT JOIN (SELECT id_pedido, SUM(valor) AS valor_pago
           FROM pagamento WHERE status_pagamento = 'CONFIRMADO'
           GROUP BY id_pedido) pg ON pg.id_pedido = t.id_pedido;

-- Consumo teórico de insumos por pedido: item x ficha técnica (e combo x item_combo x ficha técnica)
CREATE VIEW v_consumo_pedido_insumo AS
SELECT x.id_pedido, x.id_insumo, SUM(x.quantidade) AS quantidade_consumida
FROM (
    SELECT ip.id_pedido, ft.id_insumo, ip.quantidade * ft.quantidade AS quantidade
    FROM item_pedido ip
    JOIN ficha_tecnica ft ON ft.id_produto = ip.id_produto
    UNION ALL
    SELECT icp.id_pedido, ft.id_insumo, icp.quantidade * ic.quantidade * ft.quantidade AS quantidade
    FROM item_combo_pedido icp
    JOIN item_combo ic ON ic.id_combo = icp.id_combo
    JOIN ficha_tecnica ft ON ft.id_produto = ic.id_produto
) x
GROUP BY x.id_pedido, x.id_insumo;

-- Saldo de estoque por insumo = soma das movimentações (RF04)
CREATE VIEW v_saldo_estoque AS
SELECT i.id_insumo, i.nome, i.marca, i.unidade_medida, i.estoque_minimo,
       COALESCE(SUM(m.quantidade), 0) AS saldo_atual,
       CASE WHEN COALESCE(SUM(m.quantidade), 0) < i.estoque_minimo
            THEN 'ABAIXO_DO_MINIMO' ELSE 'OK' END AS situacao
FROM insumo i
LEFT JOIN movimentacao_estoque m ON m.id_insumo = i.id_insumo
GROUP BY i.id_insumo, i.nome, i.marca, i.unidade_medida, i.estoque_minimo;

-- Quantas unidades de cada produto o estoque atual permite produzir (RDN04)
CREATE VIEW v_disponibilidade_produto AS
SELECT p.id_produto, p.nome, p.disponivel,
       MIN(FLOOR(s.saldo_atual / ft.quantidade)) AS porcoes_possiveis_estoque
FROM produto p
JOIN ficha_tecnica ft ON ft.id_produto = p.id_produto
JOIN v_saldo_estoque s ON s.id_insumo = ft.id_insumo
GROUP BY p.id_produto, p.nome, p.disponivel;

-- RF17/RDN09 - Fila de produção: pedidos locais têm prioridade 1; os demais, prioridade 2 (FIFO dentro da prioridade)
CREATE VIEW v_fila_producao AS
SELECT p.id_pedido, p.canal, p.modalidade, p.status_pedido, p.data_hora_pedido,
       CASE WHEN p.modalidade = 'LOCAL' THEN 1 ELSE 2 END AS prioridade
FROM pedido p
WHERE p.status_pedido IN ('ABERTO', 'EM_PRODUCAO');

-- Tempo base do pedido = maior tempo padrão de preparo entre seus produtos (RF08)
CREATE VIEW v_tempo_base_pedido AS
SELECT x.id_pedido, MAX(x.tempo_preparo_min) AS tempo_base_min
FROM (
    SELECT ip.id_pedido, pr.tempo_preparo_min
    FROM item_pedido ip
    JOIN produto pr ON pr.id_produto = ip.id_produto
    UNION ALL
    SELECT icp.id_pedido, pr.tempo_preparo_min
    FROM item_combo_pedido icp
    JOIN item_combo ic ON ic.id_combo = icp.id_combo
    JOIN produto pr ON pr.id_produto = ic.id_produto
) x
GROUP BY x.id_pedido;

-- Estimativa de preparo: informações usadas = tempo base dos produtos + pedidos à frente na fila (RF08)
CREATE VIEW v_estimativa_preparo AS
SELECT f.id_pedido, f.prioridade, t.tempo_base_min,
       (SELECT COUNT(*) FROM v_fila_producao f2
         WHERE f2.prioridade < f.prioridade
            OR (f2.prioridade = f.prioridade AND f2.data_hora_pedido < f.data_hora_pedido)) AS pedidos_a_frente
FROM v_fila_producao f
LEFT JOIN v_tempo_base_pedido t ON t.id_pedido = f.id_pedido;

-- Custo médio ponderado por unidade de medida de cada insumo (compras não canceladas)
CREATE VIEW v_custo_medio_insumo AS
SELECT ic.id_insumo,
       SUM(ic.valor_total) / SUM(ic.quantidade) AS custo_medio_unitario
FROM item_compra ic
JOIN compra c ON c.id_compra = ic.id_compra
WHERE c.status_compra <> 'CANCELADA'
GROUP BY ic.id_insumo;

-- Custo teórico e margem bruta de cada produto, pela ficha técnica
CREATE VIEW v_custo_produto AS
SELECT p.id_produto, p.nome, p.preco_venda,
       SUM(ft.quantidade * cm.custo_medio_unitario) AS custo_teorico,
       p.preco_venda - SUM(ft.quantidade * cm.custo_medio_unitario) AS margem_bruta
FROM produto p
JOIN ficha_tecnica ft ON ft.id_produto = p.id_produto
JOIN v_custo_medio_insumo cm ON cm.id_insumo = ft.id_insumo
GROUP BY p.id_produto, p.nome, p.preco_venda;
