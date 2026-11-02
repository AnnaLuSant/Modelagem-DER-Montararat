USE montararat_banco;

-- MASSA DE DADOS ERRADA

INSERT INTO Pessoa (cpf, nome) VALUES
('11111111111', 'João Silva'),
('22222222222', 'Maria Souza'),
('33333333333', 'Carlos Oliveira');

INSERT INTO Cargo (nome_cargo, salario_base) VALUES
('Atendente', 1800.00),
('Cozinheiro', 2200.00),
('Gerente', 3500.00);

INSERT INTO Funcionario (cpf, id_cargo, data_admissao, status_funcionario) VALUES
('11111111111', 1, '2026-01-10', 'ATIVO'),
('22222222222', 2, '2026-02-15', 'ATIVO'),
('33333333333', 3, '2026-03-20', 'INATIVO');

INSERT INTO Fornecedor (cnpj, nome) VALUES
('12345678000101', 'Fornecedor Alimentos LTDA'),
('98765432000199', 'Distribuidora Mont Ararat');

INSERT INTO Endereco (cep, logradouro, numero, complemento) VALUES
('13480000', 'Rua das Flores', '100', NULL),
('13481000', 'Avenida Central', '200', 'Sala 3');

INSERT INTO PessoaEndereco (cpf, id_endereco) VALUES
('11111111111', 1),
('22222222222', 2);

INSERT INTO Telefone (cpf, ddd, numero) VALUES
('11111111111', '19', '999999999'),
('22222222222', '19', '988888888');

INSERT INTO Telefone (id_fornecedor, ddd, numero) VALUES
(1, '19', '977777777');

INSERT INTO Email (cpf, email, tipo) VALUES
('11111111111', 'joao@email.com', 'PESSOAL'),
('22222222222', 'maria@email.com', 'CORPORATIVO');

INSERT INTO Email (id_fornecedor, email, tipo) VALUES
(1, 'contato@fornecedor.com', 'CORPORATIVO');

INSERT INTO FormaPagamento (tipo) VALUES
('PIX'),
('CARTAO DE CREDITO'),
('CARTAO DE DEBITO'),
('DINHEIRO');

INSERT INTO Categoria (nome) VALUES
('BEBIDA'),
('LANCHE'),
('ACOMPANHAMENTO'),
('PORCAO'),
('SOBREMESA');

INSERT INTO Produto
(id_categoria, nome, preco_base, descricao, montagem_especial)
VALUES
(1, 'Refrigerante', 7.00, 'Refrigerante lata', FALSE),
(2, 'Hambúrguer Mont Ararat', 32.90, 'Hambúrguer artesanal', TRUE),
(3, 'Batata Frita', 18.00, 'Porção de batata', FALSE),
(5, 'Brownie', 12.00, 'Brownie de chocolate', FALSE);

INSERT INTO Combo (nome, preco_combo, descricao) VALUES
('Combo Clássico', 45.00, 'Hambúrguer + batata + bebida'),
('Combo Família', 85.00, 'Combo para compartilhar');

INSERT INTO ItemCombo (id_combo, id_produto, quantidade_prod) VALUES
(1, 2, 1),
(1, 3, 1),
(1, 1, 1),
(2, 2, 2);

INSERT INTO Insumo (nome, unidade_medida, quantidade_minima) VALUES
('Carne bovina', 'KG', 10.00),
('Pão', 'UNI', 30.00),
('Queijo', 'KG', 5.00),
('Batata', 'KG', 8.00),
('Refrigerante lata', 'UNI', 20.00);

INSERT INTO FichaTecnica
(id_produto, id_insumo, quantidade_necessaria)
VALUES
(2, 1, 0.180),
(2, 2, 1.000),
(2, 3, 0.050),
(3, 4, 0.200),
(1, 5, 1.000);

INSERT INTO Compra
(id_fornecedor, id_funcionario, data_compra, status_compra)
VALUES
(1, 1, '2026-10-20 10:00:00', 'RECEBIDA'),
(2, 2, '2026-10-21 14:30:00', 'SOLICITADO');

INSERT INTO ItemCompra
(id_compra, id_insumo, quantidade_solicitada, preco_unitario)
VALUES
(1, 1, 50.00, 28.50),
(1, 2, 100.00, 1.20),
(2, 4, 30.00, 6.50);

INSERT INTO Lote
(id_insumo, id_item_compra, numero_lote, data_validade, data_recebimento,
 quantidade_inicial, status_lote)
VALUES
(1, 1, 'CARNE-001', '2026-12-20', '2026-10-21 09:00:00', 50.00, 'DISPONIVEL'),
(2, 2, 'PAO-001', '2026-11-20', '2026-10-21 09:10:00', 100.00, 'DISPONIVEL'),
(4, 3, 'BATATA-001', '2026-12-01', '2026-10-22 10:00:00', 30.00, 'DISPONIVEL');

INSERT INTO Mesa (capacidade, numero, status_mesa) VALUES
(2, '01', 'LIVRE'),
(4, '02', 'LIVRE'),
(6, '03', 'EM LIMPEZA');

INSERT INTO Reserva
(cpf, id_funcionario, quantidade_pessoas, data_hora_inicio, status)
VALUES
('11111111111', 1, 2, '2026-11-05 19:00:00', 'PENDENTE');

INSERT INTO ReservaMesa (id_reserva, id_mesa) VALUES
(1, 1);

INSERT INTO Atendimento
(id_funcionario, id_reserva, hora_chegada, hora_saida, qtd_pessoas)
VALUES
(1, 1, '2026-11-05 18:55:00', NULL, 2);

INSERT INTO AtendimentoMesa (id_atendimento, id_mesa) VALUES
(1, 1);

INSERT INTO Caixa
(id_funcionario_abertura, data_abertura, tipo_caixa, valor_abertura, status_caixa)
VALUES
(1, '2026-11-01 08:00:00', 'LOCAL', 200.00, 'ABERTO');

INSERT INTO Pedido
(cpf, id_mesa, id_funcionario, id_atendimento,
 data_hora, status_pedido, modalidade,
 canal_origem, data_hora_inicio_producao, data_hora_fim_producao)
VALUES
('11111111111', 1, 1, 1,
 '2026-11-05 19:00:00', 'CONCLUIDO', 'LOCAL',
 NULL, '2026-11-05 19:05:00', '2026-11-05 19:20:00');

INSERT INTO Pedido
(cpf, id_mesa, id_funcionario, id_atendimento,
 data_hora, status_pedido, modalidade, canal_origem)
VALUES
('22222222222', NULL, NULL, NULL,
 '2026-11-05 20:00:00', 'PENDENTE', 'ENTREGA', 'IFOOD');

INSERT INTO ItemPedido
(id_pedido, id_produto, quantidade, preco_unitario, observacao)
VALUES
(1, 2, 2, 32.90, NULL),
(1, 3, 1, 18.00, 'Pouco sal');

INSERT INTO ItemComboPedido
(id_pedido, id_combo, quantidade, preco_unitario, observacao)
VALUES
(1, 1, 1, 45.00, NULL);

INSERT INTO Pagamento
(id_pedido, id_caixa, id_forma_pagamento,
 data_hora, status_pagamento, valor_total, referencia_externa)
VALUES
(1, 1, 1, '2026-11-05 19:30:00', 'APROVADO', 96.80, NULL);

INSERT INTO Entregador
(id_funcionario, tipo_vinculo, plataforma, identificador_externo)
VALUES
(NULL, 'EXTERNO', 'IFOOD', 'A001'),
(2, 'LOCAL', NULL, NULL);

INSERT INTO Entrega
(id_pedido, id_entregador, id_endereco, status_entrega,
 taxa_entrega, data_saida, data_chegada)
VALUES
(2, 1, 2, 'ENTREGUE', 8.00,
 '2026-11-05 20:15:00', '2026-11-05 20:45:00');

INSERT INTO EventoEntrega
(id_entrega, origem_atualizacao, data_hora, status_entrega)
VALUES
(1, 'IFOOD', '2026-11-05 20:10:00', 'PENDENTE'),
(1, 'IFOOD', '2026-11-05 20:15:00', 'EM_TRANSITO'),
(1, 'IFOOD', '2026-11-05 20:45:00', 'ENTREGUE');

INSERT INTO Avaliacao
(id_pedido, comentario, data, nota)
VALUES
(1, 'Pedido muito bom.', '2026-11-05', 5);

INSERT INTO Ocorrencia
(id_pedido, id_funcionario_responsavel, classificacao,
 descricao, consumo_produto, data_hora, status_ocorrencia)
VALUES
(1, 1, 'QUALIDADE_PRODUTO',
 'Produto chegou com qualidade abaixo do esperado.',
 'CONSUMO_PARCIAL', '2026-11-05 20:00:00', 'RESOLVIDA');

INSERT INTO Reembolso
(id_ocorrencia, id_pagamento, valor_reembolso, data_hora, status_reembolso)
VALUES
(1, 1, 10.00, '2026-11-05 20:10:00', 'APROVADO');

INSERT INTO Promocao
(nome, data_inicio, data_fim, status_promocao, tipo)
VALUES
('Promoção de Novembro', '2026-11-01', '2026-11-30', 'ATIVA', 'PERCENTUAL');

INSERT INTO PromocaoProduto
(id_produto, id_promocao, percentual_desconto, quantidade_limite)
VALUES
(2, 1, 10.00, 20);

INSERT INTO PromocaoCombo
(id_combo, id_promocao, percentual_desconto, quantidade_limite)
VALUES
(1, 1, 15.00, 10);

INSERT INTO MovimentacaoEstoque
(id_lote, id_funcionario, id_pedido, tipo_movimentacao,
 quantidade, data_hora, motivo)
VALUES
(1, 1, NULL, 'ENTRADA', 50.00, '2026-10-21 09:00:00', 'Entrada da compra'),
(1, 1, 1, 'CONSUMO', 0.36, '2026-11-05 19:20:00', 'Produção do pedido'),
(2, 1, 1, 'CONSUMO', 2.00, '2026-11-05 19:20:00', 'Produção do pedido');

INSERT INTO Despesa
(id_funcionario, id_forma_pagamento, id_compra, descricao,
 valor, data_vencimento, data_pagamento, status_despesa)
VALUES
(1, 4, 1, 'Compra de insumos', 1500.00,
 '2026-11-10', '2026-10-25', 'PAGA');


-- 2. TESTES ERRADOS

-- PESSOA

-- ERRO 01: CPF duplicado (PRIMARY KEY)
START TRANSACTION;
INSERT INTO Pessoa (cpf, nome)
VALUES ('11111111111', 'CPF Duplicado');
ROLLBACK;

-- ERRO 02: nome NULL (NOT NULL)
START TRANSACTION;
INSERT INTO Pessoa (cpf, nome)
VALUES ('44444444444', NULL);
ROLLBACK;

-- ERRO 03: CPF inexistente
INSERT INTO Pessoa (cpf, nome)
VALUES ('123', 'CPF com tamanho inadequado');

-- CARGO

-- ERRO 04: salário negativo (CHECK)
START TRANSACTION;
INSERT INTO Cargo (nome_cargo, salario_base)
VALUES ('Cargo Inválido', -500.00);
ROLLBACK;

-- ERRO 05: nome NULL (NOT NULL)
START TRANSACTION;
INSERT INTO Cargo (nome_cargo, salario_base)
VALUES (NULL, 1500.00);
ROLLBACK;

-- FUNCIONARIO

-- ERRO 06: CPF que não existe em Pessoa (FOREIGN KEY)
START TRANSACTION;
INSERT INTO Funcionario (cpf, id_cargo, data_admissao)
VALUES ('99999999999', 1, '2026-11-01');
ROLLBACK;

-- ERRO 07: cargo inexistente (FOREIGN KEY)
START TRANSACTION;
INSERT INTO Funcionario (cpf, id_cargo, data_admissao)
VALUES ('33333333333', 999, '2026-11-01');
ROLLBACK;

-- ERRO 08: status fora do ENUM
START TRANSACTION;
INSERT INTO Funcionario (cpf, id_cargo, data_admissao, status_funcionario)
VALUES ('33333333333', 1, '2026-11-01', 'DEMISSAO');
ROLLBACK;


-- FORNECEDOR

-- ERRO 09: CNPJ duplicado (UNIQUE)
START TRANSACTION;
INSERT INTO Fornecedor (cnpj, nome)
VALUES ('12345678000101', 'Fornecedor Duplicado');
ROLLBACK;

-- ERRO 10: nome NULL
START TRANSACTION;
INSERT INTO Fornecedor (cnpj, nome)
VALUES ('11111111000111', NULL);
ROLLBACK;

-- ENDERECO / PESSOAENDERECO

-- ERRO 11: CEP NULL
START TRANSACTION;
INSERT INTO Endereco (cep, logradouro, numero)
VALUES (NULL, 'Rua Inválida', '10');
ROLLBACK;

-- ERRO 12: Pessoa inexistente na tabela associativa
START TRANSACTION;
INSERT INTO PessoaEndereco (cpf, id_endereco)
VALUES ('99999999999', 1);
ROLLBACK;

-- ERRO 13: endereço inexistenteD
START TRANSACTION;
INSERT INTO PessoaEndereco (cpf, id_endereco)
VALUES ('11111111111', 999);
ROLLBACK;

-- ERRO 14: combinação duplicada na PK composta
START TRANSACTION;
INSERT INTO PessoaEndereco (cpf, id_endereco)
VALUES ('11111111111', 1);
ROLLBACK;


-- TELEFONE

-- ERRO 15: nenhum titular informado
-- chk_telefone_titular exige exatamente um dos dois.
START TRANSACTION;
INSERT INTO Telefone (cpf, id_fornecedor, ddd, numero)
VALUES (NULL, NULL, '19', '999999999');
ROLLBACK;

-- ERRO 16: dois titulares informados ao mesmo tempo
START TRANSACTION;
INSERT INTO Telefone (cpf, id_fornecedor, ddd, numero)
VALUES ('11111111111', 1, '19', '999999999');
ROLLBACK;

-- ERRO 17: ambos os titulares inexistentes
START TRANSACTION;
INSERT INTO Telefone (cpf, ddd, numero)
VALUES ('99999999999', '19', '999999999');
ROLLBACK;


-- EMAIL

-- ERRO 18: CPF e fornecedor NULL
START TRANSACTION;
INSERT INTO Email (cpf, id_fornecedor, email, tipo)
VALUES (NULL, NULL, 'erro@email.com', 'PESSOAL');
ROLLBACK;

-- ERRO 19: CPF e fornecedor preenchidos
START TRANSACTION;
INSERT INTO Email (cpf, id_fornecedor, email, tipo)
VALUES ('11111111111', 1, 'erro@email.com', 'PESSOAL');
ROLLBACK;

-- ERRO 20: tipo inválido
START TRANSACTION;
INSERT INTO Email (cpf, email, tipo)
VALUES ('11111111111', 'erro@email.com', 'TRABALHO');
ROLLBACK;


-- PRODUTO

-- ERRO 21: categoria inexistente
START TRANSACTION;
INSERT INTO Produto (id_categoria, nome, preco_base)
VALUES (999, 'Produto sem categoria', 10.00);
ROLLBACK;

-- ERRO 22: preço negativo
START TRANSACTION;
INSERT INTO Produto (id_categoria, nome, preco_base)
VALUES (1, 'Produto com preço negativo', -10.00);
ROLLBACK;

-- ERRO 23: nome NULL
START TRANSACTION;
INSERT INTO Produto (id_categoria, nome, preco_base)
VALUES (1, NULL, 10.00);
ROLLBACK;


-- ITEMCOMBO / FICHATECNICA

-- ERRO 24: quantidade zero
START TRANSACTION;
INSERT INTO ItemCombo (id_combo, id_produto, quantidade_prod)
VALUES (1, 1, 0);
ROLLBACK;

-- ERRO 25: produto inexistente
START TRANSACTION;
INSERT INTO ItemCombo (id_combo, id_produto, quantidade_prod)
VALUES (1, 999, 1);
ROLLBACK;

-- ERRO 26: quantidade negativa na ficha técnica
START TRANSACTION;
INSERT INTO FichaTecnica (id_produto, id_insumo, quantidade_necessaria)
VALUES (2, 1, -1.00);
ROLLBACK;

-- ERRO 27: insumo inexistente
START TRANSACTION;
INSERT INTO FichaTecnica (id_produto, id_insumo, quantidade_necessaria)
VALUES (2, 999, 1.00);
ROLLBACK;


-- INSUMO

-- ERRO 28: quantidade mínima negativa
START TRANSACTION;
INSERT INTO Insumo (nome, unidade_medida, quantidade_minima)
VALUES ('Insumo inválido', 'KG', -10.00);
ROLLBACK;

-- ERRO 29: unidade inválida
START TRANSACTION;
INSERT INTO Insumo (nome, unidade_medida, quantidade_minima)
VALUES ('Insumo inválido', 'LITRO', 1.00);
ROLLBACK;


-- COMPRA / ITEMCOMPRA

-- ERRO 30: fornecedor inexistente
START TRANSACTION;
INSERT INTO Compra (id_fornecedor, id_funcionario, status_compra)
VALUES (999, 1, 'PENDENTE');
ROLLBACK;

-- ERRO 31: funcionário inexistente
START TRANSACTION;
INSERT INTO Compra (id_fornecedor, id_funcionario, status_compra)
VALUES (1, 999, 'PENDENTE');
ROLLBACK;

-- ERRO 32: status inválido
START TRANSACTION;
INSERT INTO Compra (id_fornecedor, id_funcionario, status_compra)
VALUES (1, 1, 'FINALIZADA');
ROLLBACK;

-- ERRO 33: quantidade solicitada zero
START TRANSACTION;
INSERT INTO ItemCompra
(id_compra, id_insumo, quantidade_solicitada, preco_unitario)
VALUES (1, 1, 0, 10.00);
ROLLBACK;

-- ERRO 34: preço unitário negativo
START TRANSACTION;
INSERT INTO ItemCompra
(id_compra, id_insumo, quantidade_solicitada, preco_unitario)
VALUES (1, 1, 10.00, -10.00);
ROLLBACK;


-- LOTE

-- ERRO 35: quantidade inicial negativa
START TRANSACTION;
INSERT INTO Lote
(id_insumo, numero_lote, data_validade, quantidade_inicial)
VALUES (1, 'LOTE-ERRADO', '2026-12-31', -5.00);
ROLLBACK;

-- ERRO 36: item de compra inexistente
START TRANSACTION;
INSERT INTO Lote
(id_insumo, id_item_compra, numero_lote, data_validade, quantidade_inicial)
VALUES (1, 999, 'LOTE-ERRADO', '2026-12-31', 5.00);
ROLLBACK;


-- MESA

-- ERRO 37: capacidade zero
START TRANSACTION;
INSERT INTO Mesa (capacidade, numero, status_mesa)
VALUES (0, '99', 'LIVRE');
ROLLBACK;

-- ERRO 38: número duplicado
START TRANSACTION;
INSERT INTO Mesa (capacidade, numero, status_mesa)
VALUES (4, '01', 'LIVRE');
ROLLBACK;

-- ERRO 39: status inválido
START TRANSACTION;
INSERT INTO Mesa (capacidade, numero, status_mesa)
VALUES (4, '99', 'OCUPADA');
ROLLBACK;


-- RESERVA

-- ERRO 40: quantidade de pessoas zero
START TRANSACTION;
INSERT INTO Reserva
(cpf, id_funcionario, quantidade_pessoas, data_hora_inicio, status)
VALUES ('11111111111', 1, 0, '2026-11-10 19:00:00', 'PENDENTE');
ROLLBACK;

-- ERRO 41: CPF inexistente
START TRANSACTION;
INSERT INTO Reserva
(cpf, id_funcionario, quantidade_pessoas, data_hora_inicio, status)
VALUES ('99999999999', 1, 2, '2026-11-10 19:00:00', 'PENDENTE');
ROLLBACK;


-- ATENDIMENTO

-- ERRO 42: hora de saída anterior à chegada
START TRANSACTION;
INSERT INTO Atendimento
(id_funcionario, hora_chegada, hora_saida, qtd_pessoas)
VALUES
(1, '2026-11-10 20:00:00', '2026-11-10 19:00:00', 2);
ROLLBACK;

-- ERRO 43: quantidade de pessoas zero
START TRANSACTION;
INSERT INTO Atendimento
(id_funcionario, hora_chegada, qtd_pessoas)
VALUES
(1, '2026-11-10 20:00:00', 0);
ROLLBACK;


-- CAIXA

-- ERRO 44: valor de abertura negativo
START TRANSACTION;
INSERT INTO Caixa
(id_funcionario_abertura, tipo_caixa, valor_abertura)
VALUES (1, 'LOCAL', -100.00);
ROLLBACK;

-- ERRO 45: caixa FECHADO sem funcionário/data/valor de fechamento
START TRANSACTION;
INSERT INTO Caixa
(id_funcionario_abertura, tipo_caixa, valor_abertura, status_caixa)
VALUES (1, 'LOCAL', 100.00, 'FECHADO');
ROLLBACK;

-- ERRO 46: data de fechamento anterior à abertura
START TRANSACTION;
INSERT INTO Caixa
(id_funcionario_abertura, id_funcionario_fechamento,
 data_abertura, data_fechamento, tipo_caixa,
 valor_abertura, valor_fechamento, status_caixa)
VALUES
(1, 2, '2026-11-10 20:00:00', '2026-11-10 19:00:00',
 'LOCAL', 100.00, 120.00, 'FECHADO');
ROLLBACK;


-- PEDIDO

-- ERRO 47: CPF inexistente
START TRANSACTION;
INSERT INTO Pedido (cpf, status_pedido, modalidade)
VALUES ('99999999999', 'PENDENTE', 'LOCAL');
ROLLBACK;

-- ERRO 48: modalidade inválida
START TRANSACTION;
INSERT INTO Pedido (cpf, status_pedido, modalidade)
VALUES ('11111111111', 'PENDENTE', 'DELIVERY');
ROLLBACK;

-- ERRO 49: fim da produção antes do início
START TRANSACTION;
INSERT INTO Pedido
(cpf, status_pedido, modalidade,
 data_hora_inicio_producao, data_hora_fim_producao)
VALUES
('11111111111', 'CONCLUIDO', 'LOCAL',
 '2026-11-10 20:00:00', '2026-11-10 19:00:00');
ROLLBACK;

-- ERRO 50: canal de origem inválido
START TRANSACTION;
INSERT INTO Pedido
(cpf, status_pedido, modalidade, canal_origem)
VALUES ('11111111111', 'PENDENTE', 'ENTREGA', 'UBER');
ROLLBACK;


-- ITEMPEDIDO e ITEMCOMBOPEDIDO

-- ERRO 51: quantidade zero
START TRANSACTION;
INSERT INTO ItemPedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES (1, 2, 0, 32.90);
ROLLBACK;

-- ERRO 52: preço negativo
START TRANSACTION;
INSERT INTO ItemPedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES (1, 2, 1, -32.90);
ROLLBACK;

-- ERRO 53: PK composta duplicada
START TRANSACTION;
INSERT INTO ItemPedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES (1, 2, 1, 32.90);
ROLLBACK;

-- ERRO 54: combo inexistente
START TRANSACTION;
INSERT INTO ItemComboPedido
(id_pedido, id_combo, quantidade, preco_unitario)
VALUES (1, 999, 1, 20.00);
ROLLBACK;


-- PAGAMENTO

-- ERRO 55: valor total zero
START TRANSACTION;
INSERT INTO Pagamento
(id_pedido, id_caixa, id_forma_pagamento, valor_total)
VALUES (1, 1, 1, 0);
ROLLBACK;

-- ERRO 56: valor total negativo
START TRANSACTION;
INSERT INTO Pagamento
(id_pedido, id_caixa, id_forma_pagamento, valor_total)
VALUES (1, 1, 1, -10.00);
ROLLBACK;

-- ERRO 57: caixa inexistente
START TRANSACTION;
INSERT INTO Pagamento
(id_pedido, id_caixa, id_forma_pagamento, valor_total)
VALUES (1, 999, 1, 10.00);
ROLLBACK;


-- ENTREGADOR / ENTREGA

-- ERRO 58: plataforma inválida
START TRANSACTION;
INSERT INTO Entregador
(id_funcionario, tipo_vinculo, plataforma, identificador_externo)
VALUES (NULL, 'EXTERNO', 'RAPPI', 'A002');
ROLLBACK;

-- ERRO 59: pedido inexistente
START TRANSACTION;
INSERT INTO Entrega
(id_pedido, id_endereco, taxa_entrega)
VALUES (999, 1, 5.00);
ROLLBACK;

-- ERRO 60: taxa negativa
START TRANSACTION;
INSERT INTO Entrega
(id_pedido, id_endereco, taxa_entrega)
VALUES (2, 1, -5.00);
ROLLBACK;

-- ERRO 61: chegada sem saída
START TRANSACTION;
INSERT INTO Entrega
(id_pedido, id_endereco, taxa_entrega,
 data_saida, data_chegada)
VALUES
(2, 1, 5.00, NULL, '2026-11-05 21:00:00');
ROLLBACK;

-- ERRO 62: chegada antes da saída
START TRANSACTION;
INSERT INTO Entrega
(id_pedido, id_endereco, taxa_entrega,
 data_saida, data_chegada)
VALUES
(2, 1, 5.00,
 '2026-11-05 21:00:00',
 '2026-11-05 20:00:00');
ROLLBACK;


-- AVALIACAO

-- ERRO 63: nota abaixo de 1
START TRANSACTION;
INSERT INTO Avaliacao (id_pedido, comentario, data, nota)
VALUES (2, 'Nota inválida.', '2026-11-06', 0);
ROLLBACK;

-- ERRO 64: nota acima de 5
START TRANSACTION;
INSERT INTO Avaliacao (id_pedido, comentario, data, nota)
VALUES (2, 'Nota inválida.', '2026-11-06', 6);
ROLLBACK;

-- ERRO 65: mesma avaliação para o mesmo pedido (UNIQUE)
START TRANSACTION;
INSERT INTO Avaliacao (id_pedido, comentario, data, nota)
VALUES (1, 'Segunda avaliação.', '2026-11-06', 4);
ROLLBACK;


-- OCORRENCIA / REEMBOLSO

-- ERRO 66: OUTROS sem descrição
START TRANSACTION;
INSERT INTO Ocorrencia
(id_pedido, classificacao, consumo_produto, descricao)
VALUES (1, 'OUTROS', 'CONSUMO', NULL);
ROLLBACK;

-- ERRO 67: valor de reembolso zero
START TRANSACTION;
INSERT INTO Reembolso
(id_ocorrencia, id_pagamento, valor_reembolso)
VALUES (1, 1, 0);
ROLLBACK;

-- ERRO 68: valor de reembolso negativo
START TRANSACTION;
INSERT INTO Reembolso
(id_ocorrencia, id_pagamento, valor_reembolso)
VALUES (1, 1, -20.00);
ROLLBACK;


-- PROMOÇÕES

-- ERRO 69: percentual acima de 100
START TRANSACTION;
INSERT INTO PromocaoProduto
(id_produto, id_promocao, percentual_desconto)
VALUES (2, 1, 150.00);
ROLLBACK;

-- ERRO 70: percentual negativo
START TRANSACTION;
INSERT INTO PromocaoCombo
(id_combo, id_promocao, percentual_desconto)
VALUES (1, 1, -5.00);
ROLLBACK;

-- ERRO 71: produto inexistente
START TRANSACTION;
INSERT INTO PromocaoProduto
(id_produto, id_promocao, percentual_desconto)
VALUES (999, 1, 10.00);
ROLLBACK;


-- MOVIMENTACAO DE ESTOQUE

-- ERRO 72: quantidade zero
START TRANSACTION;
INSERT INTO MovimentacaoEstoque
(id_lote, tipo_movimentacao, quantidade)
VALUES (1, 'ENTRADA', 0);
ROLLBACK;

-- ERRO 73: quantidade negativa
START TRANSACTION;
INSERT INTO MovimentacaoEstoque
(id_lote, tipo_movimentacao, quantidade)
VALUES (1, 'CONSUMO', -5.00);
ROLLBACK;

-- ERRO 74: lote inexistente
START TRANSACTION;
INSERT INTO MovimentacaoEstoque
(id_lote, tipo_movimentacao, quantidade)
VALUES (999, 'ENTRADA', 10.00);
ROLLBACK;

-- DESPESA

-- ERRO 75: valor negativo
START TRANSACTION;
INSERT INTO Despesa
(id_funcionario, descricao, valor, data_vencimento)
VALUES (1, 'Despesa inválida', -100.00, '2026-11-10');
ROLLBACK;

-- ERRO 76: funcionário inexistente
START TRANSACTION;
INSERT INTO Despesa
(id_funcionario, descricao, valor, data_vencimento)
VALUES (999, 'Despesa inválida', 100.00, '2026-11-10');
ROLLBACK;