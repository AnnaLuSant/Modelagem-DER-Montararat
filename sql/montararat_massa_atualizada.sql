-- MASSA COMPATIBILIZADA COM O SCRIPT ATUALIZADO DO USUARIO (31/10/2026).
-- Execute APENAS UMA VEZ em um banco vazio criado por montararat_estrutura_atualizada.sql.
-- Precos de cardapio e nomes observados nas imagens; demais dados e composicoes simulados.
-- MONT ARARAT BURGER HOUSE | MASSA DE DADOS PARA AMBIENTE DE TESTES
-- Compatível com as tabelas do arquivo enviado, após corrigir erros de CREATE TABLE.
-- Execute APENAS UMA VEZ em banco recém-criado e vazio; IDs explícitos começam em 1.
-- Dados comerciais vistos no cardápio/lista; documentos, preços de compras, quantidades, datas e operações são FICTÍCIOS.
-- Não contém pessoas, telefones ou CNPJs reais.
USE montararat;
START TRANSACTION; -- um grupo de comandos SQL tratado como uma única operação indivisível


INSERT INTO Pessoa (cpf, nome) VALUES
  ('10000000001', 'Mariana Oliveira'),
  ('10000000002', 'Rafael Santos'),
  ('10000000003', 'Beatriz Lima'),
  ('10000000004', 'Lucas Pereira'),
  ('10000000005', 'Camila Rocha'),
  ('10000000006', 'Gabriel Almeida'),
  ('10000000007', 'Juliana Costa'),
  ('10000000008', 'Pedro Martins'),
  ('10000000009', 'Ana Ribeiro'),
  ('10000000010', 'Felipe Souza'),
  ('10000000011', 'Larissa Gomes'),
  ('10000000012', 'Thiago Ferreira'),
  ('10000000013', 'Isabela Melo'),
  ('10000000014', 'Daniel Barros'),
  ('10000000015', 'Renata Castro'),
  ('10000000016', 'Bruno Nunes'),
  ('10000000017', 'Carolina Dias'),
  ('10000000018', 'Eduardo Reis'),
  ('10000000019', 'Paula Araujo'),
  ('10000000020', 'Vinicius Teixeira');


INSERT INTO Cargo (id_cargo, nome_cargo, salario_base) VALUES
  (1, 'Gerente', 3800),
  (2, 'Atendente', 2100),
  (3, 'Cozinheiro', 2600),
  (4, 'Estoquista', 2400),
  (5, 'Caixa', 2200);


INSERT INTO Funcionario (matricula_funcionario, cpf, id_cargo, data_admissao) VALUES
  (1, '10000000001', 1, '2025-02-10'),
  (2, '10000000002', 2, '2025-03-10'),
  (3, '10000000003', 3, '2025-04-10'),
  (4, '10000000004', 4, '2025-05-10'),
  (5, '10000000005', 5, '2025-06-10'),
  (6, '10000000006', 2, '2025-07-10'),
  (7, '10000000007', 3, '2025-08-10'),
  (8, '10000000008', 5, '2025-01-10');


INSERT INTO Fornecedor (id_fornecedor, cnpj, nome) VALUES
  (1, '90000000000001', 'PMG'),
  (2, '90000000000002', 'Coca-Cola'),
  (3, '90000000000003', 'Fornecedor de Paes'),
  (4, '90000000000004', 'Fornecedor de Catupiry'),
  (5, '90000000000005', 'Givina (Amanda)'),
  (6, '90000000000006', 'Polenghi (Bruno)'),
  (7, '90000000000007', 'Frimesa'),
  (8, '90000000000008', 'Avelinos (Luciana)'),
  (9, '90000000000009', 'Toninho'),
  (10, '90000000000010', 'Nestle'),
  (11, '90000000000011', 'MS Alimentos (Edson)'),
  (12, '90000000000012', 'QUIACKPAN'),
  (13, '90000000000013', 'R2 Embalagens (Andre)'),
  (14, '90000000000014', 'Braspel (Raquel)'),
  (15, '90000000000015', 'IDEAL'),
  (16, '90000000000016', 'INTERCARTA'),
  (17, '90000000000017', 'Galvonatec (Edelcira)'),
  (18, '90000000000018', 'ARRIFANA'),
  (19, '90000000000019', 'AITEC'),
  (20, '90000000000020', 'Mercado / Corner Shop');


INSERT INTO Endereco (id_endereco, cep, logradouro, numero, complemento) VALUES
  (1, '01001000', 'Rua Exemplo 1', '10', NULL),
  (2, '01001000', 'Rua Exemplo 2', '20', NULL),
  (3, '01001000', 'Rua Exemplo 3', '30', NULL),
  (4, '01001000', 'Rua Exemplo 4', '40', NULL),
  (5, '01001000', 'Rua Exemplo 5', '50', NULL),
  (6, '01001000', 'Rua Exemplo 6', '60', NULL),
  (7, '01001000', 'Rua Exemplo 7', '70', NULL),
  (8, '01001000', 'Rua Exemplo 8', '80', NULL),
  (9, '01001000', 'Rua Exemplo 9', '90', NULL),
  (10, '01001000', 'Rua Exemplo 10', '100', NULL),
  (11, '01001000', 'Rua Exemplo 11', '110', NULL),
  (12, '01001000', 'Rua Exemplo 12', '120', NULL);


INSERT INTO PessoaEndereco (cpf, id_endereco) VALUES
  ('10000000001', 1),
  ('10000000002', 2),
  ('10000000003', 3),
  ('10000000004', 4),
  ('10000000005', 5),
  ('10000000006', 6),
  ('10000000007', 7),
  ('10000000008', 8),
  ('10000000009', 9),
  ('10000000010', 10),
  ('10000000011', 11),
  ('10000000012', 12);


INSERT INTO Telefone (id_telefone, cpf, id_fornecedor, ddd, numero) VALUES
  (1, '10000000001', NULL, '11', '9000000001'),
  (2, '10000000002', NULL, '11', '9000000002'),
  (3, '10000000003', NULL, '11', '9000000003'),
  (4, '10000000004', NULL, '11', '9000000004'),
  (5, '10000000005', NULL, '11', '9000000005'),
  (6, '10000000006', NULL, '11', '9000000006'),
  (7, '10000000007', NULL, '11', '9000000007'),
  (8, '10000000008', NULL, '11', '9000000008'),
  (9, NULL, 1, '11', '3000000001'),
  (10, NULL, 2, '11', '3000000002'),
  (11, NULL, 3, '11', '3000000003'),
  (12, NULL, 4, '11', '3000000004'),
  (13, NULL, 5, '11', '3000000005'),
  (14, NULL, 6, '11', '3000000006'),
  (15, NULL, 7, '11', '3000000007'),
  (16, NULL, 8, '11', '3000000008');


INSERT INTO Email (id_email, cpf, id_fornecedor, email, tipo) VALUES
  (1, '10000000001', NULL, 'teste1@example.invalid', 'PESSOAL'),
  (2, '10000000002', NULL, 'teste2@example.invalid', 'PESSOAL'),
  (3, '10000000003', NULL, 'teste3@example.invalid', 'PESSOAL'),
  (4, '10000000004', NULL, 'teste4@example.invalid', 'PESSOAL'),
  (5, '10000000005', NULL, 'teste5@example.invalid', 'PESSOAL'),
  (6, '10000000006', NULL, 'teste6@example.invalid', 'PESSOAL'),
  (7, '10000000007', NULL, 'teste7@example.invalid', 'PESSOAL'),
  (8, '10000000008', NULL, 'teste8@example.invalid', 'PESSOAL'),
  (9, NULL, 1, 'fornecedor1@example.invalid', 'CORPORATIVO'),
  (10, NULL, 2, 'fornecedor2@example.invalid', 'CORPORATIVO'),
  (11, NULL, 3, 'fornecedor3@example.invalid', 'CORPORATIVO'),
  (12, NULL, 4, 'fornecedor4@example.invalid', 'CORPORATIVO'),
  (13, NULL, 5, 'fornecedor5@example.invalid', 'CORPORATIVO'),
  (14, NULL, 6, 'fornecedor6@example.invalid', 'CORPORATIVO'),
  (15, NULL, 7, 'fornecedor7@example.invalid', 'CORPORATIVO'),
  (16, NULL, 8, 'fornecedor8@example.invalid', 'CORPORATIVO');


INSERT INTO FormaPagamento (id_forma_pagamento, tipo) VALUES
  (1, 'PIX'),
  (2, 'CARTAO DE CREDITO'),
  (3, 'CARTAO DE DEBITO'),
  (4, 'DINHEIRO');


INSERT INTO Categoria (id_categoria, descricao, tipo) VALUES
  (1, 'Hamburgueres', 'LANCHE'),
  (2, 'Entradas e acompanhamentos', 'ACOMPANHAMENTO'),
  (3, 'Bebidas', 'BEBIDA');


INSERT INTO Produto (id_produto, id_categoria, nome, preco_base, descricao, montagem_especial) VALUES
  (1, 1, 'Burger', 35, 'Pao ciabatta, burger 180g, bacon, catupiry, mussarela, maionese, alface, tomate, cebola roxa e picles', 0),
  (2, 1, 'Costela', 35, 'Pao australiano, burger 180g, cebola empanada, bacon, cheddar, barbecue e cebola caramelizada', 0),
  (3, 1, 'Linguica', 35, 'Pao brioche, burger de linguica 180g, bacon, catupiry, mussarela e salada', 0),
  (4, 1, 'Diluvio', 41, 'Pao australiano, burger 180g, bacon, cebola empanada, barbecue, cebola caramelizada e cheddar cremoso', 0),
  (5, 1, 'Kids', 19, 'Pao brioche, burger 120g e mussarela', 0),
  (6, 1, 'Cheddar', 34, 'Pao australiano, burger 180g, cheddar cremoso e cebola caramelizada', 0),
  (7, 1, 'Frango', 35, 'Pao brioche, burger de frango 200g, bacon, catupiry, mussarela, maionese e salada', 0),
  (8, 1, 'Salmao', 40, 'Pao australiano, burger de salmao 150g, cream cheese, cebolinha e rucula', 0),
  (9, 1, 'Vegetariano', 39, 'Pao australiano, queijo coalho 200g, maionese, rucula e tomate seco', 0),
  (10, 2, 'Batata simples inteira', 27, 'Porcao inteira', 0),
  (11, 2, 'Batata simples meia', 17, 'Meia porcao', 0),
  (12, 2, 'Batata pulled inteira', 35, 'Batata com pulled pork', 0),
  (13, 2, 'Batata pulled meia', 25, 'Meia porcao', 0),
  (14, 2, 'Coxinha 6 unidades', 29, 'Porcao de seis', 0),
  (15, 2, 'Coxinha 3 unidades', 15, 'Porcao de tres', 0),
  (16, 2, 'Coxinha pulled 6 unidades', 29, 'Porcao de seis', 0),
  (17, 2, 'Coxinha pulled 3 unidades', 15, 'Porcao de tres', 0),
  (18, 2, 'Nugget 10 unidades', 16, 'Porcao de dez', 0),
  (19, 2, 'Nugget 6 unidades', 9, 'Porcao de seis', 0),
  (20, 3, 'Refrigerante', 6, 'Lata ou unidade', 0),
  (21, 3, 'Suco', 6, 'Consultar disponibilidade', 0),
  (22, 3, 'Agua sem gas', 4, NULL, 0),
  (23, 3, 'Agua com gas', 4, NULL, 0),
  (24, 3, 'Refil pink lemonade', 11, NULL, 0),
  (25, 2, 'Extra cheddar ou bacon', 6, 'Adicional', 0),
  (26, 2, 'Extra catupiry ou cream cheese', 6, 'Adicional', 0);


INSERT INTO Combo (id_combo, nome, preco_combo, descricao) VALUES
  (1, 'Combo Burger', 43, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (2, 'Combo Costela', 43, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (3, 'Combo Linguica', 43, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (4, 'Combo Diluvio', 49, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (5, 'Combo Kids', 27, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (6, 'Combo Cheddar', 42, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (7, 'Combo Frango', 43, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (8, 'Combo Salmao', 48, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento'),
  (9, 'Combo Vegetariano', 47, 'Lanche com acompanhamento; composicao demonstrativa, confirmar com estabelecimento');


INSERT INTO ItemCombo (id_combo, id_produto, quantidade_prod) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1),
  (5, 5, 1),
  (6, 6, 1),
  (7, 7, 1),
  (8, 8, 1),
  (9, 9, 1),
  (1, 11, 1),
  (2, 11, 1),
  (3, 11, 1),
  (4, 11, 1),
  (5, 11, 1),
  (6, 11, 1),
  (7, 11, 1),
  (8, 11, 1),
  (9, 11, 1);


INSERT INTO Insumo (id_insumo, nome, unidade_medida, quantidade_minima) VALUES
  (1, 'Creme de leite', 'UN', 5),
  (2, 'Cream cheese', 'KG', 1),
  (3, 'Mussarela', 'KG', 1),
  (4, 'Ovo pasteurizado', 'UN', 5),
  (5, 'Ketchup sache', 'UN', 5),
  (6, 'Mostarda sache', 'UN', 5),
  (7, 'Ketchup mesa', 'UN', 5),
  (8, 'Mostarda mesa', 'UN', 5),
  (9, 'Ketchup bag', 'UN', 5),
  (10, 'Mostarda bag', 'UN', 5),
  (11, 'Farinha de trigo', 'UN', 5),
  (12, 'Leite', 'L', 1),
  (13, 'Farinha panko', 'UN', 5),
  (14, 'Manteiga', 'UN', 5),
  (15, 'Acucar cristal', 'UN', 5),
  (16, 'Sal', 'KG', 1),
  (17, 'Acucar refinado', 'UN', 5),
  (18, 'Coca-Cola', 'UN', 5),
  (19, 'Fanta uva', 'UN', 5),
  (20, 'Fanta laranja', 'UN', 5),
  (21, 'Sprite', 'UN', 5),
  (22, 'Suco maracuja', 'UN', 5),
  (23, 'Suco uva', 'UN', 5),
  (24, 'Suco pessego', 'UN', 5),
  (25, 'Eisenbahn', 'UN', 5),
  (26, 'Coca Zero', 'UN', 5),
  (27, 'Agua sem gas', 'UN', 5),
  (28, 'Agua com gas', 'UN', 5),
  (29, 'Pao de hamburguer', 'UN', 5),
  (30, 'Pao ciabatta', 'UN', 5),
  (31, 'Pao australiano', 'UN', 5),
  (32, 'Pao brioche', 'UN', 5),
  (33, 'Catupiry', 'KG', 1),
  (34, 'Cheddar cremoso', 'KG', 1),
  (35, 'Cheddar processado', 'KG', 1),
  (36, 'Bacon', 'KG', 1),
  (37, 'Nutella', 'UN', 5),
  (38, 'Ovomaltine', 'UN', 5),
  (39, 'Ovomaltine flocos', 'UN', 5),
  (40, 'Carvao', 'UN', 5),
  (41, 'Caldo de costela', 'UN', 5),
  (42, 'Caldo de galinha', 'UN', 5),
  (43, 'Creme de cebola', 'UN', 5),
  (44, 'Queijo coalho', 'KG', 1),
  (45, 'Oleo de fritadeira', 'L', 1),
  (46, 'Caixinha de lanche', 'UN', 5),
  (47, 'Berco de lanche', 'UN', 5),
  (48, 'Caixinha de coxinha', 'UN', 5),
  (49, 'Berco de coxinha', 'UN', 5),
  (50, 'Saco kraft', 'UN', 5),
  (51, 'Saco transporte', 'UN', 5),
  (52, 'Plastico filme', 'UN', 5),
  (53, 'Palito lanche', 'UN', 5),
  (54, 'Palito trufado', 'UN', 5),
  (55, 'Saco lixo 100L', 'UN', 5),
  (56, 'Sacola refrigerante', 'UN', 5),
  (57, 'Touca cozinha', 'UN', 5),
  (58, 'Perflex', 'UN', 5),
  (59, 'Alcool 70', 'L', 1),
  (60, 'Alcool gel', 'L', 1),
  (61, 'Canudo refrigerante', 'UN', 5),
  (62, 'Canudo milkshake', 'UN', 5),
  (63, 'Papel higienico', 'UN', 5),
  (64, 'Sabonete liquido', 'UN', 5),
  (65, 'Papel acoplado', 'UN', 5),
  (66, 'Guardanapo sache', 'UN', 5),
  (67, 'Detergente', 'L', 1),
  (68, 'Papel interfolha', 'UN', 5),
  (69, 'Bucha lavar louca', 'UN', 5),
  (70, 'Grampos', 'UN', 5);


INSERT INTO Insumo (id_insumo, nome, unidade_medida, quantidade_minima) VALUES
  (71, 'Colher doce', 'UN', 5),
  (72, 'Gas macarico', 'UN', 5),
  (73, 'Copo cafe', 'UN', 5),
  (74, 'Copo agua', 'UN', 5),
  (75, 'Papel acoplado Mont Ararat', 'UN', 5),
  (76, 'Papel acoplado Mont Ararat salao', 'UN', 5),
  (77, 'Potinho de molho', 'UN', 5),
  (78, 'Barbecue', 'KG', 1),
  (79, 'Separador hamburguer', 'UN', 5),
  (80, 'Candida', 'UN', 5),
  (81, 'Luva', 'UN', 5),
  (82, 'Bicarbonato', 'UN', 5),
  (83, 'Etiqueta manipulacao', 'UN', 5),
  (84, 'Bobina maquininha', 'UN', 5),
  (85, 'Bobina impressora caixa', 'UN', 5),
  (86, 'Fermento biologico', 'UN', 5),
  (87, 'Oleo', 'UN', 5),
  (88, 'Glicomel', 'UN', 5),
  (89, 'Doce de leite', 'UN', 5),
  (90, 'Acucar mascavo', 'UN', 5),
  (91, 'Amendoim', 'UN', 5),
  (92, 'Sabao em po', 'UN', 5),
  (93, 'Maca verde', 'UN', 5),
  (94, 'Pink lemonade', 'UN', 5),
  (95, 'Canela', 'UN', 5),
  (96, 'Picles', 'KG', 1),
  (97, 'Pimenta jalapeno', 'KG', 1),
  (98, 'Pimenta mesa', 'UN', 5),
  (99, 'Shoyu', 'L', 1),
  (100, 'Produto chapa', 'UN', 5),
  (101, 'Limpa aluminio', 'UN', 5),
  (102, 'Detergente clorado', 'UN', 5),
  (103, 'Copo isopor', 'UN', 5),
  (104, 'Papel aluminio', 'UN', 5),
  (105, 'Bombril', 'UN', 5),
  (106, 'Desinfetante', 'L', 1),
  (107, 'Nugget', 'UN', 5),
  (108, 'Guardanapo mesa', 'UN', 5),
  (109, 'Carne bovina 180g', 'KG', 1),
  (110, 'Burger linguica 180g', 'KG', 1),
  (111, 'Burger frango 200g', 'KG', 1),
  (112, 'Burger salmao 150g', 'KG', 1),
  (113, 'Carne bovina 120g', 'KG', 1),
  (114, 'Alface americana', 'KG', 1),
  (115, 'Tomate', 'KG', 1),
  (116, 'Cebola roxa', 'KG', 1),
  (117, 'Cebola caramelizada', 'KG', 1),
  (118, 'Cebola empanada', 'KG', 1),
  (119, 'Rucula', 'KG', 1),
  (120, 'Tomate seco', 'KG', 1),
  (121, 'Cebolinha', 'KG', 1),
  (122, 'Batata frita', 'KG', 1),
  (123, 'Pulled pork', 'KG', 1),
  (124, 'Coxinha', 'KG', 1),
  (125, 'Coxinha pulled', 'KG', 1),
  (126, 'Maionese da casa', 'KG', 1),
  (127, 'Pimenta do reino', 'UN', 5);


INSERT INTO FichaTecnica (id_produto, id_insumo, quantidade_necessaria) VALUES
  (1, 30, 1),
  (1, 109, 1),
  (1, 36, 0.04),
  (1, 33, 0.03),
  (1, 3, 0.03),
  (1, 126, 0.02),
  (1, 114, 0.02),
  (1, 115, 0.03),
  (1, 116, 0.02),
  (1, 96, 0.01),
  (2, 31, 1),
  (2, 109, 1),
  (2, 118, 0.04),
  (2, 36, 0.04),
  (2, 35, 0.03),
  (2, 78, 0.02),
  (2, 117, 0.03),
  (3, 32, 1),
  (3, 110, 1),
  (3, 36, 0.04),
  (3, 33, 0.03),
  (3, 3, 0.03),
  (3, 126, 0.02),
  (3, 114, 0.02),
  (3, 115, 0.02),
  (4, 31, 1),
  (4, 109, 1),
  (4, 36, 0.04),
  (4, 118, 0.04),
  (4, 78, 0.02),
  (4, 117, 0.03),
  (4, 34, 0.05),
  (4, 97, 0.01),
  (5, 32, 1),
  (5, 113, 1),
  (5, 3, 0.03),
  (6, 31, 1),
  (6, 109, 1),
  (6, 34, 0.05),
  (6, 117, 0.03),
  (7, 32, 1),
  (7, 111, 1),
  (7, 36, 0.04),
  (7, 33, 0.03),
  (7, 3, 0.03),
  (7, 126, 0.02),
  (7, 114, 0.02),
  (7, 115, 0.02),
  (8, 31, 1),
  (8, 112, 1),
  (8, 2, 0.04),
  (8, 121, 0.01),
  (8, 119, 0.02),
  (9, 31, 1),
  (9, 44, 0.2),
  (9, 126, 0.02),
  (9, 119, 0.02),
  (9, 120, 0.03),
  (10, 122, 0.35),
  (11, 122, 0.2),
  (12, 122, 0.3),
  (12, 123, 0.12),
  (13, 122, 0.17),
  (13, 123, 0.07),
  (14, 124, 6),
  (15, 124, 3),
  (16, 125, 6),
  (17, 125, 3),
  (18, 107, 10),
  (19, 107, 6);


INSERT INTO FichaTecnica (id_produto, id_insumo, quantidade_necessaria) VALUES
  (20, 18, 1),
  (21, 22, 1),
  (22, 27, 1),
  (23, 28, 1),
  (24, 94, 1),
  (25, 34, 0.04),
  (26, 33, 0.04);


INSERT INTO Compra (id_compra, id_fornecedor, matricula_funcionario, data_compra, status_compra) VALUES
  (1, 1, 4, '2026-10-02 09:00:00', 'RECEBIDA'),
  (2, 2, 4, '2026-10-03 09:00:00', 'RECEBIDA'),
  (3, 3, 4, '2026-10-04 09:00:00', 'RECEBIDA'),
  (4, 4, 4, '2026-10-05 09:00:00', 'RECEBIDA'),
  (5, 5, 4, '2026-10-06 09:00:00', 'RECEBIDA'),
  (6, 6, 4, '2026-10-07 09:00:00', 'RECEBIDA'),
  (7, 7, 4, '2026-10-08 09:00:00', 'RECEBIDA'),
  (8, 8, 4, '2026-10-09 09:00:00', 'RECEBIDA'),
  (9, 9, 4, '2026-10-10 09:00:00', 'RECEBIDA'),
  (10, 10, 4, '2026-10-11 09:00:00', 'RECEBIDA'),
  (11, 11, 4, '2026-10-12 09:00:00', 'RECEBIDA'),
  (12, 12, 4, '2026-10-13 09:00:00', 'RECEBIDA'),
  (13, 13, 4, '2026-10-14 09:00:00', 'RECEBIDA'),
  (14, 14, 4, '2026-10-15 09:00:00', 'RECEBIDA'),
  (15, 15, 4, '2026-10-16 09:00:00', 'RECEBIDA'),
  (16, 16, 4, '2026-10-17 09:00:00', 'RECEBIDA'),
  (17, 17, 4, '2026-10-18 09:00:00', 'RECEBIDA'),
  (18, 18, 4, '2026-10-19 09:00:00', 'RECEBIDA'),
  (19, 19, 4, '2026-10-20 09:00:00', 'RECEBIDA'),
  (20, 20, 4, '2026-10-01 09:00:00', 'RECEBIDA');


INSERT INTO ItemCompra (id_item_compra, id_compra, id_insumo, quantidade_solicitada, preco_unitario) VALUES
  (1, 1, 1, 34, 3.8),
  (2, 1, 2, 16.801, 10.14),
  (3, 1, 3, 31.567, 24.65),
  (4, 1, 4, 89, 5.78),
  (5, 1, 5, 74, 4.02),
  (6, 1, 6, 31, 10.0),
  (7, 1, 7, 84, 22.26),
  (8, 1, 8, 91, 9.36),
  (9, 1, 9, 89, 16.42),
  (10, 1, 10, 77, 21.86),
  (11, 1, 11, 20, 27.28),
  (12, 1, 12, 13.109, 16.52),
  (13, 1, 13, 55, 7.98),
  (14, 1, 14, 63, 6.27),
  (15, 1, 15, 68, 6.09),
  (16, 1, 16, 35.12, 22.32),
  (17, 1, 17, 25, 26.35),
  (18, 2, 18, 88, 6.99),
  (19, 2, 19, 68, 5.52),
  (20, 2, 20, 57, 29.54),
  (21, 2, 21, 99, 31.33),
  (22, 2, 22, 66, 21.48),
  (23, 2, 23, 28, 4.47),
  (24, 2, 24, 49, 27.74),
  (25, 2, 25, 30, 30.37),
  (26, 2, 26, 32, 15.16),
  (27, 2, 27, 78, 23.34),
  (28, 2, 28, 66, 8.2),
  (29, 3, 29, 65, 9.7),
  (30, 3, 30, 54, 25.46),
  (31, 3, 31, 29, 22.49),
  (32, 3, 32, 41, 20.09),
  (33, 4, 33, 15.834, 17.79),
  (34, 5, 34, 16.638, 32.61),
  (35, 6, 35, 30.021, 10.03),
  (36, 7, 36, 18.377, 27.59),
  (37, 8, 37, 27, 10.33),
  (38, 8, 38, 24, 28.76),
  (39, 8, 39, 71, 11.57),
  (40, 9, 40, 47, 32.22),
  (41, 10, 41, 92, 31.04),
  (42, 10, 42, 60, 9.8),
  (43, 10, 43, 83, 15.66),
  (44, 11, 44, 37.266, 17.68),
  (45, 12, 45, 16.476, 10.89),
  (46, 13, 46, 91, 20.25),
  (47, 13, 47, 94, 16.71),
  (48, 13, 48, 94, 15.78),
  (49, 13, 49, 48, 34.91),
  (50, 14, 50, 37, 19.3),
  (51, 15, 51, 31, 27.19),
  (52, 15, 52, 34, 7.89),
  (53, 15, 53, 40, 28.35),
  (54, 15, 54, 74, 22.09),
  (55, 15, 55, 69, 15.21),
  (56, 15, 56, 79, 19.93),
  (57, 15, 57, 90, 30.54),
  (58, 15, 58, 21, 24.77),
  (59, 15, 59, 11.666, 31.31),
  (60, 15, 60, 32.028, 27.6),
  (61, 15, 61, 63, 6.57),
  (62, 15, 62, 75, 8.06),
  (63, 15, 63, 20, 33.52),
  (64, 15, 64, 53, 34.1),
  (65, 15, 65, 42, 19.25),
  (66, 15, 66, 33, 30.86),
  (67, 15, 67, 17.55, 23.45),
  (68, 15, 68, 97, 9.37),
  (69, 15, 69, 67, 27.4),
  (70, 15, 70, 89, 33.51);


INSERT INTO ItemCompra (id_item_compra, id_compra, id_insumo, quantidade_solicitada, preco_unitario) VALUES
  (71, 15, 71, 87, 32.39),
  (72, 15, 72, 96, 13.37),
  (73, 15, 73, 22, 6.58),
  (74, 15, 74, 66, 31.12),
  (75, 16, 75, 59, 10.66),
  (76, 16, 76, 50, 31.1),
  (77, 17, 77, 30, 5.74),
  (78, 18, 78, 23.552, 5.21),
  (79, 19, 79, 88, 27.51),
  (80, 20, 80, 36, 24.11),
  (81, 20, 81, 90, 8.28),
  (82, 20, 82, 87, 30.92),
  (83, 20, 83, 74, 33.86),
  (84, 20, 84, 89, 27.17),
  (85, 20, 85, 45, 25.81),
  (86, 20, 86, 71, 34.84),
  (87, 20, 87, 67, 17.02),
  (88, 20, 88, 86, 17.45),
  (89, 20, 89, 51, 10.19),
  (90, 20, 90, 63, 3.67),
  (91, 20, 91, 90, 10.36),
  (92, 20, 92, 48, 3.23),
  (93, 20, 93, 100, 4.88),
  (94, 20, 94, 28, 31.97),
  (95, 20, 95, 62, 5.27),
  (96, 20, 96, 15.616, 24.41),
  (97, 20, 97, 14.856, 7.23),
  (98, 20, 98, 93, 21.44),
  (99, 20, 99, 15.776, 18.14),
  (100, 20, 100, 72, 9.09),
  (101, 20, 101, 32, 24.09),
  (102, 20, 102, 65, 16.55),
  (103, 20, 103, 79, 30.64),
  (104, 20, 104, 26, 24.55),
  (105, 20, 105, 32, 4.94),
  (106, 20, 106, 31.303, 28.62),
  (107, 20, 107, 33, 10.96),
  (108, 20, 108, 44, 20.16),
  (109, 20, 109, 12.486, 8.87),
  (110, 20, 110, 22.804, 30.98),
  (111, 20, 111, 10.412, 28.86),
  (112, 20, 112, 35.391, 6.13),
  (113, 20, 113, 28.869, 20.3),
  (114, 20, 114, 8.472, 5.98),
  (115, 20, 115, 32.114, 10.56),
  (116, 20, 116, 21.005, 18.4),
  (117, 20, 117, 35.669, 31.88),
  (118, 20, 118, 13.268, 3.07),
  (119, 20, 119, 20.493, 32.65),
  (120, 20, 120, 33.124, 12.13),
  (121, 20, 121, 30.291, 26.38),
  (122, 20, 122, 33.068, 24.18),
  (123, 20, 123, 23.573, 9.08),
  (124, 20, 124, 14.966, 4.87),
  (125, 20, 125, 31.544, 4.95),
  (126, 20, 126, 18.035, 4.6),
  (127, 20, 127, 81, 19.09);


INSERT INTO Lote (id_lote, id_insumo, id_item_compra, numero_lote, data_validade, data_recebimento, quantidade_inicial, status_lote) VALUES
  (1, 1, 1, 'MA-202610-0001', '2027-04-30', '2026-10-20 10:00:00', 34, 'DISPONIVEL'),
  (2, 2, 2, 'MA-202610-0002', '2027-04-30', '2026-10-20 10:00:00', 16.801, 'DISPONIVEL'),
  (3, 3, 3, 'MA-202610-0003', '2027-04-30', '2026-10-20 10:00:00', 31.567, 'DISPONIVEL'),
  (4, 4, 4, 'MA-202610-0004', '2027-04-30', '2026-10-20 10:00:00', 89, 'DISPONIVEL'),
  (5, 5, 5, 'MA-202610-0005', '2027-04-30', '2026-10-20 10:00:00', 74, 'DISPONIVEL'),
  (6, 6, 6, 'MA-202610-0006', '2027-04-30', '2026-10-20 10:00:00', 31, 'DISPONIVEL'),
  (7, 7, 7, 'MA-202610-0007', '2027-04-30', '2026-10-20 10:00:00', 84, 'DISPONIVEL'),
  (8, 8, 8, 'MA-202610-0008', '2027-04-30', '2026-10-20 10:00:00', 91, 'DISPONIVEL'),
  (9, 9, 9, 'MA-202610-0009', '2027-04-30', '2026-10-20 10:00:00', 89, 'DISPONIVEL'),
  (10, 10, 10, 'MA-202610-0010', '2027-04-30', '2026-10-20 10:00:00', 77, 'DISPONIVEL'),
  (11, 11, 11, 'MA-202610-0011', '2027-04-30', '2026-10-20 10:00:00', 20, 'DISPONIVEL'),
  (12, 12, 12, 'MA-202610-0012', '2027-04-30', '2026-10-20 10:00:00', 13.109, 'DISPONIVEL'),
  (13, 13, 13, 'MA-202610-0013', '2027-04-30', '2026-10-20 10:00:00', 55, 'DISPONIVEL'),
  (14, 14, 14, 'MA-202610-0014', '2027-04-30', '2026-10-20 10:00:00', 63, 'DISPONIVEL'),
  (15, 15, 15, 'MA-202610-0015', '2027-04-30', '2026-10-20 10:00:00', 68, 'DISPONIVEL'),
  (16, 16, 16, 'MA-202610-0016', '2027-04-30', '2026-10-20 10:00:00', 35.12, 'DISPONIVEL'),
  (17, 17, 17, 'MA-202610-0017', '2027-04-30', '2026-10-20 10:00:00', 25, 'DISPONIVEL'),
  (18, 18, 18, 'MA-202610-0018', '2027-04-30', '2026-10-20 10:00:00', 88, 'DISPONIVEL'),
  (19, 19, 19, 'MA-202610-0019', '2027-04-30', '2026-10-20 10:00:00', 68, 'DISPONIVEL'),
  (20, 20, 20, 'MA-202610-0020', '2027-04-30', '2026-10-20 10:00:00', 57, 'DISPONIVEL'),
  (21, 21, 21, 'MA-202610-0021', '2027-04-30', '2026-10-20 10:00:00', 99, 'DISPONIVEL'),
  (22, 22, 22, 'MA-202610-0022', '2027-04-30', '2026-10-20 10:00:00', 66, 'DISPONIVEL'),
  (23, 23, 23, 'MA-202610-0023', '2027-04-30', '2026-10-20 10:00:00', 28, 'DISPONIVEL'),
  (24, 24, 24, 'MA-202610-0024', '2027-04-30', '2026-10-20 10:00:00', 49, 'DISPONIVEL'),
  (25, 25, 25, 'MA-202610-0025', '2027-04-30', '2026-10-20 10:00:00', 30, 'DISPONIVEL'),
  (26, 26, 26, 'MA-202610-0026', '2027-04-30', '2026-10-20 10:00:00', 32, 'DISPONIVEL'),
  (27, 27, 27, 'MA-202610-0027', '2027-04-30', '2026-10-20 10:00:00', 78, 'DISPONIVEL'),
  (28, 28, 28, 'MA-202610-0028', '2027-04-30', '2026-10-20 10:00:00', 66, 'DISPONIVEL'),
  (29, 29, 29, 'MA-202610-0029', '2027-04-30', '2026-10-20 10:00:00', 65, 'DISPONIVEL'),
  (30, 30, 30, 'MA-202610-0030', '2027-04-30', '2026-10-20 10:00:00', 54, 'DISPONIVEL'),
  (31, 31, 31, 'MA-202610-0031', '2027-04-30', '2026-10-20 10:00:00', 29, 'DISPONIVEL'),
  (32, 32, 32, 'MA-202610-0032', '2027-04-30', '2026-10-20 10:00:00', 41, 'DISPONIVEL'),
  (33, 33, 33, 'MA-202610-0033', '2027-04-30', '2026-10-20 10:00:00', 15.834, 'DISPONIVEL'),
  (34, 34, 34, 'MA-202610-0034', '2027-04-30', '2026-10-20 10:00:00', 16.638, 'DISPONIVEL'),
  (35, 35, 35, 'MA-202610-0035', '2027-04-30', '2026-10-20 10:00:00', 30.021, 'DISPONIVEL'),
  (36, 36, 36, 'MA-202610-0036', '2027-04-30', '2026-10-20 10:00:00', 18.377, 'DISPONIVEL'),
  (37, 37, 37, 'MA-202610-0037', '2027-04-30', '2026-10-20 10:00:00', 27, 'DISPONIVEL'),
  (38, 38, 38, 'MA-202610-0038', '2027-04-30', '2026-10-20 10:00:00', 24, 'DISPONIVEL'),
  (39, 39, 39, 'MA-202610-0039', '2027-04-30', '2026-10-20 10:00:00', 71, 'DISPONIVEL'),
  (40, 40, 40, 'MA-202610-0040', '2027-04-30', '2026-10-20 10:00:00', 47, 'DISPONIVEL'),
  (41, 41, 41, 'MA-202610-0041', '2027-04-30', '2026-10-20 10:00:00', 92, 'DISPONIVEL'),
  (42, 42, 42, 'MA-202610-0042', '2027-04-30', '2026-10-20 10:00:00', 60, 'DISPONIVEL'),
  (43, 43, 43, 'MA-202610-0043', '2027-04-30', '2026-10-20 10:00:00', 83, 'DISPONIVEL'),
  (44, 44, 44, 'MA-202610-0044', '2027-04-30', '2026-10-20 10:00:00', 37.266, 'DISPONIVEL'),
  (45, 45, 45, 'MA-202610-0045', '2027-04-30', '2026-10-20 10:00:00', 16.476, 'DISPONIVEL'),
  (46, 46, 46, 'MA-202610-0046', '2027-04-30', '2026-10-20 10:00:00', 91, 'DISPONIVEL'),
  (47, 47, 47, 'MA-202610-0047', '2027-04-30', '2026-10-20 10:00:00', 94, 'DISPONIVEL'),
  (48, 48, 48, 'MA-202610-0048', '2027-04-30', '2026-10-20 10:00:00', 94, 'DISPONIVEL'),
  (49, 49, 49, 'MA-202610-0049', '2027-04-30', '2026-10-20 10:00:00', 48, 'DISPONIVEL'),
  (50, 50, 50, 'MA-202610-0050', '2027-04-30', '2026-10-20 10:00:00', 37, 'DISPONIVEL'),
  (51, 51, 51, 'MA-202610-0051', '2027-04-30', '2026-10-20 10:00:00', 31, 'DISPONIVEL'),
  (52, 52, 52, 'MA-202610-0052', '2027-04-30', '2026-10-20 10:00:00', 34, 'DISPONIVEL'),
  (53, 53, 53, 'MA-202610-0053', '2027-04-30', '2026-10-20 10:00:00', 40, 'DISPONIVEL'),
  (54, 54, 54, 'MA-202610-0054', '2027-04-30', '2026-10-20 10:00:00', 74, 'DISPONIVEL'),
  (55, 55, 55, 'MA-202610-0055', '2027-04-30', '2026-10-20 10:00:00', 69, 'DISPONIVEL'),
  (56, 56, 56, 'MA-202610-0056', '2027-04-30', '2026-10-20 10:00:00', 79, 'DISPONIVEL'),
  (57, 57, 57, 'MA-202610-0057', '2027-04-30', '2026-10-20 10:00:00', 90, 'DISPONIVEL'),
  (58, 58, 58, 'MA-202610-0058', '2027-04-30', '2026-10-20 10:00:00', 21, 'DISPONIVEL'),
  (59, 59, 59, 'MA-202610-0059', '2027-04-30', '2026-10-20 10:00:00', 11.666, 'DISPONIVEL'),
  (60, 60, 60, 'MA-202610-0060', '2027-04-30', '2026-10-20 10:00:00', 32.028, 'DISPONIVEL'),
  (61, 61, 61, 'MA-202610-0061', '2027-04-30', '2026-10-20 10:00:00', 63, 'DISPONIVEL'),
  (62, 62, 62, 'MA-202610-0062', '2027-04-30', '2026-10-20 10:00:00', 75, 'DISPONIVEL'),
  (63, 63, 63, 'MA-202610-0063', '2027-04-30', '2026-10-20 10:00:00', 20, 'DISPONIVEL'),
  (64, 64, 64, 'MA-202610-0064', '2027-04-30', '2026-10-20 10:00:00', 53, 'DISPONIVEL'),
  (65, 65, 65, 'MA-202610-0065', '2027-04-30', '2026-10-20 10:00:00', 42, 'DISPONIVEL'),
  (66, 66, 66, 'MA-202610-0066', '2027-04-30', '2026-10-20 10:00:00', 33, 'DISPONIVEL'),
  (67, 67, 67, 'MA-202610-0067', '2027-04-30', '2026-10-20 10:00:00', 17.55, 'DISPONIVEL'),
  (68, 68, 68, 'MA-202610-0068', '2027-04-30', '2026-10-20 10:00:00', 97, 'DISPONIVEL'),
  (69, 69, 69, 'MA-202610-0069', '2027-04-30', '2026-10-20 10:00:00', 67, 'DISPONIVEL'),
  (70, 70, 70, 'MA-202610-0070', '2027-04-30', '2026-10-20 10:00:00', 89, 'DISPONIVEL');


INSERT INTO Lote (id_lote, id_insumo, id_item_compra, numero_lote, data_validade, data_recebimento, quantidade_inicial, status_lote) VALUES
  (71, 71, 71, 'MA-202610-0071', '2027-04-30', '2026-10-20 10:00:00', 87, 'DISPONIVEL'),
  (72, 72, 72, 'MA-202610-0072', '2027-04-30', '2026-10-20 10:00:00', 96, 'DISPONIVEL'),
  (73, 73, 73, 'MA-202610-0073', '2027-04-30', '2026-10-20 10:00:00', 22, 'DISPONIVEL'),
  (74, 74, 74, 'MA-202610-0074', '2027-04-30', '2026-10-20 10:00:00', 66, 'DISPONIVEL'),
  (75, 75, 75, 'MA-202610-0075', '2027-04-30', '2026-10-20 10:00:00', 59, 'DISPONIVEL'),
  (76, 76, 76, 'MA-202610-0076', '2027-04-30', '2026-10-20 10:00:00', 50, 'DISPONIVEL'),
  (77, 77, 77, 'MA-202610-0077', '2027-04-30', '2026-10-20 10:00:00', 30, 'DISPONIVEL'),
  (78, 78, 78, 'MA-202610-0078', '2027-04-30', '2026-10-20 10:00:00', 23.552, 'DISPONIVEL'),
  (79, 79, 79, 'MA-202610-0079', '2027-04-30', '2026-10-20 10:00:00', 88, 'DISPONIVEL'),
  (80, 80, 80, 'MA-202610-0080', '2027-04-30', '2026-10-20 10:00:00', 36, 'DISPONIVEL'),
  (81, 81, 81, 'MA-202610-0081', '2027-04-30', '2026-10-20 10:00:00', 90, 'DISPONIVEL'),
  (82, 82, 82, 'MA-202610-0082', '2027-04-30', '2026-10-20 10:00:00', 87, 'DISPONIVEL'),
  (83, 83, 83, 'MA-202610-0083', '2027-04-30', '2026-10-20 10:00:00', 74, 'DISPONIVEL'),
  (84, 84, 84, 'MA-202610-0084', '2027-04-30', '2026-10-20 10:00:00', 89, 'DISPONIVEL'),
  (85, 85, 85, 'MA-202610-0085', '2027-04-30', '2026-10-20 10:00:00', 45, 'DISPONIVEL'),
  (86, 86, 86, 'MA-202610-0086', '2027-04-30', '2026-10-20 10:00:00', 71, 'DISPONIVEL'),
  (87, 87, 87, 'MA-202610-0087', '2027-04-30', '2026-10-20 10:00:00', 67, 'DISPONIVEL'),
  (88, 88, 88, 'MA-202610-0088', '2027-04-30', '2026-10-20 10:00:00', 86, 'DISPONIVEL'),
  (89, 89, 89, 'MA-202610-0089', '2027-04-30', '2026-10-20 10:00:00', 51, 'DISPONIVEL'),
  (90, 90, 90, 'MA-202610-0090', '2027-04-30', '2026-10-20 10:00:00', 63, 'DISPONIVEL'),
  (91, 91, 91, 'MA-202610-0091', '2027-04-30', '2026-10-20 10:00:00', 90, 'DISPONIVEL'),
  (92, 92, 92, 'MA-202610-0092', '2027-04-30', '2026-10-20 10:00:00', 48, 'DISPONIVEL'),
  (93, 93, 93, 'MA-202610-0093', '2027-04-30', '2026-10-20 10:00:00', 100, 'DISPONIVEL'),
  (94, 94, 94, 'MA-202610-0094', '2027-04-30', '2026-10-20 10:00:00', 28, 'DISPONIVEL'),
  (95, 95, 95, 'MA-202610-0095', '2027-04-30', '2026-10-20 10:00:00', 62, 'DISPONIVEL'),
  (96, 96, 96, 'MA-202610-0096', '2027-04-30', '2026-10-20 10:00:00', 15.616, 'DISPONIVEL'),
  (97, 97, 97, 'MA-202610-0097', '2027-04-30', '2026-10-20 10:00:00', 14.856, 'DISPONIVEL'),
  (98, 98, 98, 'MA-202610-0098', '2027-04-30', '2026-10-20 10:00:00', 93, 'DISPONIVEL'),
  (99, 99, 99, 'MA-202610-0099', '2027-04-30', '2026-10-20 10:00:00', 15.776, 'DISPONIVEL'),
  (100, 100, 100, 'MA-202610-0100', '2027-04-30', '2026-10-20 10:00:00', 72, 'DISPONIVEL'),
  (101, 101, 101, 'MA-202610-0101', '2027-04-30', '2026-10-20 10:00:00', 32, 'DISPONIVEL'),
  (102, 102, 102, 'MA-202610-0102', '2027-04-30', '2026-10-20 10:00:00', 65, 'DISPONIVEL'),
  (103, 103, 103, 'MA-202610-0103', '2027-04-30', '2026-10-20 10:00:00', 79, 'DISPONIVEL'),
  (104, 104, 104, 'MA-202610-0104', '2027-04-30', '2026-10-20 10:00:00', 26, 'DISPONIVEL'),
  (105, 105, 105, 'MA-202610-0105', '2027-04-30', '2026-10-20 10:00:00', 32, 'DISPONIVEL'),
  (106, 106, 106, 'MA-202610-0106', '2027-04-30', '2026-10-20 10:00:00', 31.303, 'DISPONIVEL'),
  (107, 107, 107, 'MA-202610-0107', '2027-04-30', '2026-10-20 10:00:00', 33, 'DISPONIVEL'),
  (108, 108, 108, 'MA-202610-0108', '2027-04-30', '2026-10-20 10:00:00', 44, 'DISPONIVEL'),
  (109, 109, 109, 'MA-202610-0109', '2027-04-30', '2026-10-20 10:00:00', 12.486, 'DISPONIVEL'),
  (110, 110, 110, 'MA-202610-0110', '2027-04-30', '2026-10-20 10:00:00', 22.804, 'DISPONIVEL'),
  (111, 111, 111, 'MA-202610-0111', '2027-04-30', '2026-10-20 10:00:00', 10.412, 'DISPONIVEL'),
  (112, 112, 112, 'MA-202610-0112', '2027-04-30', '2026-10-20 10:00:00', 35.391, 'DISPONIVEL'),
  (113, 113, 113, 'MA-202610-0113', '2027-04-30', '2026-10-20 10:00:00', 28.869, 'DISPONIVEL'),
  (114, 114, 114, 'MA-202610-0114', '2027-04-30', '2026-10-20 10:00:00', 8.472, 'DISPONIVEL'),
  (115, 115, 115, 'MA-202610-0115', '2027-04-30', '2026-10-20 10:00:00', 32.114, 'DISPONIVEL'),
  (116, 116, 116, 'MA-202610-0116', '2027-04-30', '2026-10-20 10:00:00', 21.005, 'DISPONIVEL'),
  (117, 117, 117, 'MA-202610-0117', '2027-04-30', '2026-10-20 10:00:00', 35.669, 'DISPONIVEL'),
  (118, 118, 118, 'MA-202610-0118', '2027-04-30', '2026-10-20 10:00:00', 13.268, 'DISPONIVEL'),
  (119, 119, 119, 'MA-202610-0119', '2027-04-30', '2026-10-20 10:00:00', 20.493, 'DISPONIVEL'),
  (120, 120, 120, 'MA-202610-0120', '2027-04-30', '2026-10-20 10:00:00', 33.124, 'DISPONIVEL'),
  (121, 121, 121, 'MA-202610-0121', '2027-04-30', '2026-10-20 10:00:00', 30.291, 'DISPONIVEL'),
  (122, 122, 122, 'MA-202610-0122', '2027-04-30', '2026-10-20 10:00:00', 33.068, 'DISPONIVEL'),
  (123, 123, 123, 'MA-202610-0123', '2027-04-30', '2026-10-20 10:00:00', 23.573, 'DISPONIVEL'),
  (124, 124, 124, 'MA-202610-0124', '2027-04-30', '2026-10-20 10:00:00', 14.966, 'DISPONIVEL'),
  (125, 125, 125, 'MA-202610-0125', '2027-04-30', '2026-10-20 10:00:00', 31.544, 'DISPONIVEL'),
  (126, 126, 126, 'MA-202610-0126', '2027-04-30', '2026-10-20 10:00:00', 18.035, 'DISPONIVEL'),
  (127, 127, 127, 'MA-202610-0127', '2027-04-30', '2026-10-20 10:00:00', 81, 'DISPONIVEL');


INSERT INTO MovimentacaoEstoque (id_movimentacao, id_lote, matricula_funcionario, id_pedido, tipo_movimentacao, quantidade, data_hora, motivo) VALUES
  (1, 1, 4, NULL, 'ENTRADA', 34, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (2, 2, 4, NULL, 'ENTRADA', 16.801, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (3, 3, 4, NULL, 'ENTRADA', 31.567, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (4, 4, 4, NULL, 'ENTRADA', 89, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (5, 5, 4, NULL, 'ENTRADA', 74, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (6, 6, 4, NULL, 'ENTRADA', 31, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (7, 7, 4, NULL, 'ENTRADA', 84, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (8, 8, 4, NULL, 'ENTRADA', 91, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (9, 9, 4, NULL, 'ENTRADA', 89, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (10, 10, 4, NULL, 'ENTRADA', 77, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (11, 11, 4, NULL, 'ENTRADA', 20, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (12, 12, 4, NULL, 'ENTRADA', 13.109, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (13, 13, 4, NULL, 'ENTRADA', 55, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (14, 14, 4, NULL, 'ENTRADA', 63, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (15, 15, 4, NULL, 'ENTRADA', 68, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (16, 16, 4, NULL, 'ENTRADA', 35.12, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (17, 17, 4, NULL, 'ENTRADA', 25, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (18, 18, 4, NULL, 'ENTRADA', 88, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (19, 19, 4, NULL, 'ENTRADA', 68, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (20, 20, 4, NULL, 'ENTRADA', 57, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (21, 21, 4, NULL, 'ENTRADA', 99, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (22, 22, 4, NULL, 'ENTRADA', 66, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (23, 23, 4, NULL, 'ENTRADA', 28, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (24, 24, 4, NULL, 'ENTRADA', 49, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (25, 25, 4, NULL, 'ENTRADA', 30, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (26, 26, 4, NULL, 'ENTRADA', 32, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (27, 27, 4, NULL, 'ENTRADA', 78, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (28, 28, 4, NULL, 'ENTRADA', 66, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (29, 29, 4, NULL, 'ENTRADA', 65, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (30, 30, 4, NULL, 'ENTRADA', 54, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (31, 31, 4, NULL, 'ENTRADA', 29, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (32, 32, 4, NULL, 'ENTRADA', 41, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (33, 33, 4, NULL, 'ENTRADA', 15.834, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (34, 34, 4, NULL, 'ENTRADA', 16.638, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (35, 35, 4, NULL, 'ENTRADA', 30.021, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (36, 36, 4, NULL, 'ENTRADA', 18.377, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (37, 37, 4, NULL, 'ENTRADA', 27, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (38, 38, 4, NULL, 'ENTRADA', 24, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (39, 39, 4, NULL, 'ENTRADA', 71, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (40, 40, 4, NULL, 'ENTRADA', 47, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (41, 41, 4, NULL, 'ENTRADA', 92, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (42, 42, 4, NULL, 'ENTRADA', 60, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (43, 43, 4, NULL, 'ENTRADA', 83, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (44, 44, 4, NULL, 'ENTRADA', 37.266, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (45, 45, 4, NULL, 'ENTRADA', 16.476, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (46, 46, 4, NULL, 'ENTRADA', 91, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (47, 47, 4, NULL, 'ENTRADA', 94, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (48, 48, 4, NULL, 'ENTRADA', 94, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (49, 49, 4, NULL, 'ENTRADA', 48, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (50, 50, 4, NULL, 'ENTRADA', 37, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (51, 51, 4, NULL, 'ENTRADA', 31, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (52, 52, 4, NULL, 'ENTRADA', 34, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (53, 53, 4, NULL, 'ENTRADA', 40, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (54, 54, 4, NULL, 'ENTRADA', 74, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (55, 55, 4, NULL, 'ENTRADA', 69, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (56, 56, 4, NULL, 'ENTRADA', 79, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (57, 57, 4, NULL, 'ENTRADA', 90, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (58, 58, 4, NULL, 'ENTRADA', 21, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (59, 59, 4, NULL, 'ENTRADA', 11.666, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (60, 60, 4, NULL, 'ENTRADA', 32.028, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (61, 61, 4, NULL, 'ENTRADA', 63, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (62, 62, 4, NULL, 'ENTRADA', 75, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (63, 63, 4, NULL, 'ENTRADA', 20, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (64, 64, 4, NULL, 'ENTRADA', 53, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (65, 65, 4, NULL, 'ENTRADA', 42, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (66, 66, 4, NULL, 'ENTRADA', 33, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (67, 67, 4, NULL, 'ENTRADA', 17.55, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (68, 68, 4, NULL, 'ENTRADA', 97, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (69, 69, 4, NULL, 'ENTRADA', 67, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (70, 70, 4, NULL, 'ENTRADA', 89, '2026-10-20 10:00:00', 'Recebimento da compra de teste');


INSERT INTO MovimentacaoEstoque (id_movimentacao, id_lote, matricula_funcionario, id_pedido, tipo_movimentacao, quantidade, data_hora, motivo) VALUES
  (71, 71, 4, NULL, 'ENTRADA', 87, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (72, 72, 4, NULL, 'ENTRADA', 96, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (73, 73, 4, NULL, 'ENTRADA', 22, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (74, 74, 4, NULL, 'ENTRADA', 66, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (75, 75, 4, NULL, 'ENTRADA', 59, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (76, 76, 4, NULL, 'ENTRADA', 50, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (77, 77, 4, NULL, 'ENTRADA', 30, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (78, 78, 4, NULL, 'ENTRADA', 23.552, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (79, 79, 4, NULL, 'ENTRADA', 88, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (80, 80, 4, NULL, 'ENTRADA', 36, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (81, 81, 4, NULL, 'ENTRADA', 90, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (82, 82, 4, NULL, 'ENTRADA', 87, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (83, 83, 4, NULL, 'ENTRADA', 74, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (84, 84, 4, NULL, 'ENTRADA', 89, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (85, 85, 4, NULL, 'ENTRADA', 45, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (86, 86, 4, NULL, 'ENTRADA', 71, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (87, 87, 4, NULL, 'ENTRADA', 67, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (88, 88, 4, NULL, 'ENTRADA', 86, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (89, 89, 4, NULL, 'ENTRADA', 51, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (90, 90, 4, NULL, 'ENTRADA', 63, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (91, 91, 4, NULL, 'ENTRADA', 90, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (92, 92, 4, NULL, 'ENTRADA', 48, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (93, 93, 4, NULL, 'ENTRADA', 100, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (94, 94, 4, NULL, 'ENTRADA', 28, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (95, 95, 4, NULL, 'ENTRADA', 62, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (96, 96, 4, NULL, 'ENTRADA', 15.616, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (97, 97, 4, NULL, 'ENTRADA', 14.856, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (98, 98, 4, NULL, 'ENTRADA', 93, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (99, 99, 4, NULL, 'ENTRADA', 15.776, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (100, 100, 4, NULL, 'ENTRADA', 72, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (101, 101, 4, NULL, 'ENTRADA', 32, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (102, 102, 4, NULL, 'ENTRADA', 65, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (103, 103, 4, NULL, 'ENTRADA', 79, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (104, 104, 4, NULL, 'ENTRADA', 26, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (105, 105, 4, NULL, 'ENTRADA', 32, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (106, 106, 4, NULL, 'ENTRADA', 31.303, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (107, 107, 4, NULL, 'ENTRADA', 33, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (108, 108, 4, NULL, 'ENTRADA', 44, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (109, 109, 4, NULL, 'ENTRADA', 12.486, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (110, 110, 4, NULL, 'ENTRADA', 22.804, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (111, 111, 4, NULL, 'ENTRADA', 10.412, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (112, 112, 4, NULL, 'ENTRADA', 35.391, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (113, 113, 4, NULL, 'ENTRADA', 28.869, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (114, 114, 4, NULL, 'ENTRADA', 8.472, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (115, 115, 4, NULL, 'ENTRADA', 32.114, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (116, 116, 4, NULL, 'ENTRADA', 21.005, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (117, 117, 4, NULL, 'ENTRADA', 35.669, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (118, 118, 4, NULL, 'ENTRADA', 13.268, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (119, 119, 4, NULL, 'ENTRADA', 20.493, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (120, 120, 4, NULL, 'ENTRADA', 33.124, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (121, 121, 4, NULL, 'ENTRADA', 30.291, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (122, 122, 4, NULL, 'ENTRADA', 33.068, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (123, 123, 4, NULL, 'ENTRADA', 23.573, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (124, 124, 4, NULL, 'ENTRADA', 14.966, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (125, 125, 4, NULL, 'ENTRADA', 31.544, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (126, 126, 4, NULL, 'ENTRADA', 18.035, '2026-10-20 10:00:00', 'Recebimento da compra de teste'),
  (127, 127, 4, NULL, 'ENTRADA', 81, '2026-10-20 10:00:00', 'Recebimento da compra de teste');


INSERT INTO Mesa (id_mesa, capacidade, numero, status_mesa) VALUES
  (1, 4, '1', 'LIVRE'),
  (2, 4, '2', 'LIVRE'),
  (3, 4, '3', 'LIVRE'),
  (4, 4, '4', 'LIVRE'),
  (5, 4, '5', 'LIVRE'),
  (6, 4, '6', 'LIVRE'),
  (7, 6, '7', 'LIVRE'),
  (8, 6, '8', 'LIVRE'),
  (9, 6, '9', 'LIVRE'),
  (10, 6, '10', 'LIVRE');


INSERT INTO Reserva (id_reserva, cpf, matricula_funcionario, quantidade_pessoas, data_hora_inicio, status) VALUES
  (1, '10000000009', 2, 4, '2026-11-01 19:00:00', 'PENDENTE'),
  (2, '10000000010', 2, 2, '2026-10-24 20:00:00', 'CONCLUIDA');


INSERT INTO ReservaMesa (id_reserva, id_mesa) VALUES
  (1, 1),
  (2, 2);


INSERT INTO Atendimento (id_atendimento, matricula_funcionario, id_reserva, hora_chegada, hora_saida, qtd_pessoas) VALUES
  (1, 2, 2, '2026-10-24 19:50:00', '2026-10-24 21:00:00', 2),
  (2, 6, NULL, '2026-10-25 19:00:00', '2026-10-25 20:00:00', 3);


INSERT INTO AtendimentoMesa (id_atendimento, id_mesa) VALUES
  (1, 2),
  (2, 3);


INSERT INTO Caixa (id_caixa, matricula_funcionario_abertura, matricula_funcionario_fechamento, data_abertura, data_fechamento, tipo_caixa, valor_abertura, valor_fechamento, status_caixa) VALUES
  (1, 5, 5, '2026-10-24 17:00:00', '2026-10-24 23:00:00', 'LOCAL', 200, 850, 'FECHADO'),
  (2, 8, 8, '2026-10-24 17:00:00', '2026-10-24 23:00:00', 'DELIVERY', 100, 500, 'FECHADO'),
  (3, 5, NULL, '2026-10-30 17:00:00', NULL, 'LOCAL', 200, NULL, 'ABERTO'),
  (4, 8, NULL, '2026-10-30 17:00:00', NULL, 'DELIVERY', 100, NULL, 'ABERTO');


INSERT INTO Pedido (id_pedido, cpf, id_mesa, matricula_funcionario, id_atendimento, data_hora, status_pedido, modalidade, canal_origem, data_hora_inicio_producao, data_hora_fim_producao) VALUES
  (1, '10000000009', NULL, 2, NULL, '2026-10-25 19:07:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (2, '10000000010', NULL, NULL, NULL, '2026-10-26 20:14:00', 'ENTREGUE', 'ENTREGA', '99FOOD', NULL, NULL),
  (3, '10000000011', 4, 2, NULL, '2026-10-27 21:21:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (4, '10000000012', NULL, 2, NULL, '2026-10-28 18:28:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (5, '10000000013', NULL, NULL, NULL, '2026-10-29 19:35:00', 'ENTREGUE', 'ENTREGA', 'IFOOD', NULL, NULL),
  (6, '10000000014', 7, 2, 1, '2026-10-24 20:42:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (7, '10000000015', NULL, 2, NULL, '2026-10-25 21:49:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (8, '10000000016', NULL, NULL, NULL, '2026-10-26 18:56:00', 'ENTREGUE', 'ENTREGA', '99FOOD', NULL, NULL),
  (9, '10000000017', 10, 2, NULL, '2026-10-27 19:03:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (10, '10000000018', NULL, 2, NULL, '2026-10-28 20:10:00', 'CANCELADO', 'RETIRADA', NULL, NULL, NULL),
  (11, '10000000019', NULL, NULL, NULL, '2026-10-29 21:17:00', 'ENTREGUE', 'ENTREGA', 'IFOOD', NULL, NULL),
  (12, '10000000020', 3, 2, 1, '2026-10-24 18:24:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (13, '10000000001', NULL, 2, NULL, '2026-10-25 19:31:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (14, '10000000002', NULL, NULL, NULL, '2026-10-26 20:38:00', 'ENTREGUE', 'ENTREGA', '99FOOD', NULL, NULL),
  (15, '10000000003', 6, 2, NULL, '2026-10-27 21:45:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (16, '10000000004', NULL, 2, NULL, '2026-10-28 18:52:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (17, '10000000005', NULL, NULL, NULL, '2026-10-29 19:59:00', 'ENTREGUE', 'ENTREGA', 'IFOOD', NULL, NULL),
  (18, '10000000006', 9, 2, 1, '2026-10-24 20:06:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (19, '10000000007', NULL, 2, NULL, '2026-10-25 21:13:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (20, '10000000008', NULL, NULL, NULL, '2026-10-26 18:20:00', 'CANCELADO', 'ENTREGA', '99FOOD', NULL, NULL),
  (21, '10000000009', 2, 2, NULL, '2026-10-27 19:27:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (22, '10000000010', NULL, 2, NULL, '2026-10-28 20:34:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (23, '10000000011', NULL, NULL, NULL, '2026-10-29 21:41:00', 'ENTREGUE', 'ENTREGA', 'IFOOD', NULL, NULL),
  (24, '10000000012', 5, 2, 1, '2026-10-24 18:48:00', 'ENTREGUE', 'LOCAL', NULL, NULL, NULL),
  (25, '10000000013', NULL, 2, NULL, '2026-10-25 19:55:00', 'ENTREGUE', 'RETIRADA', NULL, NULL, NULL),
  (26, '10000000014', NULL, NULL, NULL, '2026-10-26 20:02:00', 'ENTREGUE', 'ENTREGA', '99FOOD', NULL, NULL),
  (27, '10000000015', 8, 2, NULL, '2026-10-27 21:09:00', 'PENDENTE', 'LOCAL', NULL, NULL, NULL),
  (28, '10000000016', NULL, 2, NULL, '2026-10-28 18:16:00', 'PENDENTE', 'RETIRADA', NULL, NULL, NULL),
  (29, '10000000017', NULL, NULL, NULL, '2026-10-29 19:23:00', 'PENDENTE', 'ENTREGA', 'IFOOD', NULL, NULL),
  (30, '10000000018', 1, 2, 1, '2026-10-24 20:30:00', 'PENDENTE', 'LOCAL', NULL, NULL, NULL);


INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
  (1, 2, 1, 35, NULL),
  (2, 3, 1, 35, NULL),
  (3, 4, 1, 41, NULL),
  (5, 6, 1, 34, NULL),
  (6, 7, 1, 35, NULL),
  (7, 8, 1, 40, NULL),
  (9, 1, 1, 35, NULL),
  (10, 2, 1, 35, NULL),
  (11, 3, 1, 35, NULL),
  (13, 5, 1, 19, NULL),
  (14, 6, 1, 34, NULL),
  (15, 7, 1, 35, NULL),
  (17, 9, 1, 39, NULL),
  (18, 1, 1, 35, NULL),
  (19, 2, 1, 35, NULL),
  (21, 4, 1, 41, NULL),
  (22, 5, 1, 19, NULL),
  (23, 6, 1, 34, NULL),
  (25, 8, 1, 40, NULL),
  (26, 9, 1, 39, NULL),
  (27, 1, 1, 35, NULL),
  (29, 3, 1, 35, NULL),
  (30, 4, 1, 41, NULL);


INSERT INTO ItemComboPedido (id_pedido, id_combo, quantidade, preco_unitario, observacao) VALUES
  (4, 5, 1, 27, NULL),
  (8, 9, 1, 47, NULL),
  (12, 4, 1, 49, NULL),
  (16, 8, 1, 48, NULL),
  (20, 3, 1, 43, NULL),
  (24, 7, 1, 43, NULL),
  (28, 2, 1, 43, NULL);


INSERT INTO Pagamento (id_pagamento, id_pedido, id_caixa, id_forma_pagamento, data_hora, status_pagamento, valor_total, referencia_externa) VALUES
  (1, 1, 1, 2, '2026-10-25 19:07:00', 'APROVADO', 35, NULL),
  (2, 2, 2, 3, '2026-10-26 20:14:00', 'APROVADO', 35, NULL),
  (3, 3, 1, 4, '2026-10-27 21:21:00', 'APROVADO', 41, NULL),
  (4, 4, 1, 1, '2026-10-28 18:28:00', 'APROVADO', 27, NULL),
  (5, 5, 2, 2, '2026-10-29 19:35:00', 'APROVADO', 34, NULL),
  (6, 6, 1, 3, '2026-10-24 20:42:00', 'APROVADO', 35, NULL),
  (7, 7, 1, 4, '2026-10-25 21:49:00', 'APROVADO', 40, NULL),
  (8, 8, 2, 1, '2026-10-26 18:56:00', 'APROVADO', 47, NULL),
  (9, 9, 1, 2, '2026-10-27 19:03:00', 'APROVADO', 35, NULL),
  (11, 11, 2, 4, '2026-10-29 21:17:00', 'APROVADO', 35, NULL),
  (12, 12, 1, 1, '2026-10-24 18:24:00', 'APROVADO', 49, NULL),
  (13, 13, 1, 2, '2026-10-25 19:31:00', 'APROVADO', 19, NULL),
  (14, 14, 2, 3, '2026-10-26 20:38:00', 'APROVADO', 34, NULL),
  (15, 15, 1, 4, '2026-10-27 21:45:00', 'APROVADO', 35, NULL),
  (16, 16, 1, 1, '2026-10-28 18:52:00', 'APROVADO', 48, NULL),
  (17, 17, 2, 2, '2026-10-29 19:59:00', 'APROVADO', 39, NULL),
  (18, 18, 1, 3, '2026-10-24 20:06:00', 'APROVADO', 35, NULL),
  (19, 19, 1, 4, '2026-10-25 21:13:00', 'APROVADO', 35, NULL),
  (21, 21, 1, 2, '2026-10-27 19:27:00', 'APROVADO', 41, NULL),
  (22, 22, 1, 3, '2026-10-28 20:34:00', 'APROVADO', 19, NULL),
  (23, 23, 2, 4, '2026-10-29 21:41:00', 'APROVADO', 34, NULL),
  (24, 24, 1, 1, '2026-10-24 18:48:00', 'APROVADO', 43, NULL),
  (25, 25, 1, 2, '2026-10-25 19:55:00', 'APROVADO', 40, NULL),
  (26, 26, 2, 3, '2026-10-26 20:02:00', 'APROVADO', 39, NULL);


INSERT INTO Entregador (id_entregador, matricula_funcionario, tipo_vinculo, plataforma, identificador_externo) VALUES
  (1, NULL, 'EXTERNO', 'IFOOD', 'ENT-TESTE-01'),
  (2, NULL, 'EXTERNO', '99FOOD', 'ENT-TESTE-02');


INSERT INTO Entrega (id_entrega, id_pedido, id_entregador, id_endereco, status_entrega, taxa_entrega, data_saida, data_chegada) VALUES
  (1, 2, 2, 3, 'ENTREGUE', 6, '2026-10-26 20:14:00', '2026-10-26 20:14:00'),
  (2, 5, 1, 6, 'ENTREGUE', 6, '2026-10-29 19:35:00', '2026-10-29 19:35:00'),
  (3, 8, 2, 9, 'ENTREGUE', 6, '2026-10-26 18:56:00', '2026-10-26 18:56:00'),
  (4, 11, 1, 12, 'ENTREGUE', 6, '2026-10-29 21:17:00', '2026-10-29 21:17:00'),
  (5, 14, 2, 3, 'ENTREGUE', 6, '2026-10-26 20:38:00', '2026-10-26 20:38:00'),
  (6, 17, 1, 6, 'ENTREGUE', 6, '2026-10-29 19:59:00', '2026-10-29 19:59:00'),
  (7, 20, 2, 9, 'PENDENTE', 6, NULL, NULL),
  (8, 23, 1, 12, 'ENTREGUE', 6, '2026-10-29 21:41:00', '2026-10-29 21:41:00'),
  (9, 26, 2, 3, 'ENTREGUE', 6, '2026-10-26 20:02:00', '2026-10-26 20:02:00'),
  (10, 29, 1, 6, 'PENDENTE', 6, NULL, NULL);


INSERT INTO EventoEntrega (id_evento_entrega, id_entrega, origem_atualizacao, data_hora, status_entrega) VALUES
  (1, 1, '99FOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (2, 2, 'IFOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (3, 3, '99FOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (4, 4, 'IFOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (5, 5, '99FOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (6, 6, 'IFOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (7, 7, '99FOOD', '2026-10-29 20:00:00', 'PENDENTE'),
  (8, 8, 'IFOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (9, 9, '99FOOD', '2026-10-29 20:00:00', 'ENTREGUE'),
  (10, 10, 'IFOOD', '2026-10-29 20:00:00', 'PENDENTE');


INSERT INTO Avaliacao (id_avaliacao, id_pedido, comentario, data, nota) VALUES
  (1, 3, 'Atendimento de teste', '2026-10-27 21:21:00', 5),
  (2, 6, 'Atendimento de teste', '2026-10-24 20:42:00', 4),
  (3, 9, 'Atendimento de teste', '2026-10-27 19:03:00', 5),
  (4, 12, 'Atendimento de teste', '2026-10-24 18:24:00', 4),
  (5, 15, 'Atendimento de teste', '2026-10-27 21:45:00', 5),
  (6, 18, 'Atendimento de teste', '2026-10-24 20:06:00', 4),
  (7, 21, 'Atendimento de teste', '2026-10-27 19:27:00', 5),
  (8, 24, 'Atendimento de teste', '2026-10-24 18:48:00', 4);


INSERT INTO Ocorrencia (id_ocorrencia, id_pedido, matricula_funcionario_responsavel, classificacao, descricao, consumo_produto, data_hora, status_ocorrencia) VALUES
  (1, 3, 2, 'ATRASO_PEDIDO', 'Atraso no preparo (teste)', 'CONSUMO', '2026-10-27 20:00:00', 'RESOLVIDA'),
  (2, 6, 2, 'PRODUTO_INCORRETO', 'Produto divergente (teste)', 'CONSUMO_PARCIAL', '2026-10-28 20:00:00', 'EM ANALISE');


INSERT INTO Reembolso (id_reembolso, id_ocorrencia, id_pagamento, valor_reembolso, data_hora, status_reembolso) VALUES
  (1, 1, 3, 10, '2026-10-28 10:00:00', 'CONCLUIDO');


INSERT INTO Promocao (id_promocao, nome, status_promocao, tipo) VALUES
  (1, 'Aniversariante - teste', 'ATIVA', 'ANIVRSARIANTE'),
  (2, 'Combo da semana - teste', 'ATIVA', 'COMBO PROMOCIONAL');


INSERT INTO PromocaoProduto (id_produto, id_promocao, percentual_desconto, quantidade_limite) VALUES
  (1, 1, 10, 50),
  (2, 1, 10, 50);


INSERT INTO PromocaoCombo (id_combo, id_promocao, percentual_desconto, quantidade_limite) VALUES
  (1, 2, 8, 100),
  (4, 2, 8, 100);


INSERT INTO ProdutoDestaque (id_produto_destaque, id_produto, quantidade_vendida, posicao_ranking, data_inicio, data_fim) VALUES
  (1, 1, 8, 1, '2026-10-01', '2026-10-30'),
  (2, 2, 6, 2, '2026-10-01', '2026-10-30');


INSERT INTO ComboDestaque (id_combo_destaque, id_combo, quantidade_vendida, posicao_ranking, data_inicio, data_fim) VALUES
  (1, 1, 3, 1, '2026-10-01', '2026-10-30');


INSERT INTO Despesa (id_despesa, matricula_funcionario, id_forma_pagamento, id_compra, descricao, valor, data_vencimento, data_pagamento, status_despesa) VALUES
  (1, 1, 1, NULL, 'Energia eletrica - teste', 850, '2026-11-10', NULL, 'PENDENTE'),
  (2, 1, 1, NULL, 'Internet - teste', 160, '2026-10-20', '2026-10-19', 'PAGA'),
  (3, 4, 1, 1, 'Compra PMG - teste', 350, '2026-10-30', NULL, 'PENDENTE'),
  (4, 1, 1, NULL, 'Aluguel - teste', 3500, '2026-11-05', NULL, 'PENDENTE');


COMMIT; -- comando que confirma e grava de forma definitiva


-- VERIFICACOES
SELECT COUNT(*) AS total_produtos FROM Produto;
SELECT COUNT(*) AS total_insumos FROM Insumo;
SELECT COUNT(*) AS total_lotes FROM Lote;
SELECT * FROM vw_estoque_insumos ORDER BY nome LIMIT 20;
-- Reafirma as VIEWs de mais vendidos considerando pedidos ENTREGUE:
CREATE OR REPLACE VIEW vw_produtos_mais_vendidos AS
SELECT pr.id_produto, pr.nome, SUM(ip.quantidade) AS quantidade_vendida
FROM Produto pr JOIN ItemPedido ip ON ip.id_produto=pr.id_produto
JOIN Pedido p ON p.id_pedido=ip.id_pedido
WHERE p.status_pedido='ENTREGUE'
GROUP BY pr.id_produto, pr.nome;
CREATE OR REPLACE VIEW vw_combos_mais_vendidos AS
SELECT c.id_combo, c.nome, SUM(icp.quantidade) AS quantidade_vendida
FROM Combo c JOIN ItemComboPedido icp ON icp.id_combo=c.id_combo
JOIN Pedido p ON p.id_pedido=icp.id_pedido
WHERE p.status_pedido='ENTREGUE'
GROUP BY c.id_combo, c.nome;
SELECT * FROM vw_produtos_mais_vendidos ORDER BY quantidade_vendida DESC;
SELECT * FROM vw_combos_mais_vendidos ORDER BY quantidade_vendida DESC;

