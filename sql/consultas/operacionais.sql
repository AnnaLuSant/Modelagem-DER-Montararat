-- =====================================================================
-- MontArarat ERP - Consultas operacionais (o que o sistema mostra ao cliente e à equipe no dia a dia)
-- Instante de referência fixo para reprodutibilidade: 2026-10-13 20:15:00 (corte da massa de dados).
-- =====================================================================
USE montararat_erp;

-- O01 | Mesas disponíveis agora (e por quê as demais não estão) | Atende RF07 e RDN03
-- Ocupada: há pedido de consumo local ainda não encerrado na mesa. Reservada: há reserva ATIVA que começa em até 2 h.
SELECT m.id_mesa, m.capacidade,
       CASE
           WHEN EXISTS (SELECT 1 FROM pedido p WHERE p.id_mesa = m.id_mesa AND p.status_pedido NOT IN ('CONCLUIDO', 'CANCELADO')) THEN 'OCUPADA'
           WHEN m.status_mesa = 'EM_LIMPEZA' THEN 'EM_LIMPEZA'
           WHEN EXISTS (SELECT 1 FROM reserva r WHERE r.id_mesa = m.id_mesa AND r.status_reserva = 'ATIVA'
                         AND r.data_hora_inicio <= '2026-10-13 22:15:00' AND r.data_hora_fim > '2026-10-13 20:15:00') THEN 'RESERVADA'
           ELSE 'DISPONIVEL'
       END AS situacao_agora
FROM mesa m
ORDER BY m.id_mesa;

-- O02 | Fila de produção com a estimativa mostrada ao cliente (tempo base + pedidos à frente) | Atende RF08, RDN09
SELECT e.id_pedido, e.prioridade, e.tempo_base_min, e.pedidos_a_frente
FROM v_estimativa_preparo e
ORDER BY e.prioridade, e.pedidos_a_frente;

-- O03 | Especificações do produto: peso e ingredientes (ficha técnica) | Atende RF09
SELECT pr.nome AS produto, pr.descricao, pr.peso_g, i.nome AS ingrediente, ft.quantidade, i.unidade_medida
FROM produto pr
JOIN ficha_tecnica ft ON ft.id_produto = pr.id_produto
JOIN insumo i         ON i.id_insumo = ft.id_insumo
WHERE pr.nome = 'Dilúvio'
ORDER BY i.nome;

-- O04 | Favoritos de um cliente, do mais recente ao mais antigo | Atende RF18 (antigo RNF02)
SELECT pr.nome AS produto, f.data_hora_salvo
FROM favorito f
JOIN produto pr ON pr.id_produto = f.id_produto
WHERE f.id_pessoa = 10
ORDER BY f.data_hora_salvo DESC;

-- O05 | Itens de um pedido na ordem em que foram adicionados (o "carrinho") | Atende RF19 (antigo RNF05)
SELECT ip.numero_item, pr.nome AS produto, ip.quantidade, ip.preco_unitario, ip.observacao
FROM item_pedido ip
JOIN produto pr ON pr.id_produto = ip.id_produto
WHERE ip.id_pedido = 1
ORDER BY ip.numero_item;

-- O06 | Pedidos em aberto que a cozinha deve produzir agora, na ordem de prioridade | Atende RF01, RDN09
SELECT f.id_pedido, f.canal, f.modalidade, f.status_pedido, f.data_hora_pedido, f.prioridade
FROM v_fila_producao f
ORDER BY f.prioridade, f.data_hora_pedido;

-- O07 | Quanto o estoque atual permite produzir de cada produto (porções) | Atende RDN04
SELECT nome, disponivel, porcoes_possiveis_estoque
FROM v_disponibilidade_produto
ORDER BY porcoes_possiveis_estoque;
