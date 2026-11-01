# Normalização — Hamburgueria MontArarat

## Normalização 1

| Entidade | Atributos |
| --- | --- |
| **Pessoa** | `cpf(PK)`<br>`nome` |
| **Funcionario** | `id_funcionario(PK)`<br>`cpf(FK)`<br>`id_cargo(FK)`<br>`data_admissao` |
| **Cargo** | `id_cargo(PK)`<br>`nome_cargo`<br>`salario_base` |
| **Pedido** | `id_pedido(PK)`<br>`cpf(FK)`<br>`id_mesa(FK)`<br>`id_funcionario(FK)`<br>`id_atendimento(FK)`<br>`data_hora`<br>`status_pedido`<br>`modalidade`<br>`canal_origem`<br>`data_hora_inicio_producao`<br>`data_hora_fim_producao` |
| **Ocorrencia** | `id_ocorrencia(PK)`<br>`id_pedido(FK)`<br>`id_funcionario_responsavel(FK)`<br>`classificacao`<br>`descricao`<br>`consumo_produto`<br>`data_hora`<br>`status` |
| **Produto** | `id_produto(PK)`<br>`id_categoria(FK)`<br>`nome`<br>`preco_base`<br>`descricao`<br>`montagem_especial`<br>`tempo_preparo_min`<br>`disponivel` |
| **Despesa** | `id_despesa(PK)`<br>`id_funcionario(FK)`<br>`id_forma_pagamento(FK)`<br>`id_compra(FK)`<br>`descricao`<br>`valor`<br>`data_vencimento`<br>`data_pagamento`<br>`status` |
| **Categoria** | `id_categoria(PK)`<br>`tipo` |
| **Promocao** | `id_promocao(PK)`<br>`nome`<br>`tipo`<br>`status`<br>`data_inicio`<br>`data_fim` |
| **PromocaoProduto** | `id_promocao(PK/FK)`<br>`id_produto(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemPedido** | `id_pedido(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **ItemComboPedido** | `id_pedido(PK/FK)`<br>`id_combo(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **Combo** | `id_combo(PK)`<br>`nome`<br>`preco_combo`<br>`descricao` |
| **PromocaoCombo** | `id_promocao(PK/FK)`<br>`id_combo(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemCombo** | `id_combo(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade` |
| **FichaTecnica** | `id_produto(PK/FK)`<br>`id_insumo(PK/FK)`<br>`quantidade_necessaria` |
| **Insumo** | `id_insumo(PK)`<br>`nome`<br>`unidade_medida`<br>`quantidade_minima` |
| **Compra** | `id_compra(PK)`<br>`id_fornecedor(FK)`<br>`id_funcionario(FK)`<br>`data_compra`<br>`status_compra` |
| **ItemCompra** | `id_item_compra(PK)`<br>`id_compra(FK)`<br>`id_lote(FK)`<br>`quantidade_solicitada`<br>`preco_unitario` |
| **Lote** | `id_lote(PK)`<br>`id_insumo(FK)`<br>`numero_lote`<br>`quantidade_inicial`<br>`data_recebimento`<br>`data_validade`<br>`status_lote` |
| **Fornecedor** | `id_fornecedor(PK)`<br>`cnpj`<br>`nome` |
| **MovimentacaoEstoque** | `id_movimentacao(PK)`<br>`id_lote(FK)`<br>`id_funcionario(FK)`<br>`id_pedido(FK)`<br>`tipo_movimentacao`<br>`quantidade`<br>`data_hora`<br>`motivo` |
| **Avaliacao** | `id_avaliacao(PK)`<br>`id_pedido(FK)`<br>`nota`<br>`comentario`<br>`data` |
| **Mesa** | `id_mesa(PK)`<br>`numero`<br>`capacidade`<br>`status` |
| **Entrega** | `id_entrega(PK)`<br>`id_pedido(FK)`<br>`id_entregador(FK)`<br>`id_endereco(FK)`<br>`status`<br>`taxa_entrega`<br>`data_saida` |
| **EventoEntrega** | `id_evento_entrega(PK)`<br>`id_entrega(FK)`<br>`origem_atualizacao`<br>`data_hora`<br>`status_pagamento` |
| **Pagamento** | `id_pagamento(PK)`<br>`id_pedido(FK)`<br>`id_caixa(FK)`<br>`id_forma_pagamento(FK)`<br>`data_hora`<br>`status`<br>`valor_total`<br>`referencia_externa` |
| **Telefone** | `id_telefone(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`ddd`<br>`numero` |
| **Email** | `id_email(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`email`<br>`tipo` |
| **Endereco** | `id_endereco(PK)`<br>`cep`<br>`logradouro`<br>`numero`<br>`complemento` |
| **PessoaEndereco** | `id_endereco(PK/FK)`<br>`cpf(PK/FK)` |
| **Caixa** | `id_caixa(PK)`<br>`id_funcionario_abertura(FK)`<br>`id_funcionario_fechamento(FK)`<br>`tipo_caixa`<br>`data_abertura`<br>`data_fechamento`<br>`valor_abertura`<br>`valor_fechamento`<br>`status` |
| **FormaPagamento** | `id_forma_pagamento(PK)`<br>`tipo` |
| **Reserva** | `id_reserva(PK)`<br>`cpf(FK)`<br>`id_funcionario(FK)`<br>`quantidade_pessoas`<br>`data_hora_inicio`<br>`status` |
| **ReservaMesa** | `id_reserva(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Atendimento** | `id_atendimento(PK)`<br>`id_funcionario(FK)`<br>`id_reserva(FK)`<br>`hora_chegada`<br>`hora_saida`<br>`qtd_pessoas` |
| **AtendimentoMesa** | `id_atendimento(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Entregador** | `id_entregador(PK)`<br>`id_funcionario(FK)`<br>`tipo_vinculo`<br>`status`<br>`plataforma`<br>`identificador_externo` |
| **Reembolso** | `id_reembolso(PK)`<br>`id_ocorrencia(FK)`<br>`id_pagamento(FK)`<br>`valor_reembolso`<br>`data_hora`<br>`status` |

**Legenda**

- **1FN:** Atributos atômicos, sem grupos repetidos, PK definida

## Normalização 2

| Entidade | Atributos |
| --- | --- |
| **Pessoa** | `cpf(PK)`<br>`nome` |
| **Funcionario** | `id_funcionario(PK)`<br>`cpf(FK)`<br>`id_cargo(FK)`<br>`data_admissao` |
| **Cargo** | `id_cargo(PK)`<br>`nome_cargo`<br>`salario_base` |
| **Pedido** | `id_pedido(PK)`<br>`cpf(FK)`<br>`id_mesa(FK)`<br>`id_funcionario(FK)`<br>`id_atendimento(FK)`<br>`data_hora`<br>`status_pedido`<br>`modalidade`<br>`canal_origem`<br>`data_hora_inicio_producao`<br>`data_hora_fim_producao` |
| **Ocorrencia** | `id_ocorrencia(PK)`<br>`id_pedido(FK)`<br>`id_funcionario_responsavel(FK)`<br>`classificacao`<br>`descricao`<br>`consumo_produto`<br>`data_hora`<br>`status` |
| **Produto** | `id_produto(PK)`<br>`id_categoria(FK)`<br>`nome`<br>`preco_base`<br>`descricao`<br>`montagem_especial`<br>`tempo_preparo_min`<br>`disponivel` |
| **Despesa** | `id_despesa(PK)`<br>`id_funcionario(FK)`<br>`id_forma_pagamento(FK)`<br>`id_compra(FK)`<br>`descricao`<br>`valor`<br>`data_vencimento`<br>`data_pagamento`<br>`status` |
| **Categoria** | `id_categoria(PK)`<br>`tipo` |
| **Promocao** | `id_promocao(PK)`<br>`nome`<br>`tipo`<br>`status`<br>`data_inicio`<br>`data_fim` |
| **PromocaoProduto** | `id_promocao(PK/FK)`<br>`id_produto(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemPedido** | `id_pedido(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **ItemComboPedido** | `id_pedido(PK/FK)`<br>`id_combo(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **Combo** | `id_combo(PK)`<br>`nome`<br>`preco_combo`<br>`descricao` |
| **PromocaoCombo** | `id_promocao(PK/FK)`<br>`id_combo(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemCombo** | `id_combo(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade` |
| **FichaTecnica** | `id_produto(PK/FK)`<br>`id_insumo(PK/FK)`<br>`quantidade_necessaria` |
| **Insumo** | `id_insumo(PK)`<br>`nome`<br>`unidade_medida`<br>`quantidade_minima` |
| **Compra** | `id_compra(PK)`<br>`id_fornecedor(FK)`<br>`id_funcionario(FK)`<br>`data_compra`<br>`status_compra` |
| **ItemCompra** | `id_item_compra(PK)`<br>`id_compra(FK)`<br>`id_lote(FK)`<br>`quantidade_solicitada`<br>`preco_unitario` |
| **Lote** | `id_lote(PK)`<br>`id_insumo(FK)`<br>`numero_lote`<br>`quantidade_inicial`<br>`data_recebimento`<br>`data_validade`<br>`status_lote` |
| **Fornecedor** | `id_fornecedor(PK)`<br>`cnpj`<br>`nome` |
| **MovimentacaoEstoque** | `id_movimentacao(PK)`<br>`id_lote(FK)`<br>`id_funcionario(FK)`<br>`id_pedido(FK)`<br>`tipo_movimentacao`<br>`quantidade`<br>`data_hora`<br>`motivo` |
| **Avaliacao** | `id_avaliacao(PK)`<br>`id_pedido(FK)`<br>`nota`<br>`comentario`<br>`data` |
| **Mesa** | `id_mesa(PK)`<br>`numero`<br>`capacidade`<br>`status` |
| **Entrega** | `id_entrega(PK)`<br>`id_pedido(FK)`<br>`id_entregador(FK)`<br>`id_endereco(FK)`<br>`status`<br>`taxa_entrega`<br>`data_saida` |
| **EventoEntrega** | `id_evento_entrega(PK)`<br>`id_entrega(FK)`<br>`origem_atualizacao`<br>`data_hora`<br>`status_pagamento` |
| **Pagamento** | `id_pagamento(PK)`<br>`id_pedido(FK)`<br>`id_caixa(FK)`<br>`id_forma_pagamento(FK)`<br>`data_hora`<br>`status`<br>`valor_total`<br>`referencia_externa` |
| **Telefone** | `id_telefone(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`ddd`<br>`numero` |
| **Email** | `id_email(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`email`<br>`tipo` |
| **Endereco** | `id_endereco(PK)`<br>`cep`<br>`logradouro`<br>`numero`<br>`complemento` |
| **PessoaEndereco** | `id_endereco(PK/FK)`<br>`cpf(PK/FK)` |
| **Caixa** | `id_caixa(PK)`<br>`id_funcionario_abertura(FK)`<br>`id_funcionario_fechamento(FK)`<br>`tipo_caixa`<br>`data_abertura`<br>`data_fechamento`<br>`valor_abertura`<br>`valor_fechamento`<br>`status` |
| **FormaPagamento** | `id_forma_pagamento(PK)`<br>`tipo` |
| **Reserva** | `id_reserva(PK)`<br>`cpf(FK)`<br>`id_funcionario(FK)`<br>`quantidade_pessoas`<br>`data_hora_inicio`<br>`status` |
| **ReservaMesa** | `id_reserva(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Atendimento** | `id_atendimento(PK)`<br>`id_funcionario(FK)`<br>`id_reserva(FK)`<br>`hora_chegada`<br>`hora_saida`<br>`qtd_pessoas` |
| **AtendimentoMesa** | `id_atendimento(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Entregador** | `id_entregador(PK)`<br>`id_funcionario(FK)`<br>`tipo_vinculo`<br>`status`<br>`plataforma`<br>`identificador_externo` |
| **Reembolso** | `id_reembolso(PK)`<br>`id_ocorrencia(FK)`<br>`id_pagamento(FK)`<br>`valor_reembolso`<br>`data_hora`<br>`status` |

**Legenda e notas**

- **2FN:** 1FN + nenhum atributo depende de só parte da PK composta

## Normalização 3

| Entidade | Atributos |
| --- | --- |
| **Pessoa** | `cpf(PK)`<br>`nome` |
| **Funcionario** | `id_funcionario(PK)`<br>`cpf(FK)`<br>`id_cargo(FK)`<br>`data_admissao` |
| **Cargo** | `id_cargo(PK)`<br>`nome_cargo`<br>`salario_base` |
| **Pedido** | `id_pedido(PK)`<br>`cpf(FK)`<br>`id_mesa(FK)`<br>`id_funcionario(FK)`<br>`id_atendimento(FK)`<br>`data_hora`<br>`status_pedido`<br>`modalidade`<br>`canal_origem`<br>`data_hora_inicio_producao`<br>`data_hora_fim_producao` |
| **Ocorrencia** | `id_ocorrencia(PK)`<br>`id_pedido(FK)`<br>`id_funcionario_responsavel(FK)`<br>`classificacao`<br>`descricao`<br>`consumo_produto`<br>`data_hora`<br>`status` |
| **Produto** | `id_produto(PK)`<br>`id_categoria(FK)`<br>`nome`<br>`preco_base`<br>`descricao`<br>`montagem_especial`<br>`tempo_preparo_min`<br>`disponivel` |
| **Despesa** | `id_despesa(PK)`<br>`id_funcionario(FK)`<br>`id_forma_pagamento(FK)`<br>`id_compra(FK)`<br>`descricao`<br>`valor`<br>`data_vencimento`<br>`status` |
| **Categoria** | `id_categoria(PK)`<br>`tipo` |
| **Promocao** | `id_promocao(PK)`<br>`nome`<br>`tipo`<br>`status`<br>`data_inicio`<br>`data_fim` |
| **PromocaoProduto** | `id_promocao(PK/FK)`<br>`id_produto(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemPedido** | `id_pedido(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **ItemComboPedido** | `id_pedido(PK/FK)`<br>`id_combo(PK/FK)`<br>`quantidade`<br>`preco_unitario`<br>`observacao` |
| **Combo** | `id_combo(PK)`<br>`nome`<br>`preco_combo`<br>`descricao` |
| **PromocaoCombo** | `id_promocao(PK/FK)`<br>`id_combo(PK/FK)`<br>`percentual_desconto`<br>`quantidade_limite` |
| **ItemCombo** | `id_combo(PK/FK)`<br>`id_produto(PK/FK)`<br>`quantidade` |
| **FichaTecnica** | `id_produto(PK/FK)`<br>`id_insumo(PK/FK)`<br>`quantidade_necessaria` |
| **Insumo** | `id_insumo(PK)`<br>`nome`<br>`unidade_medida`<br>`quantidade_minima` |
| **Compra** | `id_compra(PK)`<br>`id_fornecedor(FK)`<br>`id_funcionario(FK)`<br>`data_compra`<br>`status_compra` |
| **ItemCompra** | `id_item_compra(PK)`<br>`id_compra(FK)`<br>`id_lote(FK)`<br>`quantidade_solicitada`<br>`preco_unitario` |
| **Lote** | `id_lote(PK)`<br>`id_insumo(FK)`<br>`numero_lote`<br>`quantidade_inicial`<br>`data_recebimento`<br>`data_validade`<br>`status_lote` |
| **Fornecedor** | `id_fornecedor(PK)`<br>`cnpj`<br>`nome` |
| **MovimentacaoEstoque** | `id_movimentacao(PK)`<br>`id_lote(FK)`<br>`id_funcionario(FK)`<br>`id_pedido(FK)`<br>`tipo_movimentacao`<br>`quantidade`<br>`data_hora`<br>`motivo` |
| **Avaliacao** | `id_avaliacao(PK)`<br>`id_pedido(FK)`<br>`nota`<br>`comentario`<br>`data` |
| **Mesa** | `id_mesa(PK)`<br>`numero`<br>`capacidade`<br>`status` |
| **Entrega** | `id_entrega(PK)`<br>`id_pedido(FK)`<br>`id_entregador(FK)`<br>`id_endereco(FK)`<br>`status`<br>`taxa_entrega`<br>`data_saida` |
| **EventoEntrega** | `id_evento_entrega(PK)`<br>`id_entrega(FK)`<br>`origem_atualizacao`<br>`data_hora`<br>`status_pagamento` |
| **Pagamento** | `id_pagamento(PK)`<br>`id_pedido(FK)`<br>`id_caixa(FK)`<br>`id_forma_pagamento(FK)`<br>`data_hora`<br>`status`<br>`valor_total`<br>`referencia_externa` |
| **Telefone** | `id_telefone(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`ddd`<br>`numero` |
| **Email** | `id_email(PK)`<br>`cpf(FK)`<br>`id_fornecedor(FK)`<br>`email`<br>`tipo` |
| **Endereco** | `id_endereco(PK)`<br>`cep`<br>`logradouro`<br>`numero`<br>`complemento` |
| **PessoaEndereco** | `id_endereco(PK/FK)`<br>`cpf(PK/FK)` |
| **Caixa** | `id_caixa(PK)`<br>`id_funcionario_abertura(FK)`<br>`id_funcionario_fechamento(FK)`<br>`tipo_caixa`<br>`data_abertura`<br>`data_fechamento`<br>`valor_abertura`<br>`valor_fechamento`<br>`status` |
| **FormaPagamento** | `id_forma_pagamento(PK)`<br>`tipo` |
| **Reserva** | `id_reserva(PK)`<br>`cpf(FK)`<br>`id_funcionario(FK)`<br>`quantidade_pessoas`<br>`data_hora_inicio`<br>`status` |
| **ReservaMesa** | `id_reserva(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Atendimento** | `id_atendimento(PK)`<br>`id_funcionario(FK)`<br>`id_reserva(FK)`<br>`hora_chegada`<br>`hora_saida`<br>`qtd_pessoas` |
| **AtendimentoMesa** | `id_atendimento(PK/FK)`<br>`id_mesa(PK/FK)` |
| **Entregador** | `id_entregador(PK)`<br>`id_funcionario(FK)`<br>`tipo_vinculo`<br>`status`<br>`plataforma`<br>`identificador_externo` |
| **Reembolso** | `id_reembolso(PK)`<br>`id_ocorrencia(FK)`<br>`id_pagamento(FK)`<br>`valor_reembolso`<br>`data_hora`<br>`status` |

**Legenda e notas**

- **3FN:** 2FN + nenhum atributo comum depende de outro atributo comum
