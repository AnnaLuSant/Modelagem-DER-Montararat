# Normalização: do modelo conceitual da 1ª entrega ao modelo lógico em 3FN

Critério: cada tabela está em 1FN (atributos atômicos, sem grupos repetidos), 2FN (sem dependência parcial da chave composta) e 3FN (sem dependência transitiva entre atributos não chave). Onde o modelo **não** normaliza de propósito, a seção 3 explica por quê.

## 1. Problemas encontrados no dicionário da 1ª entrega e como foram resolvidos

| # | Entidade/atributo original | Forma normal violada | Dependência funcional problemática | Solução no modelo lógico |
|---|---|---|---|---|
| N1 | `Pessoa.endereco` ("rua, número e CEP" em um campo) | 1FN (atributo composto e possivelmente multivalorado) | — | Tabela `endereco` (logradouro, número, complemento, bairro, cidade, UF, CEP), 1:N com `pessoa` |
| N2 | `Funcionario.cargo` e `Funcionario.setor` | 3FN | id_funcionario → cargo → setor | Tabelas `cargo` (com permissões `pode_comprar`, `pode_autorizar`) e `setor`; `funcionario` referencia `cargo` |
| N3 | `Funcionario.nome` e `cpf` repetindo `Pessoa` | Redundância / 3FN | id_funcionario → id_pessoa → nome | `funcionario.id_pessoa` (FK única) em vez de copiar nome e CPF |
| N4 | `ItemPedido.subtotal`, `ItemComboPedido.subtotal` (e a descrição de `preco_unitario` como "valor total do pedido") | 3FN (valor derivado) | subtotal = quantidade × preco_unitario | Atributo removido; total calculado em `v_total_pedido` |
| N5 | `Insumo.data_validade` | 2FN/modelagem (validade pertence ao lote recebido, não ao insumo) | lote → validade | Tabela `lote` (código, quantidade recebida, validade) ligada ao `recebimento` |
| N6 | `Fornecimento` (id_insumo, id_fornecimento, quantidade, data_compra, valor_compra) | 2FN | data_compra e fornecedor dependem só da compra, não do par (compra, insumo) | `compra` (cabeçalho) + `item_compra` (insumo, quantidade, valor) + `recebimento` + `lote` |
| N7 | `Estoque.quantidade_atual` (valor armazenado) | 3FN / dado derivado | saldo = Σ movimentações | `movimentacao_estoque` (livro de entradas/saídas) e `v_saldo_estoque`; `estoque_minimo` foi para `insumo` (é propriedade do insumo) |
| N8 | `Entrega.tipo` (retirada/delivery) | Redundância | tipo = pedido.modalidade | Removido; modalidade fica em `pedido`; `entrega` só existe para DELIVERY |
| N9 | `Entrega.endereco` (texto) | 1FN/redundância | endereço do cliente duplicado | `entrega.id_endereco` → `endereco` |
| N10 | `Pagamento.forma_pagamento` (texto livre) e relação 1:1 implícita com pedido | Domínio solto; impede pagamento dividido | — | `forma_pagamento` (com taxa) + `pagamento` N por pedido + `caixa` |
| N11 | `ItemComboPedido` com PK (id_pedido, id_produto) | Chave incorreta (a linha é combo, não produto) | — | PK (id_pedido, numero_item); coluna `id_combo` |
| N12 | `Pessoa` com PK `cpf` | Chave natural opcional/sensível | clientes de plataforma podem não informar CPF | PK substituta `id_pessoa`; `cpf` único e opcional |
| N13 | `Pedido` sem relação com mesa, caixa, promoção, autorizador | Modelo incompleto (RF07, RF14, RF15) | — | FKs `id_mesa`, `id_promocao`, `id_funcionario_autorizador`; pagamento → caixa |
| N14 | Combo: cadastro e uso no pedido misturados | Modelagem | — | `combo`/`item_combo` (cadastro) separados de `item_combo_pedido` (uso) |

## 2. Verificação das dependências funcionais por tabela (chaves compostas)

| Tabela | Chave | Atributos não chave | Dependem da chave inteira? |
|---|---|---|---|
| item_pedido | (id_pedido, numero_item) | id_produto, quantidade, preco_unitario, observacao | Sim: cada um descreve a linha do pedido |
| item_combo_pedido | (id_pedido, numero_item) | id_combo, quantidade, preco_unitario, observacao | Sim |
| item_combo | (id_combo, id_produto) | quantidade | Sim: quantidade do produto naquele combo |
| ficha_tecnica | (id_produto, id_insumo) | quantidade | Sim |
| item_compra | (id_compra, id_insumo) | quantidade, valor_total | Sim |
| fornecedor_insumo | (id_fornecedor, id_insumo) | prazo_entrega_dias | Sim |
| favorito | (id_pessoa, id_produto) | data_hora_salvo | Sim |

As demais tabelas têm chave simples (substituta); sem chave composta não há dependência parcial. Transitividades verificadas: cargo→setor (N2), pedido→pessoa (o nome do cliente não é copiado), pagamento→forma_pagamento (taxa fica em `forma_pagamento`), lote→recebimento→compra→fornecedor (o fornecedor não é repetido no lote), insumo→categoria_insumo.

## 3. Desnormalizações intencionais (decisões de projeto)

| Atributo | Por que é mantido |
|---|---|
| `item_pedido.preco_unitario`, `item_combo_pedido.preco_unitario` (RDN14) | É o preço **histórico** da venda. Se o cardápio for reajustado, vendas passadas não podem mudar. Não é cópia redundante: é um fato da venda. A massa de dados prova: o Dois Dilúvios vale R$ 36,90 antes de 01/10/2026 e R$ 38,90 depois. |
| `pedido.valor_desconto` | É decisão tomada no momento da venda (percentual pode mudar depois); fica registrado. A consistência com a promoção é verificada por teste (desconto = % × subtotal). |
| Marcos de tempo em `pedido` (início, pronto, encerramento) | São fatos distintos do pedido, usados nos indicadores de tempo (RF06/RF08); CHECKs garantem a ordem. |
| `mesa.status_mesa` | Estado operacional atual; o histórico de ocupação é derivado de `pedido` e `reserva`. A transição é controlada por trigger (RDN03). |

## 4. Dados derivados que NÃO são armazenados

Total do pedido, situação de pagamento, consumo por pedido, saldo de estoque, disponibilidade por estoque, custo médio e margem do produto: todos em views (`sql/ddl/03_views.sql`). Armazená-los criaria dependências transitivas e risco de divergência (RNF08).
