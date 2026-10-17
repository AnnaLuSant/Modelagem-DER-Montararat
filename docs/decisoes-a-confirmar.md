# Decisões assumidas que o grupo deve confirmar com o negócio/professor

Estas são interpretações razoáveis feitas para eliminar ambiguidades. Nenhuma foi informada pelo estabelecimento. Antes da entrega, confirmem cada uma (ou troquem a regra no DDL e regenerem os documentos).

| ID | Decisão assumida | Alternativa | Onde mudar |
|---|---|---|---|
| D01 | Troca após o consumo é permitida **somente** se a causa for erro da casa | Proibir qualquer troca após consumo | `ck_ocorrencia_politica` (DDL), RDN05 |
| D02 | RF08 usa tempo base + pedidos à frente; a fórmula final (ex.: quantas estações produzem ao mesmo tempo) não está definida | Definir fórmula com o chapeiro | `v_estimativa_preparo`, RF08 |
| D03 | Prioridade LOCAL não interrompe preparo já iniciado | Preempção | RDN09 |
| D04 | Pedido LOCAL é pago depois do consumo; RETIRADA/DELIVERY antes da produção | — | RDN01 |
| D05 | Cancelamento durante o preparo mantém o consumo de insumos já baixado (não há estorno de estoque) | Lançar PERDA/estorno | movimentação |
| D06 | `houve_consumo` significa que o **cliente** já consumiu o produto (não confundir com a baixa de insumos) | — | `ocorrencia` |
| D07 | Nota de avaliação de 1 a 5 (a 1ª entrega dizia 0 a 5) | Manter 0 a 5 | `ck_avaliacao_nota` |
| D08 | CPF opcional (clientes de plataformas podem não informar) | Obrigatório | `pessoa.cpf` |
| D09 | **Revisada com a fita real:** um turno de caixa por dia no terminal "Mont Ararat Delivery", que registra vendas de mesa, balcão e delivery; fundo de R$ 150 (da fita). Não sabemos se há outros terminais | Vários terminais | `caixa.terminal` |
| D10 | Pagamento de pedido de plataforma é online e pré-pago; taxa da plataforma como percentual em `forma_pagamento` | — | `forma_pagamento` |
| D11 | Promoção de aniversário exige documento conferido; cupom não exige | — | `promocao` |
| D12 | Estoque é consumido ao **iniciar** o preparo; a checagem na venda usa o saldo atual (pode haver corrida entre pedidos simultâneos) | Reserva de estoque ao criar o pedido | `trg_item_pedido_bi` |
| D13 | Estoque mínimo = 25% da demanda semanal média (na massa de dados). **Montagem especial (RDN06) = Dilúvio** (assumido: o original dizia só "montagem especial") | Definir mínimos com o gerente; confirmar qual lanche é montagem especial | `insumo.estoque_minimo`, `produto.montagem_especial` |
| D14 | Funcionário com histórico não pode ser apagado (FK RESTRICT); desligamento é registrado por data | — | `funcionario` |
| D15 | Reserva tem horário de início e fim explícitos (duração livre) | Duração padrão de 2 h | `reserva` |

| D16 | Combo = lanche + meia porção de batata simples, por lanche + R$ 8 (a diferença de R$ 8 vem do cardápio; **a composição é suposta**) | Composição real (ex.: batata individual + bebida) | `item_combo` |
| D17 | Carnes, hortifrúti, batata, coxinha, pulled pork e a "maionese da casa" **não aparecem na lista de compras fotografada**; foram incluídos como insumos com fornecedores genéricos (fornecedor 17 fictício; hortifrúti e congelados no Mercado/Cornershop). Maionese da casa é tratada como insumo comprado (produção intermediária não modelada) | Cadastrar os fornecedores reais e modelar a produção própria | `insumo`, `fornecedor` |
| D18 | Reajuste do Dilúvio em 01/10 (R$ 39 → R$ 41) é **fictício**, só para demonstrar que o item guarda o preço da venda (RDN14) | Remover o reajuste | `item_pedido.preco_unitario` |
| D19 | Pesos dos produtos (`peso_g`) e gramaturas das fichas técnicas são **estimativas**; só os pesos dos burgers (120/150/180/200 g) vêm do cardápio | Pesar com a cozinha | `produto.peso_g`, `ficha_tecnica` |
| D20 | Serviço de mesa = 10% do consumo, dispensado em ~15% das mesas. A fita mostra R$ 196,50 sobre R$ 2.974 de vendas de mesa (6,6%), então a regra real não é 10% fixo | Perguntar a regra (percentual, por pessoa, facultativo) | `pedido.valor_servico` |
| D21 | Cancelamento de item (fita: "Cancelamentos mesa") é um **item cancelado antes do preparo**: fica registrado com `cancelado = 1`, não entra no total nem no consumo | Cancelar também após o preparo (perda) | `item_pedido.cancelado` |
| D22 | Refrigerante e suco são um produto cada (a cozinha baixa Coca-Cola e um suco genérico); Heineken e os preços de compra dos insumos não constam na lista e são estimados | Um produto por sabor | `produto`, `insumo` |
| D23 | Taxa de entrega fixa de R$ 6 e volume de vendas (20 a 50 pedidos por dia, ticket ~R$ 110) são simulados, calibrados pela fita (30 tickets, ticket R$ 101,63) | Dados reais de vendas | gerador |

## Dados reais x simulados

**Reais (das fotos do estabelecimento):** cardápio e preços (lanches, entradas, extras, bebidas), nomes dos fornecedores e unidades de compra da lista de compras, formato e terminal da fita de fechamento, fundo de caixa de R$ 150, serviço de mesa, cancelamentos de mesa, grupos de recebimento (dinheiro, cartão, outras) e a fórmula da diferença de caixa.

**Inventados (para teste):** pessoas e clientes (CPFs com prefixo 999000), CNPJs e telefones, vendas e horários, gramaturas das fichas técnicas, preços de compra, salários, composição dos combos e o reajuste de preço. Para trocar qualquer um pelo dado real, edite `sql/ferramentas/gerar_massa.py` (bloco "DADOS DE REFERÊNCIA") e rode `python3 gerar_massa.py`.
