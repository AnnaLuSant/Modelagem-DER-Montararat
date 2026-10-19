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



