# DICIONÁRIO DE DADOS:

## Pessoa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `cpf(PK)` | Número de CPF que identifique a Pessoa. | Chave primária (PK) e dado único por pessoa. (RNF06) | `CHAR(11)` | `PRIMARY KEY` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa e chave única. |
| `nome` | Nome completo da Pessoa. | Preenchimento obrigatório. Não precisa ser único. (RF01, RDN10) | `VARCHAR(120)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória para identificação da pessoa. |

## Funcionario

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_funcionario(PK)` | Identificador do Funcionário. | Deve ser único para cada funcionário. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cpf(FK)` | Número de CPF que identifique o Funcionário | Deve ser único para cada funcionário. (RNF06) | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |
| `id_cargo(FK)` | Identificador de cargo e/ou função do funcionário | Cada funcionário deve possuir apenas um cargo. (RDN11) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do cargo |
| `data_admissao` | Data a qual o funcionário foi inserido à empresa | Preenchimento obrigatório. Informa a data que o funcionário foi contratado pela empresa (exibida no formato: DD/MM/AAAA). (RF01, RF16) | `DATE` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data em que o funcionário foi contratado. |
| `status` | Situação atual do funcionário (ex.: 'ATIVO' ou 'INATIVO') | O campo deve exibir o vínculo do funcionário com a empresa, aceitando os valores: 'ATIVO' e 'INATIVO'. (RNF06, RDN08) | `ENUM('ATIVO', 'INATIVO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## Entregador

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_entregador(PK)` | Identificador do entregador. | Deve ser único para cada registro de Entregador. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_funcionario(FK)` | Identificador do funcionário que atua como entregador, quando há vínculo com a empresa. | Deve referenciar um registro existente em Funcionario. (RF13, RDN08) | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que nem todo entregador é um funcionário registrado do estabelecimento. |
| `tipo_vinculo` | Tipo de vínculo do entregador com a empresa (ex.: funcionário próprio ou terceirizado). | O campo deve exibir o vínculo do entregador com a empresa, aceitando os valores: 'LOCAL' e 'EXTERNO'. (RNF06, RDN08) | `ENUM('LOCAL', 'EXTERNO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `status` | Situação atual do entregador (ex.: 'ATIVO' ou 'INATIVO') | Deve registrar apenas a situação do entregador próprio da empresa, 'ATIVO' para quando ainda há ligação, e 'INATIVO' em caso de demissão. (RF13) | `ENUM('ATIVO', 'INATIVO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `plataforma` | Plataforma de entrega pela qual o entregador atua, quando terceirizado. | Informação pertence apenas aos entregadores terceirizados. (RF01, RDN01) | `ENUM('IFOOD', '99FOOD')` | `NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e não sendo uma informação obrigatória, visto que nem todo entregador é terceirizado. |
| `identificador_externo` | Código que identifica o entregador na plataforma externa. | Preenchimento obrigatório para entregadores terceirizados (deve conter o ID/código gerado pela plataforma externa). Deve ser nulo para entregadores próprios. (RF01, RDN01) | `CHAR(4)` | `NULL` | Garante tamanho fixo de 4 dígitos e não é uma informação obrigatória, visto que nem todo entregador é terceirizado. |

## Entrega

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_entrega(PK)` | Identificador da entrega. | Deve ser único para cada registro de Entrega; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_pedido(FK)` | Identificador do pedido que será entregue. | Deve referenciar um registro existente em Pedido. Pedido DELIVERY gera uma entrega (RF13). | `INT` | `NOT NULL, UNIQUE` | Armazena números inteiros, é uma informação obrigatória e única, garantindo que o valor seja exclusivo na tabela, impedindo o registro de informações duplicadas. |
| `id_entregador(FK)` | Identificador do entregador responsável pela entrega. | Deve referenciar um registro existente em Entregador. Entregador responsável pela entrega (RF13). | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do entregador. |
| `id_endereco(FK)` | Identificador do endereço de destino da entrega. | Deve referenciar um registro existente em Endereco. Endereço de destino da entrega (RF13). | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do endereço. |
| `status` | Situação atual da entrega (ex.: em rota ou entregue). | Deve registrar a evolução do status informada ao cliente (ex.: 'AGUARDANDO_ENTREGADOR'). (RF08) | `ENUM('PENDENTE', 'AGUARDANDO_ENTREGADOR', 'EM_TRANSITO', 'ENTREGUE', 'NAO_ENTREGUE', 'CANCELADA')` | `NOT NULL, DEFAULT 'PENDENTE'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'PENDENTE' como o valor padrão inicial de todo novo pedido. |
| `taxa_entrega` | Valor cobrado pela entrega. | Taxa cobrada pela entrega. Valor monetário em DECIMAL, nunca ponto flutuante (RF13, RNF09). | `DECIMAL(12,2)` | `NOT NULL, DEFAULT 0` | Armazena valores numéricos com precisão de até 12 dígitos e 2 casas decimais, sendo uma informação obrigatória e assumindo 0 como valor padrão inicial. |
| `data_saida` | Data e hora em que a entrega saiu do estabelecimento. | Único horário de retirada registrado: a retirada do pedido na porta é procedimento operacional que não gera dado próprio (RDN08). | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |

## EventoEntrega

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_evento_entrega(PK)` | Identificador do evento de atualização da entrega. | Deve ser único para cada registro de EventoEntrega; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_entrega(FK)` | Identificador da entrega à qual o evento pertence. | Deve referenciar um registro existente em Entrega. (RF08, RF13) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da entrega. |
| `origem_atualizacao` | Origem da atualização de status (ex.: sistema, entregador ou plataforma externa). | Preenchimento obrigatório. Informa a origem do evento de atualização do status, aceitando os valores: 'sistema', 'entregador' e 'plataforma externa'. (RF08) | `ENUM('IFOOD', '99FOOD', 'LOCAL')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `data_hora` | Data e hora em que o evento ocorreu. | Preenchimento obrigatório. Informa a data e hora que a entrega foi realizada (exibida no formato: DD/MM/AAAA - 22:14). (RF08) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que o registro é criado. |
| `status` | Status da entrega registrado neste evento. | Deve registrar a evolução do status informada ao cliente (ex.: 'AGUARDANDO_ENTREGADOR'). (RF08) | `ENUM('PENDENTE', 'AGUARDANDO_ENTREGADOR', 'EM_TRANSITO', 'ENTREGUE', 'NAO_ENTREGUE', 'CANCELADA')` | `NOT NULL, DEFAULT 'PENDENTE'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'PENDENTE' como o valor padrão inicial de toda nova entrega. |

## Cargo

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_cargo(PK)` | Identificador de cargo e/ou função do funcionário | Cada funcionário deve obrigatoriamente estar atrelado a apenas um cargo. (RDN11) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `nome_cargo` | Nomenclatura dada ao cargo/função | Informação descritiva, exibe o cargo de atuação do funcionário (ex.: chapeiro). (RDN11) | `VARCHAR(80)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória para identificação do funcionário. |
| `salario_base` | Remuneração dada aos funcionários | Dado numérico que pode ser decimal (ex.: 3281.26). (RNF09) | `DECIMAL(8,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 8 dígitos e 2 casas decimais, sendo uma informação obrigatória. |

## Caixa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_caixa(PK)` | Identificador do caixa. | Deve ser único para cada registro de Caixa; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_funcionario_fechamento(FK)` | Identificador do funcionário que fechou o caixa. | Deve referenciar um registro existente em Funcionario. Responsável pelo fechamento do turno. (RF16) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do funcionário responsável pelo fechamento do caixa. |
| `id_funcionario_abertura(FK)` | Identificador do funcionário que abriu o caixa. | Deve referenciar um registro existente em Funcionario. Responsável pela abertura do turno. (RF16) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do funcionário responsável pela abertura do caixa. |
| `data_abertura` | Data e hora em que o caixa foi aberto. | Início do turno do caixa. (RF16) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que o caixa é aberto. |
| `data_fechamento` | Data e hora em que o caixa foi fechado. | Fim do turno do caixa. (RF16) | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |
| `tipo_caixa` | Tipo do caixa (ex.: 'LOCAL' ou 'DELIVERY') | Deve estar especificado no fechamento do caixa. | `ENUM('LOCAL', 'DELIVERY')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `valor_abertura` | Valor presente no caixa no momento da abertura. | Valor informado na abertura do turno. Valor monetário em DECIMAL, nunca ponto flutuante. (RF16, RNF09) | `DECIMAL(12,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 12 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `valor_fechamento` | Valor apurado no caixa no momento do fechamento. | Valor informado no fechamento do turno. A diferença de caixa = fechamento − (abertura + soma dos recebimentos) deve ser auditável. Valor monetário em DECIMAL, nunca ponto flutuante (RF16, RNF09). | `DECIMAL(12,2)` | `NULL` | Armazena valores numéricos com precisão de até 12 dígitos e 2 casas decimais, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |
| `status_caixa` | Situação de operação do caixa. | O campo deve exibir o status do funcionamento do caixa, aceitando os valores: 'ABERTO' e 'FECHADO'. (RNF06, RDN08) | `ENUM('ABERTO', 'FECHADO')` | `NOT NULL, DEFAULT 'ABERTO'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'ABERTO' como o valor padrão inicial de toda nova abertura do caixa. |

## FormaPagamento

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_forma_pagamento` | Identificador da forma de pagamento. | Deve ser único para cada registro de FormaPagamento; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `tipo` | Tipo da forma de pagamento (ex.: dinheiro, cartão ou PIX). | Tipos aceitos: 'PIX', 'CARTAO DE DEBITO', 'CARTAO DE CREDITO', 'DINHEIRO'. (RF02) | `ENUM('PIX', 'CARTAO DE CREDITO', 'CARTAO DE DEBITO', 'DINHEIRO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## Pagamento

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_pagamento` | Identificador do pagamento. | Deve ser único para cada registro de Pagamento; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_pedido(FK)` | Identificador do pedido ao qual o pagamento se refere. | Deve referenciar um registro existente em Pedido. Um pedido pode ser dividido em mais de um pagamento. (RF02) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do pedido. |
| `id_caixa(FK)` | Identificador do caixa em que o pagamento foi registrado. | Deve referenciar um registro existente em Caixa. Todo pagamento é lançado em um caixa. (RF16) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do caixa. |
| `id_forma_pagamento(FK)` | Identificador da forma de pagamento utilizada. | Deve referenciar um registro existente em FormaPagamento. Formas aceitas: PIX, cartão de débito, cartão de crédito, dinheiro e pagamento online das plataformas. (RF02) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da forma de pagamento. |
| `data_hora` | Data e hora em que o pagamento foi realizado. | Preenchimento obrigatório. Informa a data e hora que o pagamento foi realizado. (exibida no formato: DD/MM/AAAA - 22:14) (RF16) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que o pagamento é efetuado. |
| `status_pagamento` | Situação do pagamento (ex.: pendente, aprovado ou cancelado). | Valores permitidos: PENDENTE, CONFIRMADO, ESTORNADO, RECUSADO. Só pagamentos CONFIRMADOS contam para concluir o pedido. O comprovante é gerado em até 5 segundos após a quitação integral. (RF02, RNF04, RDN13) | `ENUM('PENDENTE', 'APROVADO', 'RECUSADO', 'CANCELADO', 'ESTORNADO')` | `NOT NULL, DEFAULT 'PENDENTE'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'PENDENTE' como o valor padrão inicial de todo novo pagamento. |
| `valor_total` | Valor total do pagamento. | Valor monetário em DECIMAL, nunca ponto flutuante. A soma dos pagamentos confirmados deve igualar o valor do pedido para concluí-lo. No fechamento, os recebimentos são agrupados em dinheiro, cartão e outras formas. (RF16, RNF09, RDN13) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória |
| `referencia_externa` | Código de referência do pagamento em sistema externo (ex.: operadora de cartão). | Usado em pagamentos feitos fora do sistema, como o pagamento online das plataformas. (RF02, RDN01) | `ENUM('IFOOD', '99FOOD')` | `NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação não obrigatória, visto que nem todos os pagamentos são feitos em plataformas externas. |

## Despesa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_despesa` | Identificador da despesa. | Deve ser único para cada registro de Despesa; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_funcionario` | Identificador do funcionário responsável pelo registro da despesa. | Deve referenciar um registro existente em Funcionario. (RF15) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do funcionário responsável. |
| `id_forma_pagamento` | Identificador da forma de pagamento utilizada na despesa. | Deve referenciar um registro existente em FormaPagamento. (RF02, RF15) | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que o banco pode armazenar despesas futuras. |
| `id_compra` | Identificador da compra associada à despesa, quando houver. | Deve referenciar um registro existente em Compra. Cada compra gera uma obrigação financeira (RF14, RF15). | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que as despesas podem ser contas fixas (luz, água, etc.). |
| `descricao` | Descrição da despesa. | Campo opcional preenchido pelo funcionário responsável pela despesa (apresenta um resumo da compra, contendo itens comprados, quantidade de lotes, etc.). (RF15) | `VARCHAR(150)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória para descrever a despesa. |
| `valor` | Valor da despesa. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(7,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 7 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `data_vencimento` | Data de vencimento da despesa. | Despesas vencidas e não pagas são listadas. (RF15) | `DATE` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data de vencimento da despesa |
| `data_pagamento` | Data em que a despesa foi paga. | Preenchida apenas quando a obrigação é paga. (RF15) | `DATE` | `NULL` | Armazena uma data no formato padrão, não é uma informação obrigatória, já que despesas futuras podem ser pagas posteriormente. |
| `status` | Situação da despesa (ex.: pendente, paga ou vencida). | Valores permitidos: 'PENDENTE', 'PAGA', 'VENCIDA', 'CANCELADA'. (RF15) | `ENUM('PENDENTE', 'PAGA', 'VENCIDA', 'CANCELADA')` | `NOT NULL, DEFAULT 'PENDENTE'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'PENDENTE' como o valor padrão inicial de todo novo pagamento. |

## Pedido

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_pedido(PK)` | Identificador do pedido. | Deve ser único para cada registro de Pedido; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cpf(FK)` | CPF da pessoa que realizou o pedido. | Deve referenciar um registro existente em Pessoa. (RF01) | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |
| `id_mesa(FK)` | Identificador da mesa onde o pedido foi realizado. | Deve referenciar um registro existente em Mesa. Usado em pedidos LOCAL (consumo no salão). A mesa fica OCUPADA enquanto houver pedido local não encerrado, e o histórico de ocupação vem deste campo. (RF07) | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que nem todos os pedidos são consumidos no restaurante. |
| `id_funcionario(FK)` | Identificador do funcionário que registrou o pedido. | Deve referenciar um registro existente em Funcionario. Registra o funcionário que atendeu o pedido. (RF01) | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que pedidos podem ser feitos nos apps de delivery. |
| `id_atendimento(FK)` | Identificador do atendimento ao qual o pedido pertence. | Deve referenciar um registro existente em Atendimento. (RDN09) | `INT` | `NULL` | Armazena números inteiros e não é uma informação obrigatória, visto que pedidos podem ser feitos nos apps de delivery. |
| `data_hora` | Data e hora em que o pedido foi realizado. | A fila de produção é ordenada por prioridade e por este horário. (RF17, RDN09) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que o pedido é efetuado. |
| `status_pedido` | Situação atual do pedido (ex.: aberto, em preparo, finalizado ou cancelado). | Valores permitidos: ABERTO, EM_PRODUCAO, PRONTO, ENTREGUE, CONCLUIDO, CANCELADO (RF01). Só vai a CONCLUIDO com pagamentos CONFIRMADOS somando o valor total; pedido CANCELADO não é venda e seus pagamentos online são ESTORNADOS (RDN13). | `ENUM('PENDENTE', 'EM PRODUCAO', 'CONCLUIDO', 'ENTREGUE', 'CANCELADO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `modalidade` | Modalidade do pedido (ex.: 'LOCAL'). | Valores permitidos: LOCAL, RETIRADA ou DELIVERY. LOCAL tem prioridade 1 na produção; RETIRADA e DELIVERY, prioridade 2. LOCAL é pago após o consumo; RETIRADA e DELIVERY só entram em produção com pagamento integral confirmado. Pedido DELIVERY não pode conter produto com montagem especial. (RF13, RDN01, RDN06, RDN09) | `ENUM('LOCAL', 'RETIRADA', 'ENTREGA')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `canal_origem` | Canal pelo qual o pedido foi feito (ex.: 'LOCAL'). | Valores permitidos: IFOOD ou 99FOOD (pedidos iFood/99Food são pré-pagos online). (RF01, RDN01) | `ENUM('IFOOD', '99FOOD')` | `NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, sendo uma informação não obrigatória, já que o pedido pode ser feito no local. |
| `data_hora_inicio_producao` | Data e hora em que o preparo do pedido foi iniciado. | O consumo de insumos é lançado quando o preparo inicia. Um preparo já iniciado não é interrompido por prioridade. Usado no tempo médio de preparo. (RF06, RDN09, RDN12) | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |
| `data_hora_fim_producao` | Data e hora em que o preparo do pedido foi concluído. | Usado, junto com o início da produção, no tempo médio de preparo do dashboard. (RF06) | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |

## Ocorrencia

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_ocorrencia(PK)` | Identificador da ocorrência. | Deve ser único para cada registro de Ocorrencia; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_pedido(FK)` | Identificador do pedido ao qual a ocorrência se refere. | Deve referenciar um registro existente em Pedido. | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do pedido. |
| `id_funcionario_responsavel(FK)` | Identificador do funcionário responsável pelo tratamento da ocorrência. | Deve referenciar um registro existente em Funcionario. Troca, cancelamento e reembolso exigem autorização de funcionário com autorização de gerente. Em reclamações, é o responsável pelo tratamento. (RF12, RDN05) | `INT` | `NULL` | Armazena números inteiros, e não é uma informação obrigatória, visto que a ocorrência pode ser feita pelos apps de delivery. |
| `classificacao` | Classificação da ocorrência (ex.: reclamação, erro de preparo ou atraso). | Troca, cancelamento e reembolso são registrados como ocorrência do pedido (RF16 – Trocas, cancelamentos e reembolsos). Também cobre reclamações. (RF12, RF16) | `ENUM('PRODUTO_INCORRETO', 'ITEM_FALTANTE', 'QUALIDADE_PRODUTO', 'ATRASO_PEDIDO', 'ERRO_COBRANCA', 'PROBLEMA_ATENDIMENTO', 'CANCELAMENTO', 'OUTROS')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `descricao` | Descrição detalhada do que ocorreu. | Preenchimento obrigatório. Informado pelo cliente que recebe o pedido (deve apresentar uma descrição com detalhes do(s) erro(s) encontrado(s) no pedido). | `VARCHAR(255)` | `NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação não obrigatória, visto que a descrição é opcional. |
| `consumo_produto` | Informa se o produto envolvido na ocorrência foi consumido pelo cliente. | Troca, cancelamento e reembolso exigem consumo parcial ou nulo do produto. (RDN05) | `ENUM('CONSUMO', 'SEM_CONSUMO', 'CONSUMO_PARCIAL')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `data_hora` | Data e hora em que a ocorrência foi registrada. | Preenchimento obrigatório. Informa a data e hora que a ocorrência foi registrada (exibida no formato: DD/MM/AAAA - 22:14). | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que a ocorrência é registrada. |
| `status` | Situação do tratamento da ocorrência (ex.: aberta, em análise ou resolvida). | Deve exibir os valores: ABERTA, EM_ANALISE ou RESOLVIDA. (RF12) | `ENUM('ABERTA', 'EM ANALISE', 'RESOLVIDA', 'ENCERRADA', 'CANCELADA')` | `NOT NULL, DEFAULT 'ABERTA'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'ABERTA' como o valor padrão inicial de toda nova ocorrência. |

## Endereco

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_endereco(PK)` | Identificador do endereço. | Preenchimento obrigatório. Deve ser único para cada registro de Endereco. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `numero` | Número do imóvel. | Preenchimento obrigatório. Deve ser preenchido pelo cliente. | `VARCHAR(15)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória para representar o número da residência. |
| `cep` | Código de Endereçamento Postal do endereço. | Preenchimento obrigatório. Deve ser preenchido pelo cliente. | `CHAR(8)` | `NOT NULL` | Garante tamanho fixo de 8 dígitos, sendo uma informação obrigatória. |
| `logradouro` | Nome da rua, avenida ou similar. | Preenchimento obrigatório. Deve ser preenchido pelo cliente. | `VARCHAR(180)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória para descrever o nome da rua. |
| `complemento` | Informação adicional do endereço (ex.: apartamento, bloco). | Preenchimento opcional. Informação complementar de referência para localização do imóvel (ex.: apartamento, bloco, casa). | `VARCHAR(90)` | `NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação não obrigatória, visto que o complemento é opcional. |

## PessoaEndereco

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_endereco(PK/FK)` | Identificador do endereço associado à pessoa. | Compõe a chave primária junto com cpf; deve referenciar um registro existente em Endereco. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do endereço. |
| `cpf(PK/FK)` | CPF da pessoa associada ao endereço. | Compõe a chave primária junto com id_endereco; deve referenciar um registro existente em Pessoa. (RNF06) | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |

## Telefone

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_telefone(PK)` | Identificador do telefone. | Deve ser único para cada registro de Telefone; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cpf(FK)` | CPF da pessoa dona do telefone, quando aplicável. | Deve referenciar um registro existente em Pessoa. Preenchido quando o telefone pertence a uma pessoa. | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |
| `id_fornecedor(FK)` | Identificador do fornecedor dono do telefone, quando aplicável. | Deve referenciar um registro existente em Fornecedor. Preenchido quando o telefone pertence a um fornecedor. | `INT` | `NULL` | Armazena números inteiros, e não é uma informação obrigatória, visto que nem todo telefone pertence a um fornecedor. |
| `ddd` | Código de área (DDD) do telefone. | Preenchimento obrigatório. Deve conter exatamente 2 dígitos numéricos correspondentes ao DDD de um estado brasileiro (ex.: '11', '21'). | `CHAR(2)` | `NOT NULL` | Garante tamanho fixo de 2 dígitos, sendo uma informação obrigatória para identificação do DDD. |
| `numero` | Número do telefone. | Preenchimento obrigatório. Deve conter exatamente 9 dígitos numéricos correspondentes a um telefone existente (ex.: '984253565'). | `VARCHAR(11)` | `NOT NULL` | Armazena o número de telefone em formato de texto flexível, preservando zeros à esquerda e permitindo a inclusão de caracteres de formatação (como DDD, parênteses e hífens). |

## Email

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_email(PK)` | Identificador do e-mail. | Deve ser único para cada registro de Email; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cpf(FK)` | CPF da pessoa dona do e-mail, quando aplicável. | Deve referenciar um registro existente em Pessoa. Preenchido quando o e-mail pertence a uma pessoa. | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |
| `id_fornecedor(FK)` | Identificador do fornecedor dono do e-mail, quando aplicável. | Deve referenciar um registro existente em Fornecedor. Preenchido quando o e-mail pertence a um fornecedor. | `INT` | `NULL` | Armazena números inteiros, e não é uma informação obrigatória, visto que nem todo e-mail pertence a um fornecedor. |
| `email` | Endereço de e-mail. | Preenchimento obrigatório. Deve conter um endereço de e-mail válido, contendo o caractere '@' e um domínio válido (ex.: usuario@dominio.com) | `VARCHAR(254)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |
| `tipo` | Tipo do e-mail (ex.: pessoal ou comercial). | Preenchimento obrigatório. Deve apresentar a categoria do e-mail informado, aceitando os valores: 'PESSOAL' e 'CORPORATIVO'. | `ENUM('PESSOAL', 'CORPORATIVO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## Fornecedor

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_fornecedor(PK)` | Identificador do fornecedor. | Deve ser único para cada registro de Fornecedor; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cnpj` | Número de CNPJ que identifica o fornecedor. | Preenchimento obrigatório. Deve conter exatamente 14 dígitos numéricos correspondente a um CNPJ ativo (ex.: 11111111111111). | `CHAR(14)` | `NOT NULL, UNIQUE` | Garante tamanho fixo de 14 dígitos exigido pelo documento de identificação da empresa do fornecedor, sendo uma informação obrigatória e única. |
| `nome` | Nome ou razão social do fornecedor. | Preenchimento obrigatório. Deve conter um nome correspondente ao CNPJ informado. | `VARCHAR(100)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |

## Mesa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_mesa(PK)` | Identificador da mesa. | Deve ser único para cada registro de Mesa. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `capacidade` | Quantidade máxima de pessoas que a mesa comporta. | Preenchimento obrigatório. Deve ser um valor numérico diferente de 0. | `SMALLINT UNSIGNED` | `NOT NULL` | Armazena números inteiros positivos de pequeno porte (otimizando espaço e restringindo a valores não negativos), sendo uma informação obrigatória para o registro. |
| `numero` | Número de identificação da mesa no salão. | Deve ser um valor numérico diferente de 0. | `VARCHAR(15)` | `NOT NULL, UNIQUE` | Armazena o identificador da mesa em formato de texto flexível (permitindo números, letras ou prefixos de localização), sendo uma informação obrigatória e única. |
| `status` | Situação da mesa (ex.: livre, ocupada ou reservada). | Valores permitidos: DISPONIVEL, OCUPADA, EM_LIMPEZA. Só entra em limpeza depois de ocupada e só volta a ficar disponível depois da limpeza. (RF07, RDN03) | `ENUM('OCUPADO', 'LIVRE', 'EM LIMPEZA')` | `CONSTRAINT chk_mesa_capacidade, CHECK (capacidade > 0)` | Restringe as opções de status apenas aos valores válidos de ocupação da mesa ('OCUPADO', 'LIVRE' ou 'EM LIMPEZA'), garantindo a padronização e evitando erros de digitação. |

## Reserva

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_reserva(PK)` | Identificador da reserva. | Deve ser único para cada registro de Reserva; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `cpf(FK)` | CPF da pessoa que fez a reserva. | Deve referenciar um registro existente em Pessoa. | `CHAR(11)` | `NOT NULL` | Garante tamanho fixo de 11 dígitos exigido pelo documento de identificação da pessoa, sendo uma informação obrigatória. |
| `id_funcionario(FK)` | Identificador do funcionário que registrou a reserva. | Deve referenciar um registro existente em Funcionario. A reserva é feita presencialmente por um funcionário, que fica registrado nela. (RDN02) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do funcionário. |
| `quantidade_pessoas` | Quantidade de pessoas prevista para a reserva. | Preenchimento obrigatório. Quantidade informada pelo cliente/funcionário no momento do agendamento. | `SMALLINT UNSIGNED` | `NOT NULL` | Armazena números inteiros positivos de pequeno porte (otimizando espaço e restringindo a valores não negativos), sendo uma informação obrigatória para o registro. |
| `data_hora_inicio` | Data e hora de início da reserva. | Deve informar a data e hora que a reserva foi realizada. (exibida no formato: DD/MM/AAAA - 22:14). (RF07, RDN02) | `DATETIME` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data em que a reserva foi feita. |
| `status` | Situação da reserva (ex.: confirmada, cancelada ou concluída). | Reservas canceladas não entram na verificação de sobreposição. (RF07, RDN02) | `ENUM('PENDENTE', 'CANCELADA', 'CONCLUIDA')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## ReservaMesa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_reserva(PK/FK)` | Identificador da reserva. | Compõe a chave primária junto com id_mesa; deve referenciar um registro existente em Reserva. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da reserva. |
| `id_mesa(PK/FK)` | Identificador da mesa reservada. | Compõe a chave primária junto com id_reserva; deve referenciar um registro existente em Mesa. Uma mesa não pode ter duas reservas não canceladas com períodos sobrepostos. (RF07, RNF06, RDN02) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da mesa. |

## Atendimento

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_atendimento(PK)` | Identificador do atendimento. | Deve ser único para cada registro de Atendimento; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_funcionario(FK)` | Identificador do funcionário responsável pelo atendimento. | Deve referenciar um registro existente em Funcionario. | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do funcionário responsável. |
| `id_reserva(FK)` | Identificador da reserva associada ao atendimento, quando houver. | Deve referenciar um registro existente em Reserva. (RNF06) | `INT` | `NULL` | Armazena números inteiros, não é uma informação obrigatória pois há atendimentos que não possuem reserva. |
| `hora_chegada` | Hora em que os clientes chegaram ao estabelecimento. | Deve informar o horário de chegada dos clientes no estabelecimento no formato 24h (ex.: 22:14) | `DATETIME` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data em que o atendimento foi iniciado. |
| `hora_saida` | Hora em que os clientes deixaram o estabelecimento. | Deve informar o horário de saída dos clientes no estabelecimento no formato 24h (ex.: 22:14) (RDN03) | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |
| `qtd_pessoas` | Quantidade de pessoas atendidas. | Deve ser informada pelo funcionário responsável pelo atendimento. | `SMALLINT UNSIGNED` | `NOT NULL` | Armazena números inteiros positivos de pequeno porte (otimizando espaço e restringindo a valores não negativos), sendo uma informação obrigatória para o registro. |

## AtendimentoMesa

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_atendimento(PK/FK)` | Identificador do atendimento. | Compõe a chave primária junto com id_mesa; deve referenciar um registro existente em Atendimento. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do atendimento. |
| `id_mesa(PK/FK)` | Identificador da mesa utilizada no atendimento. | Compõe a chave primária junto com id_atendimento; deve referenciar um registro existente em Mesa. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da mesa. |

## ItemPedido

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_pedido(PK/FK)` | Identificador do pedido. | Compõe a chave primária junto com id_produto; deve referenciar um registro existente em Pedido. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do pedido. |
| `id_produto(PK/FK)` | Identificador do produto pedido. | Compõe a chave primária junto com id_pedido; deve referenciar um registro existente em Produto. Produto com montagem especial não pode ser incluído em pedido DELIVERY. (RNF06, RDN06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do produto. |
| `quantidade` | Quantidade do produto pedida. | O produto só é vendido se estiver disponível e se o estoque permitir produzir a quantidade pedida. A baixa de estoque é calculada por itens × ficha técnica. (RDN04, RDN12) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da quantidade de itens do pedido. |
| `preco_unitario` | Preço unitário do produto no momento do pedido. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `observacao` | Observações do cliente sobre o item (ex.: sem cebola). | Deve estar atrelada individualmente a cada item do pedido. | `VARCHAR(250)` | `NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação não obrigatória, visto que a observação dos itens é opcional. |

## ItemComboPedido

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_pedido(PK/FK)` | Identificador do pedido. | Compõe a chave primária junto com id_combo; deve referenciar um registro existente em Pedido. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do pedido. |
| `id_combo(PK/FK)` | Identificador do combo pedido. | Compõe a chave primária junto com id_pedido; deve referenciar um registro existente em Combo. Combo que contenha produto com montagem especial não pode ser incluído em pedido DELIVERY. (RNF06, RDN06) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação do combo. |
| `quantidade` | Quantidade do combo pedida. | O combo só é vendido se o estoque permitir produzir a quantidade pedida. A baixa de estoque é calculada por combos × composição × ficha técnica. (RDN04, RDN12) | `INT` | `NOT NULL` | Armazena números inteiros, e é uma informação obrigatória para a identificação da quantidade de combos do pedido. |
| `preco_unitario` | Preço unitário do combo no momento do pedido. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `observacao` | Observações do cliente sobre o combo. | Deve estar atrelada individualmente a cada combo do pedido. | `VARCHAR(250)` | `NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação não obrigatória, visto que a observação dos combos é opcional. |

## Avaliacao

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_avaliacao(PK)` | Identificador da avaliação. | Deve ser único para cada registro de Avaliacao; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_pedido(FK)` | Identificador do pedido avaliado. | Deve referenciar um registro existente em Pedido. Cada pedido tem no máximo um registro de avaliação ou reclamação. (RF12) | `INT` | `NOT NULL, UNIQUE` | Armazena números inteiros, é uma informação obrigatória e única para a identificação do pedido. |
| `comentario` | Comentário deixado pelo cliente sobre o pedido. | Opcional. (RF12) | `TEXT` | `NULL` | Armazena textos longos e descritivos de tamanho variável, sendo um campo opcional que permite valor nulo caso nenhuma observação ou detalhe adicional seja informado. |
| `data` | Data em que a avaliação foi feita. | Deve informar a data e hora que a avaliação foi realizada. (exibida no formato: DD/MM/AAAA - 22:14) | `DATE` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data no formato padrão, sendo uma informação obrigatória que captura automaticamente a data exata do sistema no momento em que a avaliação é registrada. |
| `nota` | Nota atribuída pelo cliente ao pedido. | Valor de 1 a 5; zero estrelas não existe. (RF12) | `TINYINT UNSIGNED` | `NOT NULL` | Armazena números inteiros positivos de curtíssimo alcance (de 0 a 255, otimizando o espaço de armazenamento e impedindo valores negativos), sendo uma informação obrigatória para o registro. |

## Produto

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_produto(PK)` | Identificador do produto. | Deve ser único para cada registro de Produto; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_categoria(FK)` | Identificador da categoria à qual o produto pertence. | Deve referenciar um registro existente em Categoria. | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da categoria. |
| `nome` | Nome do produto. | Preenchimento obrigatório. Deve conter um nome correspondente a um produto existente. | `VARCHAR(100)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |
| `preco_base` | Preço padrão de venda do produto. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `descricao` | Descrição do produto. | O sistema deve apresentar descrição, peso (quando aplicável) e ingredientes de cada produto. (RF11) | `TEXT` | `NULL` | Armazena textos longos e descritivos de tamanho variável, sendo um campo opcional que permite valor nulo caso nenhuma observação ou detalhe adicional seja informado. |
| `montagem_especial` | Indica se o produto exige montagem especial no preparo. | Produto marcado como montagem especial não pode ser incluído em pedido DELIVERY, nem diretamente nem dentro de combo (RDN06). | `BOOLEAN` | `NOT NULL, DEFAULT FALSE` | Armazena um valor lógico (verdadeiro ou falso) para controle de estado ou condição, sendo uma informação obrigatória que assume 'FALSE' como padrão inicial caso nenhum estado seja informado na criação. |
| `tempo_preparo_min` | Armazena o tempo mínimo estimado (em minutos) para o preparo do produto pela equipe de cozinha. | Preenchimento obrigatório após a confirmação do pedido. Deve ser um valor inteiro positivo maior ou igual a zero (CHECK: tempo_preparo_min >= 0). | `SMALLINT UNSIGNED` | `NULL` | Armazena números inteiros positivos de amplo alcance (de 0 a 65.535, otimizando o armazenamento e impedindo valores negativos), sendo um campo opcional que permite valor nulo caso o tempo de preparo ainda não esteja definido ou não se aplique ao registo. |
| `disponivel` | Armazena o estado de disponibilidade do produto para venda e exibição nos canais de atendimento | Preenchimento obrigatório. Assume TRUE (1 - disponível) como valor padrão inicial ao cadastrar o produto, podendo ser alterado para FALSE (0 - indisponível) em caso de pausa operacional ou falta de insumo. (RDN07) | `BOOLEAN` | `NOT NULL, DEFAULT TRUE` | Armazena o estado binário de disponibilidade do produto, sendo obrigatório e assumindo valor verdadeiro (TRUE) por padrão ao cadastrar novos itens, permitindo alteração para falso (FALSE) quando pausado. |


## Categoria

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_categoria(PK)` | Identificador da categoria. | Deve ser único para cada registro de Categoria; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `nome` | Nome da categoria. | Preenchimento obrigatório. Deve apresentar o nome da categoria informada (ex.: 'SOBREMESA') | `ENUM('BEBIDA', 'LANCHE', 'ACOMPANHAMENTO', 'PORCAO', 'SOBREMESA')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## Combo

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_combo(PK)` | Identificador do combo. | Deve ser único para cada registro de Combo; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `nome` | Nome do combo. | Preenchimento obrigatório. Deve conter um nome correspondente a um combo existente. | `VARCHAR(100)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |
| `preco_combo` | Preço de venda do combo. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `descricao` | Descrição do combo. | O sistema deve apresentar descrição, peso (quando aplicável) e ingredientes de cada produto. (RF11) | `TEXT` | `NULL` | Armazena textos longos e descritivos de tamanho variável, sendo um campo opcional que permite valor nulo caso nenhuma observação ou detalhe adicional seja informado. |

## ItemCombo

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_combo(PK/FK)` | Identificador do combo. | Compõe a chave primária junto com id_produto; deve referenciar um registro existente em Combo. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do combo. |
| `id_produto(PK/FK)` | Identificador do produto que compõe o combo. | Compõe a chave primária junto com id_combo; deve referenciar um registro existente em Produto. Produto com montagem especial não pode compor combo vendido por DELIVERY. (RNF06, RDN06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do produto. |
| `quantidade` | Quantidade do produto no combo. | A composição do combo é usada no cálculo da baixa de estoque: combos × composição × ficha técnica. (RDN12) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da quantidade de produtos no combo. |

## Promocao

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_promocao(PK)` | Identificador da promoção. | Deve ser único para cada registro de Promocao; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `nome` | Nome da promoção. | Preenchimento obrigatório. Deve conter um nome correspondente a uma promoção existente. | `VARCHAR(100)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |
| `data_inicio` | Data de início da promoção | Define o início da vigência da campanha promocional. | `DATE` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data em que a promoção foi iniciada. |
| `data_fim` | Data de término da promoção | Define o encerramento da vigência da campanha promocional. | `DATE` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data em que a promoção foi encerrada. |
| `status` | Situação da promoção (ex.: ativa ou encerrada). | Deve registrar se a promoção está ativa ou encerrada, aceitando os valores: 'ativa' e 'encerrada'. | `ENUM('ATIVA', 'SUSPENSA', 'ENCERRADA')` | `NOT NULL, DEFAULT 'ATIVA'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'ATIVA' como o valor padrão inicial de toda promoção. |
| `tipo` | Tipo da promoção. | Inclui promoção de aniversário (exige documento conferido) e cupons. (RF17, RDN10) | `ENUM('COMBO PROMOCIONAL', 'PERCENTUAL', 'FRETE_GRATIS', 'VALOR_FIXO')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## PromocaoProduto

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_produto(PK/FK)` | Identificador do produto em promoção. | Compõe a chave primária junto com id_promocao; deve referenciar um registro existente em Produto. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do produto. |
| `id_promocao(PK/FK)` | Identificador da promoção aplicada. | Compõe a chave primária junto com id_produto; deve referenciar um registro existente em Promocao. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da promoção. |
| `percentual_desconto` | Percentual de desconto aplicado ao produto. | Todo desconto é autorizado por funcionário com permissão e o valor fica registrado no pedido. (RF17, RDN10) | `DECIMAL(5,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 5 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `quantidade_limite` | Quantidade máxima de unidades com desconto. | Valor numérico diferente de 0 (Deve informar a quantidade máxima de itens da promoção correspondente). | `INT UNSIGNED` | `NULL` | Armazena números inteiros, impossibilita a exibição de números negativos, sendo um campo opcional que permite valor nulo caso a informação ainda não esteja definida ou não se aplique ao registro. |

## PromocaoCombo

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_combo(PK/FK)` | Identificador do combo em promoção. | Compõe a chave primária junto com id_promocao; deve referenciar um registro existente em Combo. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do combo. |
| `id_promocao(PK/FK)` | Identificador da promoção aplicada. | Compõe a chave primária junto com id_combo; deve referenciar um registro existente em Promocao. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da promoção. |
| `percentual_desconto` | Percentual de desconto aplicado ao combo. | Todo desconto é autorizado por funcionário com permissão e o valor fica registrado no pedido (RF17, RDN10) | `DECIMAL(5,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 5 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `quantidade_limite` | Quantidade máxima de unidades com desconto. | Valor numérico diferente de 0 (Deve informar a quantidade máxima de itens da promoção correspondente). | `INT UNSIGNED` | `NULL` | Armazena números inteiros, impossibilita a exibição de números negativos, sendo um campo opcional que permite valor nulo caso a informação ainda não esteja definida ou não se aplique ao registro. |

## Insumo

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_insumo(PK)` | Identificador do insumo. | Deve ser único para cada registro de Insumo; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `unidade_medida` | Unidade de medida do insumo (ex.: kg, litro ou unidade). | Informada no cadastro do insumo. (RF04) | `ENUM('KG', 'G', 'L', 'ML', 'PCT', 'UN', 'CX')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `quantidade_minima` | Quantidade mínima em estoque antes de ser necessária a reposição. | Estoque mínimo: insumo abaixo deste valor entra em reposição. (RF04) | `DECIMAL(11,3)` | `NOT NULL, DEFAULT 0` | Armazena valores numéricos com precisão de até 11 dígitos e 3 casas decimais, sendo uma informação obrigatória, e define '0' como o valor padrão inicial de todo insumo. |
| `nome` | Nome do insumo. | Preenchimento obrigatório. (Deve conter um nome correspondente a um 'id_insumo'). | `VARCHAR(100)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |

## FichaTecnica

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_produto(PK/FK)` | Identificador do produto. | Compõe a chave primária junto com id_insumo; deve referenciar um registro existente em Produto. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do produto. |
| `id_insumo(PK/FK)` | Identificador do insumo utilizado na preparação do produto. | Compõe a chave primária junto com id_produto; deve referenciar um registro existente em Insumo. (RNF06) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do insumo. |
| `quantidade_necessaria` | Quantidade do insumo necessária para preparar uma unidade do produto. | Base da baixa automática de estoque quando o preparo inicia. Os ingredientes do produto vêm da ficha técnica. A embalagem individual é um insumo da ficha técnica. (RF04, RF11, RDN07, RDN12) | `DECIMAL(11,3)` | `NOT NULL` | Armazena valores numéricos com precisão de até 11 dígitos e 3 casas decimais, sendo uma informação obrigatória. |

## Compra

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_compra(PK)` | Identificador da compra. | Deve ser único para cada registro de Compra; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_fornecedor(FK)` | Identificador do fornecedor da compra. | Deve referenciar um registro existente em Fornecedor. A compra de insumos é registrada junto a um fornecedor. (RF14) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do fornecedor. |
| `id_funcionario(FK)` | Identificador do funcionário que realizou a compra. | Deve referenciar um registro existente em Funcionario. Somente funcionário de cargo com permissão de compra (gerente e proprietário) registra compra. (RDN11) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do funcionário. |
| `data_compra` | Data em que a compra foi realizada. | Preenchimento obrigatório. Informa a data e hora que a compra foi realizada. (exibida no formato: DD/MM/AAAA - 22:14) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que a compra é feita. |
| `status_compra` | Situação da compra (ex.: solicitada, recebida ou cancelada). | Deve registrar a situação da compra efetuada, aceitando os valores: 'PENDENTE', 'SOLICITADO', 'EM TRANSPORTE', 'RECEBIDA', 'CANCELADA'. | `ENUM('PENDENTE', 'SOLICITADO', 'EM TRANSPORTE', 'RECEBIDA', 'CANCELADA')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |

## ItemCompra

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_item_compra(PK)` | Identificador do item da compra. | Deve ser único para cada registro de ItemCompra; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_compra(FK)` | Identificador da compra à qual o item pertence. | Deve referenciar um registro existente em Compra. | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da compra. |
| `id_insumo(FK)` | Identificador do insumo comprado. | Deve referenciar um registro existente em Insumo. | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do insumo. |
| `quantidade_solicitada` | Quantidade do insumo solicitada ao fornecedor. | Conferida contra o recebido por lote; divergências devem ser detectáveis. (RF14) | `DECIMAL(11,3)` | `NOT NULL` | Armazena valores numéricos com precisão de até 11 dígitos e 3 casas decimais, sendo uma informação obrigatória. |
| `preco_unitario` | Preço unitário do insumo na compra. | Valor monetário em DECIMAL, nunca ponto flutuante. (RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |

## Lote

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_lote(PK)` | Identificador do lote. | Deve ser único para cada registro de Lote; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_insumo(FK)` | Identificador do insumo do lote. | Deve referenciar um registro existente em Insumo. | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do insumo. |
| `numero_lote` | Número correspondente ao lote. | Deve ser informado pelo fornecedor no ato da compra. (RF14) | `VARCHAR(80)` | `NOT NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação obrigatória. |
| `data_validade` | Data de validade do lote. | Informada no recebimento em lote e conferida contra o comprado. (RF04, RF14) | `DATE` | `NOT NULL` | Armazena uma data no formato padrão, e é uma informação obrigatória para a identificação da data de validade do lote. |
| `data_recebimento` | Data em que o lote foi recebido. | O recebimento é conferido por lote. (RF14) | `DATETIME` | `NULL` | Armazena data e hora completas no formato padrão, sendo um campo opcional que permite valor nulo caso o evento ainda não tenha ocorrido. |
| `quantidade_inicial` | Quantidade do insumo no momento do recebimento do lote. | Conferida contra a quantidade comprada. (RF14) | `DECIMAL(14,3)` | `NULL` | Armazena valores numéricos com precisão de até 14 dígitos e 3 casas decimais, sendo um campo opcional que permite valor nulo caso o dado não tenha sido obtido. |
| `status_lote` | Situação do lote (ex.: disponível, esgotado ou vencido). | Deve registrar a situação do lote, aceitando os valores: 'disponivel', 'esgotado' e 'vencido'. (RF04) | `ENUM('DISPONIVEL', 'ESGOTADO', 'VENCIDO', 'DESCARTADO')` | `NOT NULL, DEFAULT 'DISPONIVEL'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'DISPONIVEL' como o valor padrão inicial do status do lote. |

## Movimentacao

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_movimentacao(PK)` | Identificador da movimentação de estoque. | Deve ser único para cada registro de Movimentacao; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_lote(FK)` | Identificador do lote movimentado. | Deve referenciar um registro existente em Lote. | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do lote. |
| `id_funcionario(FK)` | Identificador do funcionário que realizou a movimentação. | Deve referenciar um registro existente em Funcionario. Responsável pela movimentação. (RF10) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do funcionário responsável. |
| `id_pedido(FK)` | Identificador do pedido relacionado à movimentação, quando houver. | Deve referenciar um registro existente em Pedido. Preenchido nas saídas de consumo geradas pelo preparo de um pedido. (RDN12) | `INT` | `NULL` | Armazena números inteiros, não é uma informação obrigatória, pois movimentação no estoque não implica um pedido atrelado. |
| `tipo_movimentacao` | Tipo da movimentação (ex.: entrada, saída, perda ou ajuste). | Tipos: ENTRADA, CONSUMO e AJUSTE_INVENTARIO. Perdas e desperdícios também são registrados. (RF04, RF10) | `ENUM('ENTRADA', 'CONSUMO', 'DESPERDICIO', 'PERDA', 'AJUSTE_SAIDA', 'AJUSTE_ENTRADA')` | `NOT NULL` | Restringe o campo apenas às opções pré-definidas, garantindo padronização e sendo uma informação obrigatória. |
| `quantidade` | Quantidade movimentada. | Entrada positiva, saída negativa. O saldo é a soma das movimentações e nenhuma saída pode deixá-lo negativo. (RF04, RDN12) | `DECIMAL(14,3)` | `NOT NULL` | Armazena valores numéricos com precisão de até 14 dígitos e 3 casas decimais, sendo uma informação obrigatória. |
| `data_hora` | Data e hora da movimentação. | Preenchimento obrigatório. Informa a data e hora que a movimentação foi realizada. (exibida no formato: DD/MM/AAAA - 22:14) | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que a movimentação é feita. |
| `motivo` | Motivo da movimentação. | Informado em perdas e desperdícios, como vencimento ou erro de preparo. (RF10) | `VARCHAR(255)` | `NULL` | Comporta nomes completos sem desperdiçar espaço no banco de dados, além de ser uma informação não obrigatória, pois detalhar o motivo da movimentação é opcional. |

## Reembolso

| Atributos | Descrição | Regra | Tipo de Dado | Restrições | Justificativa |
| --- | --- | --- | --- | --- | --- |
| `id_reembolso(PK)` | Identificador do reembolso. | Deve ser único para cada registro de Reembolso; preenchimento obrigatório. (RNF06) | `INT` | `AUTO_INCREMENT, PRIMARY KEY` | Armazena números inteiros, o banco de dados gera automaticamente e chave única. |
| `id_ocorrencia(FK)` | Identificador da ocorrência que originou o reembolso. | Deve referenciar um registro existente em Ocorrencia. O reembolso é registrado como ocorrência do pedido. (RF16) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação da ocorrência |
| `id_pagamento(FK)` | Identificador do pagamento reembolsado. | Deve referenciar um registro existente em Pagamento. O pagamento estornado corresponde apenas ao cancelamento do pedido. Pagamentos online de pedido cancelado são ESTORNADOS. (RDN05, RDN13) | `INT` | `NOT NULL` | Armazena números inteiros, é uma informação obrigatória para a identificação do pagamento. |
| `valor_reembolso` | Valor devolvido ao cliente. | Valor devolvido ao cliente. Valor monetário em DECIMAL, nunca ponto flutuante. (RF16, RNF09) | `DECIMAL(6,2)` | `NOT NULL` | Armazena valores numéricos com precisão de até 6 dígitos e 2 casas decimais, sendo uma informação obrigatória. |
| `data_hora` | Data e hora do reembolso. | Preenchimento obrigatório. Informa a data e hora que o reembolso foi realizado (exibida no formato: DD/MM/AAAA - 22:14). | `DATETIME` | `NOT NULL, DEFAULT CURRENT_TIMESTAMP` | Armazena data e hora completas, sendo uma informação obrigatória que captura automaticamente a data e o horário exatos do sistema no momento em que o reembolso é feito. |
| `status` | Situação do reembolso (ex.: solicitado -> em análise...). | Deve registrar a situação do reembolso, aceitando os valores: 'SOLICITADO', 'EM_ANALISE', 'APROVADO', 'REJEITADO', 'PROCESSANDO', 'CONCLUIDO', 'CANCELADO', 'FALHO' | `ENUM('SOLICITADO', 'EM_ANALISE', 'APROVADO', 'REJEITADO', 'PROCESSANDO', 'CONCLUIDO', 'CANCELADO', 'FALHO')` | `NOT NULL, DEFAULT 'SOLICITADO'` | Restringe o campo apenas às opções pré-definidas, garantindo padronização, é uma informação obrigatória e define 'SOLICITADO' como o valor padrão inicial do status do reembolso. |
