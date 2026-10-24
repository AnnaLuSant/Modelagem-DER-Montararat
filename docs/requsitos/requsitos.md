# Requisitos e regras de negócio (versão corrigida)

Sequência adotada (recomendada na devolutiva): **Problema → Processo → Requisito → Regra de Negócio → Entidade → Relacionamento → Cardinalidade → DER → Dicionário de Dados**.

Os identificadores do grupo foram mantidos. `RNF02` e `RNF05` não existem mais como RNF: foram reclassificados como `RF18` e `RF19`. Regras `RDN09` e `RDN10` (que estavam em branco) foram preenchidas.

## Requisitos funcionais (RF)


| ID | Título | Descrição verificável | Origem / o que mudou |
|---|---|---|---|
| **RF01** | Gestão de pedidos | O sistema permite à equipe registrar, acompanhar e atender pedidos dos canais SALAO, BALCAO, IFOOD e 99FOOD, mantendo o status do pedido (ABERTO, EM_PRODUCAO, PRONTO, ENTREGUE, CONCLUIDO, CANCELADO) e o funcionário que atendeu. | Mantido; descrição tornada verificável (canais e status explícitos). |
| **RF02** | Formas de pagamento | O sistema aceita PIX, cartão de débito, cartão de crédito, dinheiro e pagamento online das plataformas, permite dividir um pedido em mais de um pagamento e registra o status de cada pagamento (PENDENTE, CONFIRMADO, ESTORNADO, RECUSADO). | Reescrito: 'pix/cartão/dinheiro' passou a listar as formas reais da casa e o pagamento dividido. |
| **RF04** | Cadastro e controle de estoque de insumos | A equipe cadastra insumos (unidade de medida, estoque mínimo) e o sistema controla: ENTRADA (recebimento em lote com validade), CONSUMO (baixa automática pela ficha técnica quando o preparo inicia), AJUSTE_INVENTARIO (contagem física) e a reposição (insumo abaixo do mínimo). O saldo é a soma das movimentações. | Reescrito por completo: a devolutiva apontou que o requisito não especificava entrada, saída, consumo, inventário e reposição. |
| **RF05** | Relatórios semanais | O sistema fornece, para cada semana ISO, a quantidade de pedidos pagos, o faturamento e o ticket médio, e o volume de vendas por horário (produtividade). | Mantido; 'produtividade' e 'volume' foram ligados a indicadores concretos.|
| **RF06** | Dashboard gerencial | Os líderes/gerentes devem possuir um dashboard com a análise de desempenho da hamburgueria (faturamento, pratos mais vendidos, tempo médio de preparo); |
| **RF07** | Disponibilidade de mesas ao longo do tempo | O funcionário vê quais mesas estão disponíveis em um instante: uma mesa está OCUPADA se tem pedido local não encerrado, EM_LIMPEZA enquanto a limpeza não termina, e DISPONIVEL caso contrário. O histórico de ocupação vem de pedido.id_mesa (início e encerramento) e de reserva (início e fim). | Reescrito: a devolutiva apontou que o modelo não mostrava a ocupação ao longo do tempo.|
| **RF08** |Status de pedido| O sistema deve informar claramente o estado atual do pedido (Aguardando pagamento, pedido recebido, aguardadando confirmação do restaurante, pedido confirmado, restaurante preparando seu pedido, pedido pronto, procurando entregador, entregador atribuído, entregador indo ao restaurante, entregador chegou ao restaurante, entregador retirou o pedido, pedido saiu para entrega, pedido entregue, pedido cancelado). | x |
| **RF09** | Tempo estimado de preparo | O sistema exibe ao cliente a estimativa de preparo calculada a partir de duas informações: (1) o tempo base do pedido, que é o maior tempo_preparo_min entre os produtos do pedido (combos incluídos) e (2) o número de pedidos à frente na fila de produção, respeitando a prioridade (RDN09). A fórmula que combina as duas informações (ex.: capacidade de produção simultânea) é decisão do negócio. | Reescrito: a devolutiva pedia explicitar as informações usadas.|
| **RF10** |Perda e desperdício| Os funcionários devem conseguir resgistrar perdas e desperdícios de insumos (como vencimento ou erro de preparo), informando o insumo, quantidade, motivo, data e responsável pela atualização. | Requisito retirado do RF04 por não ocorrer frequentemente diante das ocorrências presentes na mesma, sendo assim, criado a parte por representar uma ocorrência atípica.|
| **RF11** | Especificações do produto | O sistema deve aprensentar descrição, peso (quando aplicável) e ingredientes de cada produto; os ingredientes vêm da ficha técnica. | Mantido. |
| **RF12** | Avaliações e reclamações | O cliente registra uma avaliação (nota de 1 a 5, comentário opcional) ou reclamação de um pedido; cada pedido tem no máximo um registro; a reclamação tem ciclo de tratamento (ABERTA, EM_ANALISE, RESOLVIDA) com funcionário responsável. | Reescrito: ciclo de tratamento da reclamação; nota passou de 0-5 para 1-5 (zero estrelas não existe).|
| **RF13** | Método de entrega | O cliente escolhe a modalidade do pedido: LOCAL (consumo no salão), RETIRADA (no balcão) ou DELIVERY. Pedido DELIVERY gera uma entrega com endereço, taxa, entregador e horários de saída e chegada. | Mantido |
| **RF14** | Compras, recebimento e conferência de insumos | O gerente ou proprietário registra a compra ao fornecedor (itens e valor); o recebimento é conferido por lote (quantidade e validade) contra o que foi comprado; divergências são detectáveis. | NOVO: a devolutiva apontou que o escopo ignorava compras, recebimento, conferência e reposição. | 
| **RF15** | Contas a pagar | Cada compra gera uma obrigação financeira com valor, vencimento e situação (ABERTA, PAGA, CANCELADA); despesas fixas (aluguel, energia) também são registradas; vencidas e não pagas são listadas. | NOVO: a devolutiva exigiu demonstrar obrigações financeiras e pagamentos. |
| **RF16** | Caixa | O terminal (na fita: "Mont Ararat Delivery", que registra vendas de mesa, balcão e delivery) abre e fecha o turno com valor de abertura, valor de fechamento informado e responsáveis; todo pagamento é lançado em um caixa; os recebimentos são agrupados em dinheiro, cartão e outras formas; a diferença de caixa = fechamento − (abertura + soma de recebimentos) é auditável, e o fechamento mostra serviço de mesa, tickets e cancelamentos de mesa. | NOVO: baseado na fita de fechamento de turno real (Evidência 1 do grupo), lida campo a campo. |
| **RF17** | Promoções e descontos | O sistema aplica promoção de aniversário (exige documento conferido) e cupons; todo desconto é autorizado por funcionário com permissão e o valor fica registrado no pedido. | NOVO: formaliza a política organizacional de promoções do README. | 
| **RF16** | Trocas, cancelamentos e reembolsos | Troca, cancelamento e reembolso são registrados como ocorrência do pedido, com causa, indicação de consumo pelo cliente, autorizador e, no reembolso, o valor devolvido. | NOVO: operacionaliza RDN05 e RDN10. | 
| **RF17** | Fila de produção com prioridade | O sistema ordena a produção pelo par (prioridade, horário do pedido): prioridade 1 para modalidade LOCAL, prioridade 2 para RETIRADA e DELIVERY (RDN09). | NOVO: demonstra COMO a prioridade é aplicada à fila, como pedido na devolutiva. | 
| **RF18** | Identificação automatizada de produtos mais vendidos| O sistema utiliza uma análise automatizada, com apoio de inteligência artificial, para identificar os produtos mais vendidos a partir do histórico de pedidos concluídos e atualizar periodicamente uma lista de produtos em destaque. | RECLASSIFICADO de RNF02: descrevia uma funcionalidade, não uma qualidade do sistema; ALTERADO: substitui o cadastro manual de favoritos pelos clientes por uma classificação automatizada baseada nos dados de vendas.|


## Requisitos não funcionais (RNF)

| ID | Título | Descrição verificável | Origem / o que mudou | 
|---|---|---|---|
| **RNF01** | Backup diário | O backup completo do banco é realizado uma vez por dia  e a restauração é testada mensalmente. | Reescrito: 'dados do cliente' ampliado para o banco todo; acrescentado teste de restauração. | 
| **RNF03** | Tempo de resposta do lançamento de pedidos | O lançamento de um pedido e o envio à cozinha respondem em até 2 segundos em pico (sexta e sábado, 19h-22h). | Mantido. |
| **RNF04** | Emissão do comprovante |O sistema deverá gerar e disponibilizar o comprovante do pedido em até 5 segundos após a confirmação da quitação integral, considerando a soma dos pagamentos confirmados vinculados ao pedido.| Mantido. | 
| **RNF06** | Integridade dos dados garantida pelo SGBD | Domínios, obrigatoriedade, unicidade, referências e as regras RDN01-RDN15 são garantidas pelo próprio banco (PK, FK, UNIQUE e CHECK), não apenas pela aplicação. | NOVO: critério de qualidade do modelo lógico. |
| **RNF09** | Precisão monetária | Valores monetários usam DECIMAL (nunca ponto flutuante) e totais não são armazenados: são derivados por view, evitando divergência. | | 

## Regras de negócio (RDN)

| ID | Título | Descrição verificável | Origem / o que mudou |
|---|---|---|---|
| **RDN01** | Pagamento antes da produção (retirada e delivery) | Pedido RETIRADA ou DELIVERY só entra em produção com pagamento confirmado integral (pedidos iFood/99food são pré-pagos online). Pedido LOCAL é pago depois do consumo. | Reescrito: 'salvo consumo no estabelecimento' passou a ser a modalidade LOCAL. |
| **RDN02** | Reservas presenciais sem sobreposição | A reserva é feita presencialmente por um funcionário (registrado na reserva), conforme disponibilidade: uma mesa não pode ter duas reservas não canceladas com períodos sobrepostos. | Reescrito: 'de acordo com a disponibilidade' virou a regra de não sobreposição. |
| **RDN03** | Limpeza da mesa após o uso | A mesa só entra em limpeza depois de ocupada e só volta a ficar livre depois da limpeza. JUSTIFICATIVA de estar no sistema: o estado EM_LIMPEZA altera a disponibilidade mostrada ao cliente (RF07), portanto precisa ser registrado; o ato de limpar é procedimento interno e não é controlado pelo sistema. |
| **RDN04** | Venda condicionada à disponibilidade e ao estoque | Um produto só é vendido se estiver marcado como disponível e se o saldo de estoque permitir produzir a quantidade pedida (checagem prévia do estoque). | Reescrito: inclui a checagem de estoque exigida na política 'Venda do Produto'. | 
| **RDN05** | Troca ou cancelamento por insatisfação | Em caso de insatisfação ou erro do pedido a troca, o cancelamento e o reembolso exigem consumo parcial/nulo do produto e a autorização de funcionário com autorização de gerente. O pagamento extornado corresponde apenas ao cancelamento do pedido. | Reescrito: elimina a contradição entre RDN05 e a política organizacional apontada na devolutiva. |
| **RDN06** | Montagem especial não vai por delivery | Produto marcado como montagem_especial (na massa: Dilúvio, assumido; decisão D13) não pode ser incluído em pedido DELIVERY, nem diretamente nem dentro de um combo. | Mantido; tornado verificável por atributo do produto. |
| **RDN07** | Embalagem individual identificada | Cada produto é embalado individualmente e identificado. No sistema, a embalagem é um insumo da ficha técnica de cada produto (consumo e estoque controlados); a identificação física da embalagem é procedimento interno. |
| **RDN08** | Retirada do delivery na porta | O entregador retira o pedido delivery na porta do estabelecimento. É procedimento operacional, não gera dado próprio; o sistema registra apenas a saída (entrega.data_hora_saida). | Justificada como procedimento fora do esquema. | 
| **RDN09** | Prioridade do consumo no local | Pedidos LOCAL têm prioridade 1 e os demais prioridade 2; a fila de produção é ordenada por (prioridade, horário do pedido). A prioridade não interrompe um preparo já iniciado. | NOVO: transforma a política 'prioridade dos pedidos' em regra aplicável. | 
| **RDN10** | Descontos autorizados | Todo desconto tem autorizador com permissão. A promoção de aniversário só vale com documento conferido. | NOVO: formaliza a política de promoções e autorizações do README. |
| **RDN11** | Compras apenas por gerente ou proprietário | Somente funcionário de cargo com permissão de compra (gerente e proprietário) registra compra de insumos. | 
| **RDN12** | Estoque por movimentações, sem saldo negativo | O estoque é um livro de movimentações (entrada positiva, saída negativa); o consumo é lançado quando o preparo inicia, calculado por (itens x ficha técnica) e (combos x composição x ficha técnica); nenhuma saída pode deixar o saldo negativo. | NOVO: responde ao pedido de demonstrar o cálculo da baixa de estoque. | 
| **RDN13** | Conclusão do pedido exige pagamento integral | Um pedido só vai a CONCLUIDO com pagamentos CONFIRMADOS somando o valor total; pedido CANCELADO não é venda e seus pagamentos online são ESTORNADOS. | NOVO: distingue entregue, cancelado, pago e concluído. |








