-- ================================
-- consultas
-- ================================

USE montararat_banco;

-- CONSULTAS POR TABELA

-- 1. Pessoa: pessoas em ordem alfabetica
SELECT cpf, nome
FROM Pessoa
ORDER BY nome;

-- 2. Cargo: cargos do maior para o menor salario base
SELECT id_cargo, nome_cargo, salario_base
FROM Cargo
ORDER BY salario_base DESC;

-- 3. Funcionario: funcionarios ativos com nome e cargo
SELECT f.id_funcionario, p.nome, c.nome_cargo, f.data_admissao
FROM Funcionario f
JOIN Pessoa p ON p.cpf = f.cpf
JOIN Cargo c ON c.id_cargo = f.id_cargo
WHERE f.status_funcionario = 'ATIVO'
ORDER BY p.nome;

-- 4. Fornecedor: lista de fornecedores
SELECT id_fornecedor, nome, cnpj
FROM Fornecedor
ORDER BY nome;

-- 5. Endereco: enderecos cadastrados
SELECT id_endereco, cep, logradouro, numero, complemento
FROM Endereco;


-- 6. PessoaEndereco: endereco de cada pessoa
SELECT p.nome, e.logradouro, e.numero, e.cep
FROM PessoaEndereco pe
JOIN Pessoa p ON p.cpf = pe.cpf
JOIN Endereco e ON e.id_endereco = pe.id_endereco
ORDER BY p.nome;


-- 7. Telefone: telefones com o titular (pessoa ou fornecedor)
SELECT t.id_telefone,
       COALESCE(p.nome, f.nome) AS titular,
       CONCAT('(', t.ddd, ') ', t.numero) AS telefone
FROM Telefone t
LEFT JOIN Pessoa p ON p.cpf = t.cpf
LEFT JOIN Fornecedor f ON f.id_fornecedor = t.id_fornecedor;

-- 8. Email: emails com o titular (pessoa ou fornecedor)
SELECT e.id_email,
       COALESCE(p.nome, f.nome) AS titular, -- COALESCE retorna o 
       e.email,                             -- primeiro valor que NÃO seja NULL
       e.tipo
FROM Email e
LEFT JOIN Pessoa p ON p.cpf = e.cpf
LEFT JOIN Fornecedor f ON f.id_fornecedor = e.id_fornecedor;

-- 9. FormaPagamento: formas de pagamento aceitas
SELECT id_forma_pagamento, tipo
FROM FormaPagamento;

-- 10. Categoria: categorias de produto
SELECT * FROM Categoria;

-- 11. Produto: produtos disponiveis com sua categoria
SELECT p.id_produto, p.nome, c.nome AS categoria, p.preco_base, p.tempo_preparo_min
FROM Produto p
JOIN Categoria c ON c.id_categoria = p.id_categoria
WHERE p.disponivel = TRUE
ORDER BY c.nome, p.nome;

-- 12. Combo: combos do mais barato ao mais caro
SELECT id_combo, nome, preco_combo, descricao
FROM Combo
ORDER BY preco_combo;

-- 13. ItemCombo: composicao de cada combo
SELECT c.nome AS combo, p.nome AS produto, ic.quantidade_prod
FROM ItemCombo ic
JOIN Combo c ON c.id_combo = ic.id_combo
JOIN Produto p ON p.id_produto = ic.id_produto
ORDER BY c.nome;

-- 14. Insumo: insumos e quantidade minima em estoque
SELECT id_insumo, nome, unidade_medida, quantidade_minima
FROM Insumo
ORDER BY nome;

-- 15. FichaTecnica: receita de cada produto
SELECT p.nome AS produto, i.nome AS insumo, ft.quantidade_necessaria, i.unidade_medida
FROM FichaTecnica ft
JOIN Produto p ON p.id_produto = ft.id_produto
JOIN Insumo i ON i.id_insumo = ft.id_insumo
ORDER BY p.nome;

-- 16. Compra: compras com fornecedor e responsavel
SELECT c.id_compra, f.nome AS fornecedor, pe.nome AS responsavel,
       c.data_compra, c.status_compra
FROM Compra c
JOIN Fornecedor f ON f.id_fornecedor = c.id_fornecedor
JOIN Funcionario fu ON fu.id_funcionario = c.id_funcionario
JOIN Pessoa pe ON pe.cpf = fu.cpf
ORDER BY c.data_compra DESC;


-- 17. ItemCompra: itens de cada compra com preço, quantidade e unidade de medida
SELECT ic.id_compra,
       i.nome AS insumo,
       ic.quantidade_solicitada,
       i.unidade_medida,
       CONCAT(ic.quantidade_solicitada, ' ', i.unidade_medida) AS quantidade_com_unidade,
       ic.preco_unitario
FROM ItemCompra ic
JOIN Insumo i ON i.id_insumo = ic.id_insumo
ORDER BY ic.id_compra, i.nome;


-- 18. Lote: lotes que vencem primeiro (ainda disponiveis)
SELECT l.id_lote, i.nome AS insumo, l.numero_lote, l.data_validade, l.status_lote
FROM Lote l
JOIN Insumo i ON i.id_insumo = l.id_insumo
WHERE l.status_lote = 'DISPONIVEL'
ORDER BY l.data_validade;

-- 19. Mesa: situacao atual das mesas
SELECT id_mesa, numero, capacidade, status_mesa
FROM Mesa
ORDER BY numero;

-- 20. Reserva: reservas pendentes com cliente e atendente
SELECT r.id_reserva, p.nome AS cliente, r.quantidade_pessoas,
       r.data_hora_inicio, r.status
FROM Reserva r
JOIN Pessoa p ON p.cpf = r.cpf
WHERE r.status = 'PENDENTE'
ORDER BY r.data_hora_inicio;

-- 20.5 todas as reservas e seus status complets 
-- (data_hora_inicio , qtd pessoas, id_funcionario, cpf e id_reserva)
SELECT * from reserva;

-- 21. ReservaMesa: mesas reservadas por reserva
SELECT rm.id_reserva, m.numero AS mesa, m.capacidade
FROM ReservaMesa rm
JOIN Mesa m ON m.id_mesa = rm.id_mesa
ORDER BY rm.id_reserva;

-- 22. Atendimento: atendimentos com duracao em minutos
SELECT a.id_atendimento, a.hora_chegada, a.hora_saida, a.qtd_pessoas,
       TIMESTAMPDIFF(MINUTE, a.hora_chegada, a.hora_saida) AS duracao_min
FROM Atendimento a
ORDER BY a.hora_chegada DESC;

-- 23. AtendimentoMesa: mesas usadas em cada atendimento
SELECT am.id_atendimento, m.numero AS mesa
FROM AtendimentoMesa am
JOIN Mesa m ON m.id_mesa = am.id_mesa
ORDER BY am.id_atendimento;

-- 24. Caixa: caixas abertos ou fechados com diferenca de valores
SELECT id_caixa, tipo_caixa, status_caixa, data_abertura, data_fechamento,
       valor_abertura, valor_fechamento,
       valor_fechamento - valor_abertura AS diferenca
FROM Caixa
ORDER BY data_abertura DESC;

-- : pedidos com cliente, modalidade e status
SELECT p.id_pedido, pe.nome AS cliente, p.modalidade, p.canal_origem,
       p.status_pedido, p.data_hora
FROM Pedido p
JOIN Pessoa pe ON pe.cpf = p.cpf
ORDER BY p.data_hora DESC;

-- 25. Pedido
SELECT * FROM pedido;

-- 26. ItemPedido: itens de pedido com quantidade e preço unitário
SELECT ip.id_pedido, pr.nome AS produto, ip.quantidade, ip.preco_unitario,
       ip.observacao
FROM ItemPedido ip
JOIN Produto pr ON pr.id_produto = ip.id_produto
ORDER BY ip.id_pedido;

-- 27. ItemComboPedido: combos pedidos com quantidade e preço unitário
SELECT icp.id_pedido, c.nome AS combo, icp.quantidade, icp.preco_unitario
FROM ItemComboPedido icp
JOIN Combo c ON c.id_combo = icp.id_combo
ORDER BY icp.id_pedido;

-- 28. Pagamento
SELECT * from pagamento;

-- 29. Entregador: entregadores e tipo de vinculo
SELECT e.id_entregador, e.tipo_vinculo, e.plataforma, e.identificador_externo,
       p.nome AS funcionario
FROM Entregador e
LEFT JOIN Funcionario f ON f.id_funcionario = e.id_funcionario
LEFT JOIN Pessoa p ON p.cpf = f.cpf;

-- 30. Entrega: entregas com endereco, taxa e status
SELECT en.id_entrega, en.id_pedido, en.status_entrega, en.taxa_entrega,
       e.logradouro, e.numero, en.data_saida, en.data_chegada
FROM Entrega en
JOIN Endereco e ON e.id_endereco = en.id_endereco
ORDER BY en.id_entrega DESC;

-- 31. EventoEntrega: historico de status de uma entrega
SELECT id_evento_entrega, id_entrega, origem_atualizacao, status_entrega, data_hora
FROM EventoEntrega
ORDER BY id_entrega, data_hora;

-- 32. Avaliacao: avaliacoes e media geral
SELECT a.id_avaliacao, a.id_pedido, a.nota, a.comentario, a.data,
       (SELECT ROUND(AVG(nota), 2) FROM Avaliacao) AS media_geral
FROM Avaliacao a
ORDER BY a.data DESC;

-- 33. Ocorrencia: ocorrencias em aberto
SELECT o.id_ocorrencia, o.id_pedido, o.classificacao, o.consumo_produto,
       o.status_ocorrencia, o.data_hora
FROM Ocorrencia o
WHERE o.status_ocorrencia IN ('ABERTA', 'EM ANALISE')
ORDER BY o.data_hora;

-- 34. Reembolso: reembolsos com a ocorrencia que os originou
SELECT r.id_reembolso, r.id_ocorrencia, o.classificacao, r.valor_reembolso,
       r.status_reembolso, r.data_hora
FROM Reembolso r
JOIN Ocorrencia o ON o.id_ocorrencia = r.id_ocorrencia
ORDER BY r.data_hora DESC;

-- 35. Promocao: promocoes ativas
SELECT id_promocao, nome, tipo, data_inicio, data_fim, status_promocao
FROM Promocao
WHERE status_promocao = 'ATIVA'
ORDER BY data_fim;

-- 36. PromocaoProduto: produtos em promocao com preco final
SELECT pr.nome AS promocao, p.nome AS produto, p.preco_base,
       pp.percentual_desconto,
       ROUND(p.preco_base * (1 - pp.percentual_desconto / 100), 2) AS preco_final,
       pp.quantidade_limite
FROM PromocaoProduto pp
JOIN Promocao pr ON pr.id_promocao = pp.id_promocao
JOIN Produto p ON p.id_produto = pp.id_produto;

-- 37. PromocaoCombo: combos em promocao com preco final
SELECT pr.nome AS promocao, c.nome AS combo, c.preco_combo,
       pc.percentual_desconto,
       ROUND(c.preco_combo * (1 - pc.percentual_desconto / 100), 2) AS preco_final,
       pc.quantidade_limite
FROM PromocaoCombo pc
JOIN Promocao pr ON pr.id_promocao = pc.id_promocao
JOIN Combo c ON c.id_combo = pc.id_combo;

-- 38. MovimentacaoEstoque: ultimas movimentacoes de estoque
SELECT m.id_movimentacao, i.nome AS insumo, l.numero_lote, m.tipo_movimentacao,
       m.quantidade, m.data_hora, m.motivo
FROM MovimentacaoEstoque m
JOIN Lote l ON l.id_lote = m.id_lote
JOIN Insumo i ON i.id_insumo = l.id_insumo
ORDER BY m.data_hora DESC
LIMIT 50;

-- 39. Despesa: despesas pendentes ou vencidas
SELECT id_despesa, descricao, valor, data_vencimento, data_pagamento, status_despesa
FROM Despesa
WHERE status_despesa IN ('PENDENTE', 'VENCIDA')
ORDER BY data_vencimento;

-- =====================================================
-- CONSULTAS POR VIEW
-- =====================================================

-- 40. vw_estoque_insumos
SELECT *
FROM vw_estoque_insumos;

-- 41. vw_produtos_mais_vendidos
SELECT * FROM vw_produtos_mais_vendidos;


-- 42. vw_combos_mais_vendido
SELECT * FROM vw_combos_mais_vendidos;


-- 43. vw_fila_prioridade_pedidos (local primeiro, depois mais antigos)
SELECT *
FROM vw_fila_prioridade_pedidos
ORDER BY prioridade, data_hora;

-- 44. vw_lanches_mais_vendidos 
SELECT * FROM vw_lanches_mais_vendidos;

-- Q1: produtos mais vendidos no mês corrente (RF06, RF18) 
SELECT p.nome, SUM(ip.quantidade) AS quantidade_vendida 
FROM item_pedido ip 
JOIN produto p ON p.id_produto = ip.id_produto 
JOIN pedido pe ON pe.id_pedido = ip.id_pedido 
WHERE pe.status_pedido = 'CONCLUIDO' 
  AND pe.data_hora >= DATE_FORMAT(CURDATE(), '%Y-%m-01') 
GROUP BY p.nome 
ORDER BY quantidade_vendida DESC 
LIMIT 10; 


