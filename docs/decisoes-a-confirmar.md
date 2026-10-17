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
| D09 | Dois terminais de caixa (BALCAO e DELIVERY), um caixa por terminal por dia (como no relatório da Evidência 1) | — | `caixa` |
| D10 | Pagamento de pedido de plataforma é online e pré-pago; taxa da plataforma como percentual em `forma_pagamento` | — | `forma_pagamento` |
| D11 | Promoção de aniversário exige documento conferido; cupom não exige | — | `promocao` |
| D12 | Estoque é consumido ao **iniciar** o preparo; a checagem na venda usa o saldo atual (pode haver corrida entre pedidos simultâneos) | Reserva de estoque ao criar o pedido | `trg_item_pedido_bi` |
| D13 | Estoque mínimo = 25% da demanda semanal média (na massa de dados) | Definir por insumo com o gerente | `insumo.estoque_minimo` |
| D14 | Funcionário com histórico não pode ser apagado (FK RESTRICT); desligamento é registrado por data | — | `funcionario` |
| D15 | Reserva tem horário de início e fim explícitos (duração livre) | Duração padrão de 2 h | `reserva` |

## Dados fictícios (substituir antes da apresentação, se possível)

Cardápio além do Dois Dilúvios e da porção de coxinhas, preços, fichas técnicas (gramas por lanche), fornecedores, CNPJs, CPFs (prefixo 999000), funcionários, vendas, taxas e prazos são **inventados** para teste. O grupo deve substituir pelo cardápio, preços e lista de compras reais (Evidências 2 e 4 do README original) e regenerar a massa com `python3 sql/ferramentas/gerar_massa.py`.
