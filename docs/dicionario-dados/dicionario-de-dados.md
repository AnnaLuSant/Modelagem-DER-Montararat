# Dicionário de dados (modelo lógico, MySQL 8)

> **Gerado automaticamente** por `sql/ferramentas/gerar_docs.py` a partir de `sql/ddl/02_create_tables.sql`. Não edite à mão: altere o DDL e gere de novo. Assim o dicionário nunca contradiz o banco.

Total: **34 tabelas**. Papel: PK = chave primária, FK = chave estrangeira, UQ = única. Dados monetários são DECIMAL; domínios fechados usam CHECK ... IN (...).

## setor

Setores da hamburgueria (cargo determina o setor)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_setor` | INT (auto) | não |  | PK | Identificador do setor da empresa |
| `nome` | VARCHAR(40) | não |  | UQ | Nome do setor (Atendimento, Cozinha, Financeiro, Gestão, Estoque e Compras) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_setor` | PRIMARY KEY | `(id_setor)` |  |
| `uq_setor_nome` | UNIQUE | `(nome)` | evita setores duplicados com o mesmo nome |

## cargo

Cargos e permissões operacionais que sustentam as políticas da empresa

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_cargo` | INT (auto) | não |  | PK | Identificador do cargo |
| `nome` | VARCHAR(40) | não |  | UQ | Nome do cargo (Garçom, Chapeiro, Gerente...) |
| `id_setor` | INT | não |  | FK→setor | Setor ao qual o cargo pertence |
| `pode_comprar` | TINYINT(1) | não | 0 |  | Indica se o cargo pode comprar insumos (política: só gerente e proprietário) |
| `pode_autorizar` | TINYINT(1) | não | 0 |  | Indica se o cargo pode autorizar descontos, trocas, cancelamentos e reembolsos |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_cargo` | PRIMARY KEY | `(id_cargo)` |  |
| `uq_cargo_nome` | UNIQUE | `(nome)` | um cargo não se repete |
| `fk_cargo_setor` | FOREIGN KEY | `(id_setor) → setor(id_setor)` | cargo -> setor remove a dependência transitiva cargo->setor da tabela funcionario (3FN) |
| `ck_cargo_pode_comprar` | CHECK | `(pode_comprar IN (0, 1))` | domínio booleano |
| `ck_cargo_pode_autorizar` | CHECK | `(pode_autorizar IN (0, 1))` | domínio booleano |

## pessoa

Qualquer pessoa conhecida pelo sistema: cliente e/ou funcionário

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pessoa` | INT (auto) | não |  | PK | Identificador da pessoa (chave substituta) |
| `cpf` | CHAR(11) | sim |  | UQ | CPF apenas com dígitos; opcional porque cliente de balcão ou de aplicativo pode não informar |
| `nome` | VARCHAR(100) | não |  |  | Nome completo da pessoa |
| `telefone` | VARCHAR(11) | sim |  |  | Telefone com DDD, apenas dígitos |
| `email` | VARCHAR(120) | sim |  |  | E-mail de contato |
| `data_nascimento` | DATE | sim |  |  | Data de nascimento; necessária para a promoção de aniversário |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_pessoa` | PRIMARY KEY | `(id_pessoa)` |  |
| `uq_pessoa_cpf` | UNIQUE | `(cpf)` | um CPF identifica uma única pessoa; NULL pode repetir |
| `ck_pessoa_cpf` | CHECK | `(cpf IS NULL OR cpf REGEXP '^[0-9]{11}$')` | CPF com exatamente 11 dígitos |
| `ck_pessoa_telefone` | CHECK | `(telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$')` | telefone com DDD (10 ou 11 dígitos) |
| `ck_pessoa_email` | CHECK | `(email IS NULL OR email LIKE '%_@_%.__%')` | formato mínimo de e-mail |

## endereco

Endereços de pessoas (principalmente para delivery)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_endereco` | INT (auto) | não |  | PK | Identificador do endereço |
| `id_pessoa` | INT | não |  | FK→pessoa | Pessoa dona do endereço |
| `logradouro` | VARCHAR(120) | não |  |  | Rua, avenida ou similar |
| `numero` | VARCHAR(10) | não |  |  | Número do imóvel (texto, para aceitar S/N e letras) |
| `complemento` | VARCHAR(60) | sim |  |  | Complemento (apto, bloco, referência) |
| `bairro` | VARCHAR(60) | não |  |  | Bairro |
| `cidade` | VARCHAR(60) | não | 'São Paulo' |  | Cidade |
| `uf` | CHAR(2) | não | 'SP' |  | Sigla do estado |
| `cep` | CHAR(8) | não |  |  | CEP apenas com dígitos |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_endereco` | PRIMARY KEY | `(id_endereco)` |  |
| `fk_endereco_pessoa` | FOREIGN KEY | `(id_pessoa) → pessoa(id_pessoa)` | 1FN: endereço composto e multivalorado saiu de pessoa; uma pessoa pode ter vários endereços |
| `ck_endereco_cep` | CHECK | `(cep REGEXP '^[0-9]{8}$')` | CEP com 8 dígitos |

## funcionario

Funcionários (especialização de pessoa)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_funcionario` | INT (auto) | não |  | PK | Identificador do funcionário |
| `id_pessoa` | INT | não |  | FK→pessoa, UQ | Pessoa que é o funcionário (nome, CPF e contato ficam em pessoa) |
| `id_cargo` | INT | não |  | FK→cargo | Cargo exercido |
| `salario_bruto` | DECIMAL(10,2) | não |  |  | Remuneração mensal bruta em reais |
| `data_admissao` | DATE | não |  |  | Data de admissão |
| `data_desligamento` | DATE | sim |  |  | Data de desligamento; NULL enquanto o funcionário está ativo |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_funcionario` | PRIMARY KEY | `(id_funcionario)` |  |
| `uq_funcionario_pessoa` | UNIQUE | `(id_pessoa)` | uma pessoa é no máximo um funcionário (especialização 1:1) |
| `fk_funcionario_pessoa` | FOREIGN KEY | `(id_pessoa) → pessoa(id_pessoa)` | 3FN: nome e CPF não se repetem em funcionario |
| `fk_funcionario_cargo` | FOREIGN KEY | `(id_cargo) → cargo(id_cargo)` | cargo é um domínio cadastrado |
| `ck_funcionario_salario` | CHECK | `(salario_bruto > 0)` | remuneração positiva |
| `ck_funcionario_desligamento` | CHECK | `(data_desligamento IS NULL OR data_desligamento >= data_admissao)` | não se desliga antes de admitir |

## mesa

Mesas do salão; a ocupação ao longo do tempo é obtida de pedido e reserva

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_mesa` | INT | não |  | PK | Número da mesa no salão (definido pela casa, sem auto incremento) |
| `capacidade` | TINYINT | não |  |  | Quantidade máxima de pessoas |
| `status_mesa` | VARCHAR(10) | não | 'LIVRE' |  | Estado operacional atual: LIVRE, OCUPADA, RESERVADA ou EM_LIMPEZA |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_mesa` | PRIMARY KEY | `(id_mesa)` |  |
| `ck_mesa_capacidade` | CHECK | `(capacidade BETWEEN 1 AND 20)` | capacidade numérica e plausível |
| `ck_mesa_status` | CHECK | `(status_mesa IN ('LIVRE', 'OCUPADA', 'RESERVADA', 'EM_LIMPEZA'))` | RDN03: a limpeza só ocorre após o uso, então precisa de um estado próprio |

## reserva

Reservas de mesa feitas presencialmente (RDN02)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_reserva` | INT (auto) | não |  | PK | Identificador da reserva |
| `id_mesa` | INT | não |  | FK→mesa | Mesa reservada |
| `id_pessoa` | INT | sim |  | FK→pessoa | Cliente cadastrado que reservou, quando houver |
| `nome_contato` | VARCHAR(100) | não |  |  | Nome de quem reservou |
| `id_funcionario` | INT | não |  | FK→funcionario | Funcionário que registrou a reserva (RDN02: reserva só presencial) |
| `data_hora_inicio` | DATETIME | não |  |  | Início do período reservado |
| `data_hora_fim` | DATETIME | não |  |  | Fim do período reservado |
| `status_reserva` | VARCHAR(15) | não | 'ATIVA' |  | ATIVA, CUMPRIDA, CANCELADA ou NAO_COMPARECEU |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_reserva` | PRIMARY KEY | `(id_reserva)` |  |
| `fk_reserva_mesa` | FOREIGN KEY | `(id_mesa) → mesa(id_mesa)` | reserva sempre de uma mesa existente |
| `fk_reserva_pessoa` | FOREIGN KEY | `(id_pessoa) → pessoa(id_pessoa)` | vínculo opcional com cliente cadastrado |
| `fk_reserva_funcionario` | FOREIGN KEY | `(id_funcionario) → funcionario(id_funcionario)` | rastreia quem registrou |
| `ck_reserva_periodo` | CHECK | `(data_hora_fim > data_hora_inicio)` | período válido |
| `ck_reserva_status` | CHECK | `(status_reserva IN ('ATIVA', 'CUMPRIDA', 'CANCELADA', 'NAO_COMPARECEU'))` | domínio fechado |

## categoria_produto

Domínio fechado de categorias do cardápio

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_categoria_produto` | INT (auto) | não |  | PK | Identificador da categoria de produto |
| `nome` | VARCHAR(40) | não |  | UQ | Nome da categoria (Lanche, Bebida, Porção, Sobremesa) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_categoria_produto` | PRIMARY KEY | `(id_categoria_produto)` |  |
| `uq_categoria_produto_nome` | UNIQUE | `(nome)` | uma única grafia por categoria |

## produto

Itens do cardápio vendidos individualmente

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_produto` | INT (auto) | não |  | PK | Identificador do produto vendável |
| `nome` | VARCHAR(80) | não |  | UQ | Nome do produto no cardápio |
| `descricao` | VARCHAR(255) | sim |  |  | Descrição curta e ingredientes para o cliente (RF09) |
| `id_categoria_produto` | INT | não |  | FK→categoria_produto | Categoria do produto |
| `preco_venda` | DECIMAL(8,2) | não |  |  | Preço de venda atual em reais |
| `peso_g` | INT | sim |  |  | Peso do produto em gramas (RF09); NULL quando não se aplica |
| `tempo_preparo_min` | SMALLINT | não |  |  | Tempo padrão de preparo em minutos, base da estimativa ao cliente (RF08) |
| `disponivel` | TINYINT(1) | não | 1 |  | Indica se o produto pode ser vendido agora (RDN04) |
| `montagem_especial` | TINYINT(1) | não | 0 |  | Indica produto de montagem especial, vedado no delivery (RDN06) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_produto` | PRIMARY KEY | `(id_produto)` |  |
| `uq_produto_nome` | UNIQUE | `(nome)` | evita duplicidade acidental no cadastro |
| `fk_produto_categoria` | FOREIGN KEY | `(id_categoria_produto) → categoria_produto(id_categoria_produto)` | categoria é domínio fixo |
| `ck_produto_preco` | CHECK | `(preco_venda > 0)` | preço positivo |
| `ck_produto_peso` | CHECK | `(peso_g IS NULL OR peso_g > 0)` | peso positivo quando informado |
| `ck_produto_tempo` | CHECK | `(tempo_preparo_min >= 0)` | tempo não negativo |
| `ck_produto_disponivel` | CHECK | `(disponivel IN (0, 1))` | domínio booleano |
| `ck_produto_montagem` | CHECK | `(montagem_especial IN (0, 1))` | domínio booleano |

## combo

Cadastro de combos: uma entidade para todas as combinações (decisão da 1ª entrega)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_combo` | INT (auto) | não |  | PK | Identificador do combo (cadastro) |
| `nome` | VARCHAR(80) | não |  | UQ | Nome do combo |
| `descricao` | VARCHAR(255) | sim |  |  | Descrição do combo |
| `preco_venda` | DECIMAL(8,2) | não |  |  | Preço de venda atual do combo em reais |
| `ativo` | TINYINT(1) | não | 1 |  | Indica se o combo está à venda |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_combo` | PRIMARY KEY | `(id_combo)` |  |
| `uq_combo_nome` | UNIQUE | `(nome)` | sem combos duplicados |
| `ck_combo_preco` | CHECK | `(preco_venda > 0)` | preço positivo |
| `ck_combo_ativo` | CHECK | `(ativo IN (0, 1))` | domínio booleano |

## item_combo

Composição do combo (associativa N:N combo x produto)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_combo` | INT | não |  | PK, FK→combo | Combo ao qual o item pertence |
| `id_produto` | INT | não |  | PK, FK→produto | Produto que compõe o combo |
| `quantidade` | SMALLINT | não |  |  | Quantidade do produto dentro do combo |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_item_combo` | PRIMARY KEY | `(id_combo, id_produto)` | um produto aparece uma vez por combo; a quantidade é atributo da associação |
| `fk_item_combo_combo` | FOREIGN KEY | `(id_combo) → combo(id_combo)` | item sempre de um combo existente |
| `fk_item_combo_produto` | FOREIGN KEY | `(id_produto) → produto(id_produto)` | item sempre de um produto existente |
| `ck_item_combo_quantidade` | CHECK | `(quantidade > 0)` | devolutiva: validar a quantidade dos produtos do combo |

## favorito

Produtos favoritos do cliente (RF18, antigo RNF02: era funcionalidade, não requisito não funcional)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pessoa` | INT | não |  | PK, FK→pessoa | Cliente que salvou o produto |
| `id_produto` | INT | não |  | PK, FK→produto | Produto salvo como favorito |
| `data_hora_salvo` | DATETIME | não |  |  | Momento em que o cliente salvou (define a ordem da lista: do mais recente ao mais antigo) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_favorito` | PRIMARY KEY | `(id_pessoa, id_produto)` | um produto só entra uma vez na lista de cada cliente |
| `fk_favorito_pessoa` | FOREIGN KEY | `(id_pessoa) → pessoa(id_pessoa)` | favorito de uma pessoa cadastrada |
| `fk_favorito_produto` | FOREIGN KEY | `(id_produto) → produto(id_produto)` | favorito é um produto do cardápio |

## categoria_insumo

Categorias de insumo padronizadas (problema: nomenclaturas confusas)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_categoria_insumo` | INT (auto) | não |  | PK | Identificador da categoria de insumo |
| `nome` | VARCHAR(40) | não |  | UQ | Nome da categoria (Pães, Carnes, Queijos, Bebidas, Embalagens...) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_categoria_insumo` | PRIMARY KEY | `(id_categoria_insumo)` |  |
| `uq_categoria_insumo_nome` | UNIQUE | `(nome)` | resolve categorias genéricas ou fragmentadas da lista de compras |

## insumo

Insumos (matéria-prima) controlados em estoque; a validade fica no lote

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_insumo` | INT (auto) | não |  | PK | Identificador do insumo |
| `nome` | VARCHAR(80) | não |  | UQ | Nome do insumo (ex.: Queijo cheddar fatiado) |
| `marca` | VARCHAR(60) | não | 'SEM MARCA' | UQ | Marca do insumo, como na lista de compras |
| `id_categoria_insumo` | INT | não |  | FK→categoria_insumo | Categoria do insumo |
| `unidade_medida` | VARCHAR(2) | não |  |  | Unidade base de estoque e de consumo: G, ML ou UN |
| `unidade_compra` | VARCHAR(20) | não |  |  | Unidade em que o item é pedido ao fornecedor, como na lista de compras (fardo, caixa, pacote, balde...) |
| `fator_conversao` | DECIMAL(12,3) | não |  |  | Quantos da unidade de medida base há em uma unidade de compra (ex.: 1 fardo = 12 UN) |
| `estoque_minimo` | DECIMAL(12,3) | não | 0 |  | Saldo mínimo, na unidade de medida, que dispara a reposição |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_insumo` | PRIMARY KEY | `(id_insumo)` |  |
| `uq_insumo_nome_marca` | UNIQUE | `(nome, marca)` | impede cadastro duplicado do mesmo item e marca |
| `fk_insumo_categoria` | FOREIGN KEY | `(id_categoria_insumo) → categoria_insumo(id_categoria_insumo)` | categoria padronizada |
| `ck_insumo_unidade` | CHECK | `(unidade_medida IN ('G', 'ML', 'UN'))` | unidades de consumo suportadas; compras em kg, L ou caixa são convertidas para a unidade base |
| `ck_insumo_minimo` | CHECK | `(estoque_minimo >= 0)` | mínimo não negativo |
| `ck_insumo_fator` | CHECK | `(fator_conversao > 0)` | conversão positiva |

## ficha_tecnica

Receita do produto (associativa N:N produto x insumo); inclui a embalagem como insumo (RDN07)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_produto` | INT | não |  | PK, FK→produto | Produto que consome o insumo |
| `id_insumo` | INT | não |  | PK, FK→insumo | Insumo consumido |
| `quantidade` | DECIMAL(10,3) | não |  |  | Quantidade do insumo, na unidade de medida do insumo, por unidade do produto |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_ficha_tecnica` | PRIMARY KEY | `(id_produto, id_insumo)` | um insumo aparece uma vez na receita de cada produto |
| `fk_ficha_produto` | FOREIGN KEY | `(id_produto) → produto(id_produto)` | receita de um produto existente |
| `fk_ficha_insumo` | FOREIGN KEY | `(id_insumo) → insumo(id_insumo)` | insumo existente |
| `ck_ficha_quantidade` | CHECK | `(quantidade > 0)` | consumo positivo; base do cálculo de baixa de estoque |

## fornecedor

Fornecedores de insumos

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_fornecedor` | INT (auto) | não |  | PK | Identificador do fornecedor |
| `cnpj` | CHAR(14) | não |  | UQ | CNPJ apenas com dígitos |
| `razao_social` | VARCHAR(120) | não |  |  | Razão social ou nome do fornecedor |
| `telefone` | VARCHAR(11) | sim |  |  | Telefone com DDD, apenas dígitos |
| `email` | VARCHAR(120) | sim |  |  | E-mail de contato |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_fornecedor` | PRIMARY KEY | `(id_fornecedor)` |  |
| `uq_fornecedor_cnpj` | UNIQUE | `(cnpj)` | um CNPJ por fornecedor |
| `ck_fornecedor_cnpj` | CHECK | `(cnpj REGEXP '^[0-9]{14}$')` | CNPJ com 14 dígitos |
| `ck_fornecedor_telefone` | CHECK | `(telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$')` | telefone com DDD |

## fornecedor_insumo

Quais insumos cada fornecedor atende (associativa N:N fornecedor x insumo)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_fornecedor` | INT | não |  | PK, FK→fornecedor | Fornecedor que oferece o insumo |
| `id_insumo` | INT | não |  | PK, FK→insumo | Insumo oferecido |
| `prazo_entrega_dias` | SMALLINT | sim |  |  | Prazo habitual de entrega em dias |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_fornecedor_insumo` | PRIMARY KEY | `(id_fornecedor, id_insumo)` | o par fornecedor x insumo é único |
| `fk_forn_insumo_fornecedor` | FOREIGN KEY | `(id_fornecedor) → fornecedor(id_fornecedor)` | fornecedor existente |
| `fk_forn_insumo_insumo` | FOREIGN KEY | `(id_insumo) → insumo(id_insumo)` | insumo existente |
| `ck_forn_insumo_prazo` | CHECK | `(prazo_entrega_dias IS NULL OR prazo_entrega_dias >= 0)` | prazo não negativo |

## compra

Cabeçalho da compra de insumos (substitui o antigo Fornecimento)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_compra` | INT (auto) | não |  | PK | Identificador do pedido de compra |
| `id_fornecedor` | INT | não |  | FK→fornecedor | Fornecedor contratado |
| `id_funcionario` | INT | não |  | FK→funcionario | Funcionário que realizou a compra (política: gerente ou proprietário) |
| `data_hora_compra` | DATETIME | não |  |  | Momento em que a compra foi feita |
| `status_compra` | VARCHAR(16) | não | 'PEDIDA' |  | PEDIDA, RECEBIDA_PARCIAL, RECEBIDA ou CANCELADA |
| `observacao` | VARCHAR(255) | sim |  |  | Observações da compra |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_compra` | PRIMARY KEY | `(id_compra)` |  |
| `fk_compra_fornecedor` | FOREIGN KEY | `(id_fornecedor) → fornecedor(id_fornecedor)` | compra sempre de um fornecedor |
| `fk_compra_funcionario` | FOREIGN KEY | `(id_funcionario) → funcionario(id_funcionario)` | rastreia o comprador; a permissão é validada no trigger trg_compra_bi |
| `ck_compra_status` | CHECK | `(status_compra IN ('PEDIDA', 'RECEBIDA_PARCIAL', 'RECEBIDA', 'CANCELADA'))` | compra, recebimento e conferência são etapas distintas |

## item_compra

Itens de cada compra (associativa N:N compra x insumo)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_compra` | INT | não |  | PK, FK→compra | Compra à qual o item pertence |
| `id_insumo` | INT | não |  | PK, FK→insumo | Insumo comprado |
| `quantidade` | DECIMAL(12,3) | não |  |  | Quantidade comprada, convertida para a unidade de medida do insumo |
| `valor_total` | DECIMAL(10,2) | não |  |  | Valor total pago pelo item em reais (o preço unitário é derivado) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_item_compra` | PRIMARY KEY | `(id_compra, id_insumo)` | 2FN: data da compra e fornecedor dependem só de id_compra e ficam no cabeçalho |
| `fk_item_compra_compra` | FOREIGN KEY | `(id_compra) → compra(id_compra)` | item de uma compra existente |
| `fk_item_compra_insumo` | FOREIGN KEY | `(id_insumo) → insumo(id_insumo)` | insumo existente |
| `ck_item_compra_quantidade` | CHECK | `(quantidade > 0)` | quantidade positiva |
| `ck_item_compra_valor` | CHECK | `(valor_total >= 0)` | valor não negativo |

## recebimento

Recebimento e conferência de mercadorias

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_recebimento` | INT (auto) | não |  | PK | Identificador do recebimento (conferência de entrega) |
| `id_compra` | INT | não |  | FK→compra | Compra que está sendo recebida |
| `id_funcionario` | INT | não |  | FK→funcionario | Funcionário que conferiu a entrega |
| `data_hora_recebimento` | DATETIME | não |  |  | Momento da conferência |
| `numero_nota_fiscal` | VARCHAR(20) | sim |  |  | Número da nota fiscal do fornecedor |
| `observacao` | VARCHAR(255) | sim |  |  | Divergências ou observações da conferência |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_recebimento` | PRIMARY KEY | `(id_recebimento)` |  |
| `fk_recebimento_compra` | FOREIGN KEY | `(id_compra) → compra(id_compra)` | toda entrega pertence a uma compra; uma compra pode ter vários recebimentos |
| `fk_recebimento_funcionario` | FOREIGN KEY | `(id_funcionario) → funcionario(id_funcionario)` | registra quem conferiu |

## lote

Lotes recebidos, com validade própria

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_lote` | INT (auto) | não |  | PK | Identificador do lote recebido |
| `id_recebimento` | INT | não |  | FK→recebimento | Recebimento em que o lote chegou |
| `id_insumo` | INT | não |  | FK→insumo | Insumo do lote |
| `codigo_lote` | VARCHAR(30) | sim |  |  | Código do lote impresso pelo fornecedor |
| `quantidade_recebida` | DECIMAL(12,3) | não |  |  | Quantidade que chegou, na unidade de medida do insumo |
| `data_validade` | DATE | sim |  |  | Validade do lote; NULL para itens sem validade controlada |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_lote` | PRIMARY KEY | `(id_lote)` |  |
| `fk_lote_recebimento` | FOREIGN KEY | `(id_recebimento) → recebimento(id_recebimento)` | lote nasce de um recebimento |
| `fk_lote_insumo` | FOREIGN KEY | `(id_insumo) → insumo(id_insumo)` | validade pertence ao lote e não ao insumo (normalização) |
| `ck_lote_quantidade` | CHECK | `(quantidade_recebida > 0)` | quantidade positiva |

## promocao

Promoções aplicáveis a pedidos (política de aniversário)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_promocao` | INT (auto) | não |  | PK | Identificador da promoção |
| `nome` | VARCHAR(60) | não |  | UQ | Nome da promoção |
| `tipo_promocao` | VARCHAR(12) | não |  |  | ANIVERSARIO ou CUPOM |
| `percentual_desconto` | DECIMAL(5,2) | não |  |  | Percentual de desconto aplicado ao pedido |
| `exige_documento` | TINYINT(1) | não | 0 |  | Indica se exige conferência de documento pessoal (promoção de aniversário) |
| `ativa` | TINYINT(1) | não | 1 |  | Indica se a promoção está vigente |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_promocao` | PRIMARY KEY | `(id_promocao)` |  |
| `uq_promocao_nome` | UNIQUE | `(nome)` | sem promoções duplicadas |
| `ck_promocao_tipo` | CHECK | `(tipo_promocao IN ('ANIVERSARIO', 'CUPOM'))` | domínio fechado |
| `ck_promocao_percentual` | CHECK | `(percentual_desconto > 0 AND percentual_desconto <= 100)` | percentual válido |
| `ck_promocao_exige_doc` | CHECK | `(exige_documento IN (0, 1))` | domínio booleano |
| `ck_promocao_ativa` | CHECK | `(ativa IN (0, 1))` | domínio booleano |

## forma_pagamento

Domínio das formas de pagamento e custo de recebimento

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_forma_pagamento` | INT (auto) | não |  | PK | Identificador da forma de pagamento |
| `nome` | VARCHAR(30) | não |  | UQ | PIX, Cartão de débito, Cartão de crédito, Dinheiro, Online iFood, Online 99food |
| `taxa_percentual` | DECIMAL(5,2) | não | 0 |  | Taxa percentual cobrada pela operadora ou plataforma sobre o valor recebido |
| `grupo_fechamento` | VARCHAR(8) | não |  |  | Linha da fita de fechamento em que a forma é somada: DINHEIRO, CARTAO ou OUTRAS |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_forma_pagamento` | PRIMARY KEY | `(id_forma_pagamento)` |  |
| `uq_forma_pagamento_nome` | UNIQUE | `(nome)` | forma de pagamento com grafia única (substitui o texto livre) |
| `ck_forma_pagamento_taxa` | CHECK | `(taxa_percentual BETWEEN 0 AND 100)` | percentual válido |
| `ck_forma_pagamento_grupo` | CHECK | `(grupo_fechamento IN ('DINHEIRO', 'CARTAO', 'OUTRAS'))` | as três linhas de recebimento da fita de fechamento |

## caixa

Turnos de caixa por terminal (fechamento de turno, como na fita de fechamento)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_caixa` | INT (auto) | não |  | PK | Identificador da sessão de caixa (turno) |
| `terminal` | VARCHAR(30) | não |  |  | Nome do terminal/PDV que operou o turno (na fita: "Mont Ararat Delivery", que também registra vendas de mesa e balcão) |
| `id_funcionario_abertura` | INT | não |  | FK→funcionario | Funcionário que abriu o caixa |
| `id_funcionario_fechamento` | INT | sim |  | FK→funcionario | Funcionário que fechou o caixa |
| `data_hora_abertura` | DATETIME | não |  |  | Momento da abertura |
| `data_hora_fechamento` | DATETIME | sim |  |  | Momento do fechamento; NULL enquanto aberto |
| `valor_abertura` | DECIMAL(10,2) | não | 0 |  | Fundo de troco informado na abertura |
| `valor_fechamento` | DECIMAL(10,2) | sim |  |  | Valor de fechamento informado pelo operador (fita: "VALOR DE FECHAMENTO"); esperado = abertura + soma de recebimentos |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_caixa` | PRIMARY KEY | `(id_caixa)` |  |
| `fk_caixa_abertura` | FOREIGN KEY | `(id_funcionario_abertura) → funcionario(id_funcionario)` | quem abriu |
| `fk_caixa_fechamento` | FOREIGN KEY | `(id_funcionario_fechamento) → funcionario(id_funcionario)` | quem fechou |
| `ck_caixa_terminal` | CHECK | `(LENGTH(TRIM(terminal)) > 0)` | terminal identificado (o relatório de fechamento traz o nome do terminal) |
| `ck_caixa_valor_abertura` | CHECK | `(valor_abertura >= 0)` | fundo não negativo |
| `ck_caixa_fechamento` | CHECK | `((data_hora_fechamento IS NULL AND id_funcionario_fechamento IS NULL AND valor_fechamento IS NULL) OR (data_hora_fechamento IS NOT NULL AND id_funcionario_fechamento IS NOT NULL AND valor_fechamento IS NOT NULL AND data_hora_fechamento >= data_hora_abertura))` | fechamento é tudo ou nada e não precede a abertura |

## entregador

Entregadores (o texto do projeto cita o motoboy, que não estava modelado)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_entregador` | INT (auto) | não |  | PK | Identificador do entregador (motoboy) |
| `nome` | VARCHAR(100) | não |  |  | Nome do entregador |
| `telefone` | VARCHAR(11) | sim |  |  | Telefone com DDD, apenas dígitos |
| `vinculo` | VARCHAR(10) | não |  |  | PROPRIO (da casa) ou PLATAFORMA (iFood/99food) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_entregador` | PRIMARY KEY | `(id_entregador)` |  |
| `ck_entregador_vinculo` | CHECK | `(vinculo IN ('PROPRIO', 'PLATAFORMA'))` | domínio fechado |
| `ck_entregador_telefone` | CHECK | `(telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$')` | telefone com DDD |

## pedido

Pedidos de clientes; totais e situação de pagamento são derivados por view

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pedido` | INT (auto) | não |  | PK | Identificador do pedido |
| `id_pessoa` | INT | sim |  | FK→pessoa | Cliente que fez o pedido; NULL para cliente não identificado |
| `id_funcionario` | INT | não |  | FK→funcionario | Funcionário que lançou o pedido (atendente ou garçom) |
| `id_mesa` | INT | sim |  | FK→mesa | Mesa do pedido presencial; NULL quando não há mesa |
| `id_promocao` | INT | sim |  | FK→promocao | Promoção aplicada, quando houver |
| `id_funcionario_autorizador` | INT | sim |  | FK→funcionario | Funcionário que autorizou o desconto (obrigatório quando há desconto) |
| `canal` | VARCHAR(10) | não |  |  | Origem do pedido: SALAO, BALCAO, IFOOD ou 99FOOD |
| `modalidade` | VARCHAR(10) | não |  |  | LOCAL (consumo no estabelecimento), RETIRADA ou DELIVERY; define a prioridade na fila |
| `status_pedido` | VARCHAR(12) | não | 'ABERTO' |  | ABERTO, EM_PRODUCAO, PRONTO, ENTREGUE, CONCLUIDO (entregue e pago) ou CANCELADO |
| `data_hora_pedido` | DATETIME | não |  |  | Momento em que o pedido foi lançado |
| `data_hora_inicio_preparo` | DATETIME | sim |  |  | Momento em que a cozinha iniciou o preparo |
| `data_hora_pronto` | DATETIME | sim |  |  | Momento em que o pedido ficou pronto |
| `data_hora_encerramento` | DATETIME | sim |  |  | Momento em que o pedido foi concluído ou cancelado |
| `valor_desconto` | DECIMAL(8,2) | não | 0 |  | Desconto total em reais concedido ao pedido |
| `valor_servico` | DECIMAL(8,2) | não | 0 |  | Taxa de serviço de mesa cobrada em reais (aparece como "Serviço de mesa" na fita de fechamento); 0 fora do salão |
| `documento_conferido` | TINYINT(1) | não | 0 |  | Indica que o documento pessoal foi conferido (promoção de aniversário) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_pedido` | PRIMARY KEY | `(id_pedido)` |  |
| `fk_pedido_pessoa` | FOREIGN KEY | `(id_pessoa) → pessoa(id_pessoa)` | cliente opcional: venda de balcão pode ser anônima |
| `fk_pedido_funcionario` | FOREIGN KEY | `(id_funcionario) → funcionario(id_funcionario)` | RF01: quem atendeu |
| `fk_pedido_mesa` | FOREIGN KEY | `(id_mesa) → mesa(id_mesa)` | RF07: liga a mesa ao consumo |
| `fk_pedido_promocao` | FOREIGN KEY | `(id_promocao) → promocao(id_promocao)` | promoção cadastrada |
| `fk_pedido_autorizador` | FOREIGN KEY | `(id_funcionario_autorizador) → funcionario(id_funcionario)` | política: descontos são autorizados pelo gerente |
| `ck_pedido_canal` | CHECK | `(canal IN ('SALAO', 'BALCAO', 'IFOOD', '99FOOD'))` | domínio fechado dos canais |
| `ck_pedido_modalidade` | CHECK | `(modalidade IN ('LOCAL', 'RETIRADA', 'DELIVERY'))` | RF11 e RDN09 (prioridade da fila) |
| `ck_pedido_status` | CHECK | `(status_pedido IN ('ABERTO', 'EM_PRODUCAO', 'PRONTO', 'ENTREGUE', 'CONCLUIDO', 'CANCELADO'))` | devolutiva: distinguir entregue, cancelado e concluído |
| `ck_pedido_canal_modalidade` | CHECK | `((canal <> 'SALAO' OR modalidade = 'LOCAL') AND (canal NOT IN ('IFOOD', '99FOOD') OR modalidade <> 'LOCAL'))` | pedido de salão é local; pedido de aplicativo nunca é consumido no local |
| `ck_pedido_mesa_local` | CHECK | `(id_mesa IS NULL OR modalidade = 'LOCAL')` | mesa só existe em consumo no local |
| `ck_pedido_desconto` | CHECK | `(valor_desconto >= 0)` | desconto não negativo |
| `ck_pedido_servico` | CHECK | `(valor_servico >= 0 AND (valor_servico = 0 OR id_mesa IS NOT NULL))` | taxa de serviço só existe em atendimento de mesa |
| `ck_pedido_desconto_autorizado` | CHECK | `(valor_desconto = 0 OR id_funcionario_autorizador IS NOT NULL)` | política: desconto exige autorização |
| `ck_pedido_documento` | CHECK | `(documento_conferido IN (0, 1))` | domínio booleano |
| `ck_pedido_ordem_inicio` | CHECK | `(data_hora_inicio_preparo IS NULL OR data_hora_inicio_preparo >= data_hora_pedido)` | o preparo não começa antes do pedido |
| `ck_pedido_ordem_pronto` | CHECK | `(data_hora_pronto IS NULL OR (data_hora_inicio_preparo IS NOT NULL AND data_hora_pronto >= data_hora_inicio_preparo))` | pronto exige início e vem depois |
| `ck_pedido_ordem_encerra` | CHECK | `(data_hora_encerramento IS NULL OR data_hora_encerramento >= data_hora_pedido)` | encerramento não precede o pedido |
| `ck_pedido_encerramento` | CHECK | `((status_pedido IN ('CONCLUIDO', 'CANCELADO')) = (data_hora_encerramento IS NOT NULL))` | só pedidos concluídos ou cancelados têm encerramento |
| `ck_pedido_marcos` | CHECK | `(status_pedido NOT IN ('PRONTO', 'ENTREGUE', 'CONCLUIDO') OR data_hora_pronto IS NOT NULL)` | estados avançados exigem o marco "pronto" |

## item_pedido

Itens avulsos do pedido (associativa N:N pedido x produto); o subtotal é calculado

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pedido` | INT | não |  | PK, FK→pedido | Pedido ao qual o item pertence |
| `numero_item` | SMALLINT | não |  | PK | Sequência da linha dentro do pedido (permite o mesmo produto com observações diferentes) |
| `id_produto` | INT | não |  | FK→produto | Produto vendido |
| `quantidade` | SMALLINT | não |  |  | Quantidade vendida |
| `preco_unitario` | DECIMAL(8,2) | não |  |  | Preço unitário praticado na venda (cópia do preço vigente no momento; RDN14: o preço histórico não muda com reajustes) |
| `observacao` | VARCHAR(200) | sim |  |  | Observação do cliente sobre o item (ex.: sem cebola) |
| `cancelado` | TINYINT(1) | não | 0 |  | Indica item cancelado antes do preparo: continua registrado, mas não entra no total nem no consumo (fita: "Cancelamentos mesa") |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_item_pedido` | PRIMARY KEY | `(id_pedido, numero_item)` | chave composta: o mesmo produto pode aparecer em linhas distintas |
| `fk_item_pedido_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | item de um pedido existente |
| `fk_item_pedido_produto` | FOREIGN KEY | `(id_produto) → produto(id_produto)` | produto existente |
| `ck_item_pedido_quantidade` | CHECK | `(quantidade > 0)` | RF03: quantidade positiva |
| `ck_item_pedido_preco` | CHECK | `(preco_unitario > 0)` | preço positivo |
| `ck_item_pedido_cancelado` | CHECK | `(cancelado IN (0, 1))` | domínio booleano |

## item_combo_pedido

Combos incluídos no pedido (associativa N:N pedido x combo)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pedido` | INT | não |  | PK, FK→pedido | Pedido ao qual o combo pertence |
| `numero_item` | SMALLINT | não |  | PK | Sequência da linha de combo dentro do pedido |
| `id_combo` | INT | não |  | FK→combo | Combo vendido (cadastro distinto da inclusão no pedido) |
| `quantidade` | SMALLINT | não |  |  | Quantidade de combos vendidos |
| `preco_unitario` | DECIMAL(8,2) | não |  |  | Preço do combo praticado na venda (RDN14) |
| `observacao` | VARCHAR(200) | sim |  |  | Observação do cliente sobre o combo |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_item_combo_pedido` | PRIMARY KEY | `(id_pedido, numero_item)` | chave composta própria dos combos no pedido |
| `fk_item_combo_pedido_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | pedido existente |
| `fk_item_combo_pedido_combo` | FOREIGN KEY | `(id_combo) → combo(id_combo)` | referencia o combo (e não um produto), distinguindo cadastro e inclusão |
| `ck_item_combo_pedido_quantidade` | CHECK | `(quantidade > 0)` | quantidade positiva |
| `ck_item_combo_pedido_preco` | CHECK | `(preco_unitario > 0)` | preço positivo |

## pagamento

Pagamentos recebidos (permite pagamento dividido e pagamento online)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_pagamento` | INT (auto) | não |  | PK | Identificador do pagamento |
| `id_pedido` | INT | não |  | FK→pedido | Pedido pago (um pedido pode ter vários pagamentos) |
| `id_forma_pagamento` | INT | não |  | FK→forma_pagamento | Forma de pagamento utilizada |
| `id_caixa` | INT | não |  | FK→caixa | Sessão de caixa em que o pagamento foi registrado |
| `valor` | DECIMAL(8,2) | não |  |  | Valor pago em reais |
| `data_hora_pagamento` | DATETIME | não |  |  | Momento do pagamento |
| `status_pagamento` | VARCHAR(10) | não | 'CONFIRMADO' |  | PENDENTE, CONFIRMADO, ESTORNADO ou RECUSADO |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_pagamento` | PRIMARY KEY | `(id_pagamento)` |  |
| `fk_pagamento_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | corrige a 1ª entrega: o pagamento não estava ligado ao pedido |
| `fk_pagamento_forma` | FOREIGN KEY | `(id_forma_pagamento) → forma_pagamento(id_forma_pagamento)` | RF02: forma de pagamento cadastrada |
| `fk_pagamento_caixa` | FOREIGN KEY | `(id_caixa) → caixa(id_caixa)` | movimento de caixa rastreável |
| `ck_pagamento_valor` | CHECK | `(valor > 0)` | estorno é um status e não um valor negativo |
| `ck_pagamento_status` | CHECK | `(status_pagamento IN ('PENDENTE', 'CONFIRMADO', 'ESTORNADO', 'RECUSADO'))` | etapas do pagamento |

## ocorrencia

RF16: trocas, cancelamentos e reembolsos (resolve a contradição entre RDN05 e a política de cancelamento)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_ocorrencia` | INT (auto) | não |  | PK | Identificador da ocorrência |
| `id_pedido` | INT | não |  | FK→pedido | Pedido afetado |
| `id_funcionario_autorizador` | INT | não |  | FK→funcionario | Funcionário que autorizou (política: gerente) |
| `tipo_ocorrencia` | VARCHAR(12) | não |  |  | TROCA, CANCELAMENTO ou REEMBOLSO |
| `causa` | VARCHAR(15) | não |  |  | ERRO_DA_CASA, INSATISFACAO, DESISTENCIA ou OUTRO |
| `houve_consumo` | TINYINT(1) | não |  |  | Indica se o produto já havia sido consumido |
| `valor_reembolso` | DECIMAL(8,2) | sim |  |  | Valor devolvido; preenchido somente no reembolso |
| `descricao` | VARCHAR(255) | sim |  |  | Detalhes da ocorrência |
| `data_hora_ocorrencia` | DATETIME | não |  |  | Momento da ocorrência |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_ocorrencia` | PRIMARY KEY | `(id_ocorrencia)` |  |
| `fk_ocorrencia_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | ocorrência sempre de um pedido |
| `fk_ocorrencia_autorizador` | FOREIGN KEY | `(id_funcionario_autorizador) → funcionario(id_funcionario)` | autorização rastreável |
| `ck_ocorrencia_tipo` | CHECK | `(tipo_ocorrencia IN ('TROCA', 'CANCELAMENTO', 'REEMBOLSO'))` | domínio fechado |
| `ck_ocorrencia_causa` | CHECK | `(causa IN ('ERRO_DA_CASA', 'INSATISFACAO', 'DESISTENCIA', 'OUTRO'))` | domínio fechado |
| `ck_ocorrencia_consumo` | CHECK | `(houve_consumo IN (0, 1))` | domínio booleano |
| `ck_ocorrencia_politica` | CHECK | `((tipo_ocorrencia = 'TROCA' AND (houve_consumo = 0 OR causa = 'ERRO_DA_CASA')) OR (tipo_ocorrencia IN ('CANCELAMENTO', 'REEMBOLSO') AND houve_consumo = 0))` | política resolvida (RDN05): cancelamento e reembolso só sem consumo; troca após consumo só por erro da casa |
| `ck_ocorrencia_reembolso` | CHECK | `((tipo_ocorrencia = 'REEMBOLSO' AND valor_reembolso IS NOT NULL AND valor_reembolso > 0) OR (tipo_ocorrencia <> 'REEMBOLSO' AND valor_reembolso IS NULL))` | valor só existe no reembolso |

## entrega

Entrega de pedidos delivery (RF11); a retirada pelo entregador na porta é procedimento (RDN08) e só a saída é registrada

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_entrega` | INT (auto) | não |  | PK | Identificador da entrega |
| `id_pedido` | INT | não |  | FK→pedido, UQ | Pedido entregue (somente modalidade DELIVERY) |
| `id_endereco` | INT | não |  | FK→endereco | Endereço de destino |
| `id_entregador` | INT | sim |  | FK→entregador | Entregador responsável; NULL até ser designado |
| `taxa_entrega` | DECIMAL(6,2) | não | 0 |  | Taxa de entrega cobrada em reais |
| `status_entrega` | VARCHAR(12) | não | 'AGUARDANDO' |  | AGUARDANDO, EM_ROTA, ENTREGUE ou NAO_ENTREGUE |
| `data_hora_saida` | DATETIME | sim |  |  | Momento em que o entregador saiu |
| `data_hora_entrega` | DATETIME | sim |  |  | Momento em que o pedido chegou ao cliente |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_entrega` | PRIMARY KEY | `(id_entrega)` |  |
| `uq_entrega_pedido` | UNIQUE | `(id_pedido)` | um pedido tem no máximo uma entrega |
| `fk_entrega_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | entrega de um pedido existente |
| `fk_entrega_endereco` | FOREIGN KEY | `(id_endereco) → endereco(id_endereco)` | o endereço fica em endereco, sem duplicação de texto |
| `fk_entrega_entregador` | FOREIGN KEY | `(id_entregador) → entregador(id_entregador)` | motoboy cadastrado |
| `ck_entrega_status` | CHECK | `(status_entrega IN ('AGUARDANDO', 'EM_ROTA', 'ENTREGUE', 'NAO_ENTREGUE'))` | etapas da entrega |
| `ck_entrega_taxa` | CHECK | `(taxa_entrega >= 0)` | taxa não negativa |
| `ck_entrega_saida` | CHECK | `(status_entrega NOT IN ('EM_ROTA', 'ENTREGUE') OR (id_entregador IS NOT NULL AND data_hora_saida IS NOT NULL))` | em rota exige entregador e saída |
| `ck_entrega_chegada` | CHECK | `((status_entrega = 'ENTREGUE') = (data_hora_entrega IS NOT NULL))` | chegada só existe quando entregue |
| `ck_entrega_ordem` | CHECK | `(data_hora_entrega IS NULL OR (data_hora_saida IS NOT NULL AND data_hora_entrega >= data_hora_saida))` | chegada depois da saída |

## avaliacao

Avaliações e reclamações dos clientes

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_avaliacao` | INT (auto) | não |  | PK | Identificador da avaliação ou reclamação |
| `id_pedido` | INT | não |  | FK→pedido, UQ | Pedido avaliado |
| `tipo_avaliacao` | VARCHAR(10) | não |  |  | AVALIACAO ou RECLAMACAO (RF10) |
| `nota` | TINYINT | não |  |  | Nota de 1 a 5 estrelas |
| `comentario` | VARCHAR(500) | sim |  |  | Texto livre do cliente |
| `data_hora_avaliacao` | DATETIME | não |  |  | Momento do registro |
| `status_tratamento` | VARCHAR(10) | sim |  |  | Ciclo de tratamento da reclamação: ABERTA, EM_ANALISE ou RESOLVIDA; NULL para avaliações |
| `id_funcionario_responsavel` | INT | sim |  | FK→funcionario | Funcionário que trata a reclamação |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_avaliacao` | PRIMARY KEY | `(id_avaliacao)` |  |
| `uq_avaliacao_pedido` | UNIQUE | `(id_pedido)` | uma avaliação por pedido (cardinalidade 0,1) |
| `fk_avaliacao_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | avaliação de um pedido existente |
| `fk_avaliacao_responsavel` | FOREIGN KEY | `(id_funcionario_responsavel) → funcionario(id_funcionario)` | responsável pelo tratamento |
| `ck_avaliacao_tipo` | CHECK | `(tipo_avaliacao IN ('AVALIACAO', 'RECLAMACAO'))` | RF10 cobre avaliação e reclamação |
| `ck_avaliacao_nota` | CHECK | `(nota BETWEEN 1 AND 5)` | escala de 1 a 5 estrelas (0 não é uma nota) |
| `ck_avaliacao_status` | CHECK | `(status_tratamento IS NULL OR status_tratamento IN ('ABERTA', 'EM_ANALISE', 'RESOLVIDA'))` | ciclo de tratamento |
| `ck_avaliacao_tratamento` | CHECK | `((tipo_avaliacao = 'RECLAMACAO') = (status_tratamento IS NOT NULL))` | só reclamação tem tratamento; avaliação não precisa de ação |
| `ck_avaliacao_responsavel` | CHECK | `(id_funcionario_responsavel IS NULL OR tipo_avaliacao = 'RECLAMACAO')` | responsável existe apenas para reclamação |

## movimentacao_estoque

Livro de movimentações: o saldo do estoque é a soma desta tabela (não há saldo armazenado)

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_movimentacao` | INT (auto) | não |  | PK | Identificador da movimentação de estoque |
| `id_insumo` | INT | não |  | FK→insumo | Insumo movimentado |
| `id_lote` | INT | sim |  | FK→lote | Lote de origem (obrigatório na entrada; opcional nas demais) |
| `id_pedido` | INT | sim |  | FK→pedido | Pedido que originou o consumo (obrigatório quando o tipo é CONSUMO) |
| `id_funcionario` | INT | não |  | FK→funcionario | Funcionário responsável pelo registro |
| `tipo_movimentacao` | VARCHAR(20) | não |  |  | ENTRADA, CONSUMO, PERDA ou AJUSTE_INVENTARIO |
| `quantidade` | DECIMAL(12,3) | não |  |  | Quantidade com sinal na unidade do insumo: positiva entra, negativa sai |
| `data_hora_movimentacao` | DATETIME | não |  |  | Momento da movimentação |
| `motivo` | VARCHAR(120) | sim |  |  | Motivo (obrigatório para perda e ajuste de inventário) |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_movimentacao_estoque` | PRIMARY KEY | `(id_movimentacao)` |  |
| `fk_mov_insumo` | FOREIGN KEY | `(id_insumo) → insumo(id_insumo)` | movimenta um insumo existente |
| `fk_mov_lote` | FOREIGN KEY | `(id_lote) → lote(id_lote)` | rastreia o lote quando conhecido |
| `fk_mov_pedido` | FOREIGN KEY | `(id_pedido) → pedido(id_pedido)` | liga o consumo ao pedido que o gerou |
| `fk_mov_funcionario` | FOREIGN KEY | `(id_funcionario) → funcionario(id_funcionario)` | responsável pela operação |
| `ck_mov_tipo` | CHECK | `(tipo_movimentacao IN ('ENTRADA', 'CONSUMO', 'PERDA', 'AJUSTE_INVENTARIO'))` | RF04: entrada, saída, consumo, perda e inventário |
| `ck_mov_sinal` | CHECK | `((tipo_movimentacao = 'ENTRADA' AND quantidade > 0) OR (tipo_movimentacao IN ('CONSUMO', 'PERDA') AND quantidade < 0) OR (tipo_movimentacao = 'AJUSTE_INVENTARIO' AND quantidade <> 0))` | o sinal da quantidade precisa combinar com o tipo |
| `ck_mov_entrada_lote` | CHECK | `(tipo_movimentacao <> 'ENTRADA' OR id_lote IS NOT NULL)` | toda entrada vem de um lote |
| `ck_mov_consumo_pedido` | CHECK | `(tipo_movimentacao <> 'CONSUMO' OR id_pedido IS NOT NULL)` | consumo é calculado a partir de um pedido |
| `ck_mov_motivo` | CHECK | `(tipo_movimentacao NOT IN ('PERDA', 'AJUSTE_INVENTARIO') OR motivo IS NOT NULL)` | perdas e ajustes precisam de justificativa |

## conta_pagar

Contas a pagar: obrigações com fornecedores e outras despesas

| Coluna | Tipo | Nulo? | Padrão | Papel | Descrição |
|---|---|---|---|---|---|
| `id_conta_pagar` | INT (auto) | não |  | PK | Identificador da obrigação financeira |
| `id_compra` | INT | sim |  | FK→compra | Compra que originou a obrigação; NULL para outras despesas |
| `descricao` | VARCHAR(120) | não |  |  | Descrição da obrigação (ex.: boleto do fornecedor, aluguel) |
| `valor` | DECIMAL(10,2) | não |  |  | Valor a pagar em reais |
| `data_vencimento` | DATE | não |  |  | Data de vencimento |
| `data_pagamento` | DATE | sim |  |  | Data em que foi paga; NULL enquanto aberta |
| `status_conta` | VARCHAR(10) | não | 'ABERTA' |  | ABERTA, PAGA ou CANCELADA |

**Restrições**

| Nome | Tipo | Definição | Por que existe |
|---|---|---|---|
| `pk_conta_pagar` | PRIMARY KEY | `(id_conta_pagar)` |  |
| `fk_conta_pagar_compra` | FOREIGN KEY | `(id_compra) → compra(id_compra)` | liga a obrigação à compra que a gerou |
| `ck_conta_pagar_valor` | CHECK | `(valor > 0)` | valor positivo |
| `ck_conta_pagar_status` | CHECK | `(status_conta IN ('ABERTA', 'PAGA', 'CANCELADA'))` | domínio fechado |
| `ck_conta_pagar_pagamento` | CHECK | `((status_conta = 'PAGA' AND data_pagamento IS NOT NULL) OR (status_conta <> 'PAGA' AND data_pagamento IS NULL))` | data de pagamento só existe quando paga |
