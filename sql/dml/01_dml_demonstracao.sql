-- =====================================================================
-- MontArarat ERP - DML de demonstração: ciclo de vida de um pedido de DELIVERY (INSERT, UPDATE, DELETE)
-- Termina em ROLLBACK para não alterar a massa. Troque ROLLBACK por COMMIT para persistir.
-- Mostra as regras: RDN01 (pago antes de produzir), preço da venda guardado no item, baixa pela ficha técnica.
-- =====================================================================
USE montararat_erp;
START TRANSACTION;

-- 1) Cliente com endereço (cadastro mínimo)
INSERT INTO pessoa (id_pessoa, cpf, nome, telefone) VALUES (9100, '99900009100', 'Cliente de Demonstracao', '11999990000');
INSERT INTO endereco (id_endereco, id_pessoa, logradouro, numero, bairro, cidade, uf, cep)
VALUES (9100, 9100, 'Rua da Demonstracao', '100', 'Sao Mateus', 'Sao Paulo', 'SP', '08000000');

-- 2) Pedido recebido pelo iFood (delivery) com dois itens (o Dilúvio não poderia ir por delivery: RDN06); o preço é copiado do cardápio no momento da venda
INSERT INTO pedido (id_pedido, id_pessoa, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9100, 9100, 6, 'IFOOD', 'DELIVERY', 'ABERTO', '2026-10-13 20:20:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario)
SELECT 9100, 1, id_produto, 2, preco_venda FROM produto WHERE nome = 'Burger';
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario)
SELECT 9100, 2, id_produto, 1, preco_venda FROM produto WHERE nome = 'Batata Simples';
INSERT INTO entrega (id_entrega, id_pedido, id_endereco, taxa_entrega, status_entrega) VALUES (9100, 9100, 9100, 6.00, 'AGUARDANDO');

-- 3) Total calculado pela view (não é armazenado): deve ser 2 x 35,00 + 27,00 + 6,00 = 103,00
SELECT id_pedido, subtotal_itens, taxa_entrega, valor_desconto, valor_total FROM v_total_pedido WHERE id_pedido = 9100;

-- 4) Pagamento online confirmado, e só então o pedido entra em produção (RDN01)
INSERT INTO pagamento (id_pagamento, id_pedido, id_forma_pagamento, id_caixa, valor, data_hora_pagamento, status_pagamento)
VALUES (9100, 9100, 5, (SELECT MAX(id_caixa) FROM caixa), 103.00, '2026-10-13 20:21:00', 'CONFIRMADO');
SELECT * FROM v_pedido_pagamento WHERE id_pedido = 9100;
UPDATE pedido SET status_pedido = 'EM_PRODUCAO', data_hora_inicio_preparo = '2026-10-13 20:22:00' WHERE id_pedido = 9100;

-- 5) Baixa automática de insumos pela ficha técnica
INSERT INTO movimentacao_estoque (id_insumo, id_pedido, id_funcionario, tipo_movimentacao, quantidade, data_hora_movimentacao, motivo)
SELECT id_insumo, id_pedido, 3, 'CONSUMO', -quantidade_consumida, '2026-10-13 20:22:00', 'Baixa automática pela ficha técnica'
FROM v_consumo_pedido_insumo WHERE id_pedido = 9100;
SELECT i.nome, m.quantidade FROM movimentacao_estoque m JOIN insumo i ON i.id_insumo = m.id_insumo WHERE m.id_pedido = 9100 ORDER BY i.nome;

-- 6) Preparo pronto, saída para entrega e conclusão
UPDATE pedido SET status_pedido = 'PRONTO', data_hora_pronto = '2026-10-13 20:35:00' WHERE id_pedido = 9100;
UPDATE entrega SET id_entregador = 3, status_entrega = 'ENTREGUE', data_hora_saida = '2026-10-13 20:40:00', data_hora_entrega = '2026-10-13 20:58:00' WHERE id_pedido = 9100;
UPDATE pedido SET status_pedido = 'CONCLUIDO', data_hora_encerramento = '2026-10-13 20:58:00' WHERE id_pedido = 9100;

-- 7) DELETE: um registro de teste sem histórico pode ser removido; um funcionário com histórico NÃO (ver teste T27)
DELETE FROM avaliacao WHERE id_pedido = 9100;

ROLLBACK;
