# Modelo lógico relacional

> **Gerado automaticamente** de `sql/ddl/02_create_tables.sql` (PK sublinhada em negrito, FK com seta). O diagrama completo está em `docs/diagramas/der-logico.mmd` / `.png`.

- `setor` ( **id_setor**, nome )
- `cargo` ( **id_cargo**, nome, id_setor↗, pode_comprar, pode_autorizar )
- `pessoa` ( **id_pessoa**, cpf, nome, telefone, email, data_nascimento )
- `endereco` ( **id_endereco**, id_pessoa↗, logradouro, numero, complemento, bairro, cidade, uf, cep )
- `funcionario` ( **id_funcionario**, id_pessoa↗, id_cargo↗, salario_bruto, data_admissao, data_desligamento )
- `mesa` ( **id_mesa**, capacidade, status_mesa )
- `reserva` ( **id_reserva**, id_mesa↗, id_pessoa↗, nome_contato, id_funcionario↗, data_hora_inicio, data_hora_fim, status_reserva )
- `categoria_produto` ( **id_categoria_produto**, nome )
- `produto` ( **id_produto**, nome, descricao, id_categoria_produto↗, preco_venda, peso_g, tempo_preparo_min, disponivel, montagem_especial )
- `combo` ( **id_combo**, nome, descricao, preco_venda, ativo )
- `item_combo` ( **id_combo**↗, **id_produto**↗, quantidade )
- `favorito` ( **id_pessoa**↗, **id_produto**↗, data_hora_salvo )
- `categoria_insumo` ( **id_categoria_insumo**, nome )
- `insumo` ( **id_insumo**, nome, marca, id_categoria_insumo↗, unidade_medida, estoque_minimo )
- `ficha_tecnica` ( **id_produto**↗, **id_insumo**↗, quantidade )
- `fornecedor` ( **id_fornecedor**, cnpj, razao_social, telefone, email )
- `fornecedor_insumo` ( **id_fornecedor**↗, **id_insumo**↗, prazo_entrega_dias )
- `compra` ( **id_compra**, id_fornecedor↗, id_funcionario↗, data_hora_compra, status_compra, observacao )
- `item_compra` ( **id_compra**↗, **id_insumo**↗, quantidade, valor_total )
- `recebimento` ( **id_recebimento**, id_compra↗, id_funcionario↗, data_hora_recebimento, numero_nota_fiscal, observacao )
- `lote` ( **id_lote**, id_recebimento↗, id_insumo↗, codigo_lote, quantidade_recebida, data_validade )
- `promocao` ( **id_promocao**, nome, tipo_promocao, percentual_desconto, exige_documento, ativa )
- `forma_pagamento` ( **id_forma_pagamento**, nome, taxa_percentual )
- `caixa` ( **id_caixa**, terminal, id_funcionario_abertura↗, id_funcionario_fechamento↗, data_hora_abertura, data_hora_fechamento, valor_abertura, valor_contado_fechamento )
- `entregador` ( **id_entregador**, nome, telefone, vinculo )
- `pedido` ( **id_pedido**, id_pessoa↗, id_funcionario↗, id_mesa↗, id_promocao↗, id_funcionario_autorizador↗, canal, modalidade, status_pedido, data_hora_pedido, data_hora_inicio_preparo, data_hora_pronto, data_hora_encerramento, valor_desconto, documento_conferido )
- `item_pedido` ( **id_pedido**↗, **numero_item**, id_produto↗, quantidade, preco_unitario, observacao )
- `item_combo_pedido` ( **id_pedido**↗, **numero_item**, id_combo↗, quantidade, preco_unitario, observacao )
- `pagamento` ( **id_pagamento**, id_pedido↗, id_forma_pagamento↗, id_caixa↗, valor, data_hora_pagamento, status_pagamento )
- `ocorrencia` ( **id_ocorrencia**, id_pedido↗, id_funcionario_autorizador↗, tipo_ocorrencia, causa, houve_consumo, valor_reembolso, descricao, data_hora_ocorrencia )
- `entrega` ( **id_entrega**, id_pedido↗, id_endereco↗, id_entregador↗, taxa_entrega, status_entrega, data_hora_saida, data_hora_entrega )
- `avaliacao` ( **id_avaliacao**, id_pedido↗, tipo_avaliacao, nota, comentario, data_hora_avaliacao, status_tratamento, id_funcionario_responsavel↗ )
- `movimentacao_estoque` ( **id_movimentacao**, id_insumo↗, id_lote↗, id_pedido↗, id_funcionario↗, tipo_movimentacao, quantidade, data_hora_movimentacao, motivo )
- `conta_pagar` ( **id_conta_pagar**, id_compra↗, descricao, valor, data_vencimento, data_pagamento, status_conta )

## Chaves estrangeiras (todas com RESTRICT: o histórico não é apagado em cascata)

| Tabela | Coluna(s) | Referencia |
|---|---|---|
| cargo | id_setor | setor(id_setor) |
| endereco | id_pessoa | pessoa(id_pessoa) |
| funcionario | id_pessoa | pessoa(id_pessoa) |
| funcionario | id_cargo | cargo(id_cargo) |
| reserva | id_mesa | mesa(id_mesa) |
| reserva | id_pessoa | pessoa(id_pessoa) |
| reserva | id_funcionario | funcionario(id_funcionario) |
| produto | id_categoria_produto | categoria_produto(id_categoria_produto) |
| item_combo | id_combo | combo(id_combo) |
| item_combo | id_produto | produto(id_produto) |
| favorito | id_pessoa | pessoa(id_pessoa) |
| favorito | id_produto | produto(id_produto) |
| insumo | id_categoria_insumo | categoria_insumo(id_categoria_insumo) |
| ficha_tecnica | id_produto | produto(id_produto) |
| ficha_tecnica | id_insumo | insumo(id_insumo) |
| fornecedor_insumo | id_fornecedor | fornecedor(id_fornecedor) |
| fornecedor_insumo | id_insumo | insumo(id_insumo) |
| compra | id_fornecedor | fornecedor(id_fornecedor) |
| compra | id_funcionario | funcionario(id_funcionario) |
| item_compra | id_compra | compra(id_compra) |
| item_compra | id_insumo | insumo(id_insumo) |
| recebimento | id_compra | compra(id_compra) |
| recebimento | id_funcionario | funcionario(id_funcionario) |
| lote | id_recebimento | recebimento(id_recebimento) |
| lote | id_insumo | insumo(id_insumo) |
| caixa | id_funcionario_abertura | funcionario(id_funcionario) |
| caixa | id_funcionario_fechamento | funcionario(id_funcionario) |
| pedido | id_pessoa | pessoa(id_pessoa) |
| pedido | id_funcionario | funcionario(id_funcionario) |
| pedido | id_mesa | mesa(id_mesa) |
| pedido | id_promocao | promocao(id_promocao) |
| pedido | id_funcionario_autorizador | funcionario(id_funcionario) |
| item_pedido | id_pedido | pedido(id_pedido) |
| item_pedido | id_produto | produto(id_produto) |
| item_combo_pedido | id_pedido | pedido(id_pedido) |
| item_combo_pedido | id_combo | combo(id_combo) |
| pagamento | id_pedido | pedido(id_pedido) |
| pagamento | id_forma_pagamento | forma_pagamento(id_forma_pagamento) |
| pagamento | id_caixa | caixa(id_caixa) |
| ocorrencia | id_pedido | pedido(id_pedido) |
| ocorrencia | id_funcionario_autorizador | funcionario(id_funcionario) |
| entrega | id_pedido | pedido(id_pedido) |
| entrega | id_endereco | endereco(id_endereco) |
| entrega | id_entregador | entregador(id_entregador) |
| avaliacao | id_pedido | pedido(id_pedido) |
| avaliacao | id_funcionario_responsavel | funcionario(id_funcionario) |
| movimentacao_estoque | id_insumo | insumo(id_insumo) |
| movimentacao_estoque | id_lote | lote(id_lote) |
| movimentacao_estoque | id_pedido | pedido(id_pedido) |
| movimentacao_estoque | id_funcionario | funcionario(id_funcionario) |
| conta_pagar | id_compra | compra(id_compra) |

Total: 34 tabelas, 51 chaves estrangeiras.