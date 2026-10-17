-- =====================================================================
-- MontArarat ERP - Testes de restrições e regras de negócio (RNF07: integridade garantida pelo SGBD)
-- Cada teste roda dentro de uma transação que termina em ROLLBACK (não altera a massa).
-- Marcador: "-- TESTE Txx | esperado: ERRO|OK | <regra/restrição que deve atuar>"
-- Em ERRO, a execução do bloco deve ser interrompida por CHECK, FK, UNIQUE ou trigger.
-- No MySQL Workbench/CLI use:  mysql --force < 02_testes_restricoes.sql  (continua após cada erro).
-- Executar DEPOIS de ddl/01..04 e dados/01.
-- =====================================================================
USE montararat_erp;

-- TESTE T01 | esperado: ERRO | ck_pessoa_cpf (CPF com 10 dígitos)
START TRANSACTION;
INSERT INTO pessoa (id_pessoa, cpf, nome) VALUES (9001, '1234567890', 'CPF invalido');
ROLLBACK;

-- TESTE T02 | esperado: ERRO | uq_pessoa_cpf (CPF repetido)
START TRANSACTION;
INSERT INTO pessoa (id_pessoa, cpf, nome) VALUES (9001, '99900000010', 'CPF repetido');
ROLLBACK;

-- TESTE T03 | esperado: ERRO | ck_pessoa_email
START TRANSACTION;
INSERT INTO pessoa (id_pessoa, nome, email) VALUES (9001, 'Email invalido', 'semarroba');
ROLLBACK;

-- TESTE T04 | esperado: ERRO | ck_produto_preco (preço não positivo)
START TRANSACTION;
INSERT INTO produto (id_produto, nome, id_categoria_produto, preco_venda, tempo_preparo_min, disponivel, montagem_especial)
VALUES (9001, 'Produto gratis', 1, 0, 5, 1, 0);
ROLLBACK;

-- TESTE T05 | esperado: ERRO | ck_pedido_canal_modalidade (salão só LOCAL)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 8, 'SALAO', 'DELIVERY', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
ROLLBACK;

-- TESTE T06 | esperado: ERRO | ck_pedido_canal_modalidade (iFood nunca é LOCAL)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'IFOOD', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
ROLLBACK;

-- TESTE T07 | esperado: ERRO | ck_pedido_desconto_autorizado RDN11 (desconto exige autorizador)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 5.00, 0);
ROLLBACK;

-- TESTE T08 | esperado: ERRO | RDN11 trg_pedido_bi (autorizador sem permissão: atendente id 7)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, id_funcionario_autorizador, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 7, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 5.00, 0);
ROLLBACK;

-- TESTE T09 | esperado: ERRO | ck_pedido_encerramento (CONCLUIDO exige data de encerramento)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, data_hora_inicio_preparo, data_hora_pronto, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'CONCLUIDO', '2026-10-13 20:00:00', '2026-10-13 20:01:00', '2026-10-13 20:10:00', 0, 0);
ROLLBACK;

-- TESTE T10 | esperado: ERRO | ck_pedido_ordem_pronto (pronto antes do início do preparo)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, data_hora_inicio_preparo, data_hora_pronto, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'PRONTO', '2026-10-13 20:00:00', '2026-10-13 20:10:00', '2026-10-13 20:05:00', 0, 0);
ROLLBACK;

-- TESTE T11 | esperado: ERRO | RDN12 trg_compra_bi (atendente não pode comprar insumos)
START TRANSACTION;
INSERT INTO compra (id_compra, id_fornecedor, id_funcionario, data_hora_compra, status_compra)
VALUES (9001, 1, 6, '2026-10-13 10:00:00', 'PEDIDA');
ROLLBACK;

-- TESTE T12 | esperado: OK | gerente pode comprar (controle positivo do T11)
START TRANSACTION;
INSERT INTO compra (id_compra, id_fornecedor, id_funcionario, data_hora_compra, status_compra)
VALUES (9001, 1, 2, '2026-10-13 10:00:00', 'PEDIDA');
ROLLBACK;

-- TESTE T13 | esperado: ERRO | RDN06 trg_item_pedido_bi (montagem especial não vai por delivery)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'DELIVERY', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 4, 1, 41.00);
ROLLBACK;

-- TESTE T14 | esperado: OK | montagem especial é aceita no salão/balcão local (controle positivo do T13)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 4, 1, 41.00);
ROLLBACK;

-- TESTE T15 | esperado: ERRO | RDN04 trg_item_pedido_bi (produto indisponível não pode ser vendido)
START TRANSACTION;
UPDATE produto SET disponivel = 0 WHERE id_produto = 9;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 9, 1, 19.00);
ROLLBACK;

-- TESTE T16 | esperado: ERRO | RDN01 trg_pedido_bu (retirada/delivery só entra em produção após pagamento)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'RETIRADA', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 1, 1, 35.00);
UPDATE pedido SET status_pedido = 'EM_PRODUCAO', data_hora_inicio_preparo = '2026-10-13 20:02:00' WHERE id_pedido = 9001;
ROLLBACK;

-- TESTE T17 | esperado: OK | com pagamento confirmado integral, a produção é permitida (controle positivo do T16)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'RETIRADA', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 1, 1, 35.00);
INSERT INTO pagamento (id_pagamento, id_pedido, id_forma_pagamento, id_caixa, valor, data_hora_pagamento, status_pagamento)
VALUES (9001, 9001, 1, 1, 35.00, '2026-10-13 20:01:00', 'CONFIRMADO');
UPDATE pedido SET status_pedido = 'EM_PRODUCAO', data_hora_inicio_preparo = '2026-10-13 20:02:00' WHERE id_pedido = 9001;
ROLLBACK;

-- TESTE T18 | esperado: ERRO | ck_pagamento_valor (valor deve ser positivo)
START TRANSACTION;
INSERT INTO pagamento (id_pagamento, id_pedido, id_forma_pagamento, id_caixa, valor, data_hora_pagamento, status_pagamento)
VALUES (9001, 1, 1, 1, 0, '2026-10-13 20:01:00', 'CONFIRMADO');
ROLLBACK;

-- TESTE T19 | esperado: ERRO | fk_item_pedido_produto (produto inexistente)
START TRANSACTION;
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (1, 99, 9999, 1, 10.00);
ROLLBACK;

-- TESTE T20 | esperado: ERRO | pk_item_pedido (item repetido no mesmo pedido)
START TRANSACTION;
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (1, 1, 2, 1, 35.00);
ROLLBACK;

-- TESTE T21 | esperado: ERRO | ck_ocorrencia_politica RDN10 (troca após consumo só por erro da casa)
START TRANSACTION;
INSERT INTO ocorrencia (id_ocorrencia, id_pedido, id_funcionario_autorizador, tipo_ocorrencia, causa, houve_consumo, valor_reembolso, descricao, data_hora_ocorrencia)
VALUES (9001, 1, 2, 'TROCA', 'INSATISFACAO', 1, NULL, 'Cliente nao gostou apos comer', '2026-09-22 21:00:00');
ROLLBACK;

-- TESTE T22 | esperado: OK | troca após consumo por erro da casa é permitida (controle positivo do T21)
START TRANSACTION;
INSERT INTO ocorrencia (id_ocorrencia, id_pedido, id_funcionario_autorizador, tipo_ocorrencia, causa, houve_consumo, valor_reembolso, descricao, data_hora_ocorrencia)
VALUES (9001, 1, 2, 'TROCA', 'ERRO_DA_CASA', 1, NULL, 'Item errado entregue', '2026-09-22 21:00:00');
ROLLBACK;

-- TESTE T23 | esperado: ERRO | RDN10 trg_ocorrencia_bi (autorização por cargo sem permissão)
START TRANSACTION;
INSERT INTO ocorrencia (id_ocorrencia, id_pedido, id_funcionario_autorizador, tipo_ocorrencia, causa, houve_consumo, valor_reembolso, descricao, data_hora_ocorrencia)
VALUES (9001, 1, 6, 'TROCA', 'ERRO_DA_CASA', 0, NULL, 'Atendente tentando autorizar', '2026-09-22 21:00:00');
ROLLBACK;

-- TESTE T24 | esperado: ERRO | ck_ocorrencia_reembolso (reembolso exige valor)
START TRANSACTION;
INSERT INTO ocorrencia (id_ocorrencia, id_pedido, id_funcionario_autorizador, tipo_ocorrencia, causa, houve_consumo, valor_reembolso, descricao, data_hora_ocorrencia)
VALUES (9001, 1, 2, 'REEMBOLSO', 'DESISTENCIA', 0, NULL, 'Reembolso sem valor', '2026-09-22 21:00:00');
ROLLBACK;

-- TESTE T25 | esperado: ERRO | RDN13 trg_movimentacao_bi (saída não pode deixar saldo negativo)
START TRANSACTION;
INSERT INTO movimentacao_estoque (id_movimentacao, id_insumo, id_funcionario, tipo_movimentacao, quantidade, data_hora_movimentacao, motivo)
VALUES (99001, 1, 3, 'PERDA', -9999999, '2026-10-13 21:00:00', 'Perda absurda');
ROLLBACK;

-- TESTE T26 | esperado: ERRO | ck_reserva_periodo (fim deve ser posterior ao início)
START TRANSACTION;
INSERT INTO reserva (id_reserva, id_mesa, nome_contato, id_funcionario, data_hora_inicio, data_hora_fim, status_reserva)
VALUES (9001, 1, 'Teste', 6, '2026-10-20 20:00:00', '2026-10-20 19:00:00', 'ATIVA');
ROLLBACK;

-- TESTE T27 | esperado: ERRO | fk_pedido_funcionario (não se apaga funcionário que já atendeu pedidos)
START TRANSACTION;
DELETE FROM funcionario WHERE id_funcionario = 6;
ROLLBACK;

-- TESTE T28 | esperado: ERRO | uq_entrega_pedido (um pedido tem no máximo uma entrega)
START TRANSACTION;
INSERT INTO entrega (id_entrega, id_pedido, id_endereco, taxa_entrega, status_entrega)
SELECT 9001, e.id_pedido, e.id_endereco, 6.00, 'AGUARDANDO' FROM entrega e WHERE e.id_entrega = 1;
ROLLBACK;

-- TESTE T29 | esperado: ERRO | ck_avaliacao_* (avaliação com nota fora de 1..5)
START TRANSACTION;
INSERT INTO avaliacao (id_avaliacao, id_pedido, tipo_avaliacao, nota, data_hora_avaliacao)
VALUES (9001, 1, 'AVALIACAO', 7, '2026-10-13 21:00:00');
ROLLBACK;

-- TESTE T30 | esperado: ERRO | RDN02 trg_reserva_bi (reserva sobreposta na mesma mesa)
START TRANSACTION;
INSERT INTO reserva (id_reserva, id_mesa, nome_contato, id_funcionario, data_hora_inicio, data_hora_fim, status_reserva)
VALUES (9001, 5, 'Sobreposta', 6, '2026-10-16 20:30:00', '2026-10-16 21:30:00', 'ATIVA');
ROLLBACK;

-- TESTE T31 | esperado: OK | reserva no mesmo horário em OUTRA mesa é aceita (controle positivo do T30)
START TRANSACTION;
INSERT INTO reserva (id_reserva, id_mesa, nome_contato, id_funcionario, data_hora_inicio, data_hora_fim, status_reserva)
VALUES (9001, 4, 'Outra mesa', 6, '2026-10-16 20:30:00', '2026-10-16 21:30:00', 'ATIVA');
ROLLBACK;

-- TESTE T32 | esperado: ERRO | RDN03 trg_mesa_bu (mesa ocupada não vira livre sem limpeza)
START TRANSACTION;
UPDATE mesa SET status_mesa = 'LIVRE' WHERE id_mesa = (SELECT MIN(id_mesa) FROM pedido WHERE id_mesa IS NOT NULL AND status_pedido NOT IN ('CONCLUIDO', 'CANCELADO'));
ROLLBACK;

-- TESTE T33 | esperado: OK | mesa ocupada -> em limpeza -> livre (controle positivo do T32)
START TRANSACTION;
UPDATE mesa SET status_mesa = 'EM_LIMPEZA' WHERE id_mesa = (SELECT MIN(id_mesa) FROM pedido WHERE id_mesa IS NOT NULL AND status_pedido NOT IN ('CONCLUIDO', 'CANCELADO'));
UPDATE mesa SET status_mesa = 'LIVRE' WHERE id_mesa = (SELECT MIN(id_mesa) FROM pedido WHERE id_mesa IS NOT NULL AND status_pedido NOT IN ('CONCLUIDO', 'CANCELADO'));
ROLLBACK;

-- TESTE T34 | esperado: ERRO | RDN03 trg_mesa_bu (limpar mesa que nem foi usada)
START TRANSACTION;
UPDATE mesa SET status_mesa = 'EM_LIMPEZA' WHERE id_mesa = (SELECT m.id_mesa FROM (SELECT MIN(id_mesa) AS id_mesa FROM mesa WHERE status_mesa = 'LIVRE') m);
ROLLBACK;

-- TESTE T35 | esperado: ERRO | RDN11 trg_pedido_bi (aniversário sem documento conferido)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_pessoa, id_funcionario, id_promocao, id_funcionario_autorizador, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 10, 6, 1, 2, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 3.00, 0);
ROLLBACK;

-- TESTE T36 | esperado: OK | aniversário com documento conferido e autorização é aceito (controle positivo do T35)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_pessoa, id_funcionario, id_promocao, id_funcionario_autorizador, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 10, 6, 1, 2, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 3.00, 1);
ROLLBACK;

-- TESTE T37 | esperado: ERRO | RDN15 trg_pedido_bu (concluir pedido sem pagamento integral)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, data_hora_inicio_preparo, data_hora_pronto, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'PRONTO', '2026-10-13 20:00:00', '2026-10-13 20:01:00', '2026-10-13 20:10:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 1, 1, 35.00);
UPDATE pedido SET status_pedido = 'CONCLUIDO', data_hora_encerramento = '2026-10-13 20:30:00' WHERE id_pedido = 9001;
ROLLBACK;

-- TESTE T38 | esperado: ERRO | RDN04 trg_item_pedido_bi (quantidade acima do que o estoque permite produzir)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_pedido (id_pedido, numero_item, id_produto, quantidade, preco_unitario) VALUES (9001, 1, 1, 9999, 35.00);
ROLLBACK;

-- TESTE T39 | esperado: ERRO | pk_favorito (favorito repetido do mesmo cliente)
START TRANSACTION;
INSERT INTO favorito (id_pessoa, id_produto, data_hora_salvo)
SELECT id_pessoa, id_produto, '2026-10-13 20:00:00' FROM favorito WHERE id_pessoa = 10 AND id_produto = (SELECT MIN(id_produto) FROM favorito WHERE id_pessoa = 10);
ROLLBACK;

-- TESTE T40 | esperado: ERRO | RDN06 trg_item_combo_pedido_bi (combo com produto de montagem especial não vai por delivery)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'DELIVERY', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_combo_pedido (id_pedido, numero_item, id_combo, quantidade, preco_unitario) VALUES (9001, 1, 4, 1, 49.00);
ROLLBACK;

-- TESTE T41 | esperado: OK | combo sem montagem especial vai por delivery (controle positivo do T40)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'DELIVERY', 'ABERTO', '2026-10-13 20:00:00', 0, 0);
INSERT INTO item_combo_pedido (id_pedido, numero_item, id_combo, quantidade, preco_unitario) VALUES (9001, 1, 1, 1, 43.00);
ROLLBACK;

-- TESTE T42 | esperado: ERRO | ck_pedido_servico (taxa de serviço de mesa em pedido sem mesa)
START TRANSACTION;
INSERT INTO pedido (id_pedido, id_funcionario, canal, modalidade, status_pedido, data_hora_pedido, valor_desconto, valor_servico, documento_conferido)
VALUES (9001, 6, 'BALCAO', 'LOCAL', 'ABERTO', '2026-10-13 20:00:00', 0, 3.50, 0);
ROLLBACK;

-- TESTE T43 | esperado: ERRO | ck_caixa_fechamento (fechamento sem valor informado)
START TRANSACTION;
INSERT INTO caixa (id_caixa, terminal, id_funcionario_abertura, id_funcionario_fechamento, data_hora_abertura, data_hora_fechamento, valor_abertura, valor_fechamento)
VALUES (9001, 'Mont Ararat Delivery', 6, 6, '2026-10-13 17:30:00', '2026-10-13 23:00:00', 150.00, NULL);
ROLLBACK;
