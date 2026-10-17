-- =====================================================================
-- MontArarat ERP - Script 02: tabelas, chaves e restrições
-- Convenções:
--   * Uma coluna por linha: nome TIPO [NOT NULL|NULL] [DEFAULT x] [AUTO_INCREMENT] COMMENT '...'
--   * Toda restrição (UNIQUE/FOREIGN KEY/CHECK) tem uma justificativa no comentário
--     da própria linha ("-- ..."): o dicionário de dados é gerado a partir deste arquivo.
--   * Domínios fechados usam CHECK (... IN (...)) em vez de ENUM, para o mesmo
--     comportamento em MySQL e MariaDB.
--   * Nenhuma FK usa ação referencial (CASCADE/SET NULL): o padrão RESTRICT preserva
--     o histórico e é exigido pelo MySQL quando a coluna também aparece em um CHECK.
-- =====================================================================
SET NAMES utf8mb4;
USE montararat_erp;

-- ---------------------------------------------------------------------
-- BLOCO 1: PESSOAS E EQUIPE
-- ---------------------------------------------------------------------

CREATE TABLE setor (
    id_setor INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do setor da empresa',
    nome VARCHAR(40) NOT NULL COMMENT 'Nome do setor (Atendimento, Cozinha, Financeiro, Gestão, Estoque e Compras)',
    CONSTRAINT pk_setor PRIMARY KEY (id_setor),
    CONSTRAINT uq_setor_nome UNIQUE (nome) -- evita setores duplicados com o mesmo nome
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Setores da hamburgueria (cargo determina o setor)';

CREATE TABLE cargo (
    id_cargo INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do cargo',
    nome VARCHAR(40) NOT NULL COMMENT 'Nome do cargo (Garçom, Chapeiro, Gerente...)',
    id_setor INT NOT NULL COMMENT 'Setor ao qual o cargo pertence',
    pode_comprar TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica se o cargo pode comprar insumos (política: só gerente e proprietário)',
    pode_autorizar TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica se o cargo pode autorizar descontos, trocas, cancelamentos e reembolsos',
    CONSTRAINT pk_cargo PRIMARY KEY (id_cargo),
    CONSTRAINT uq_cargo_nome UNIQUE (nome), -- um cargo não se repete
    CONSTRAINT fk_cargo_setor FOREIGN KEY (id_setor) REFERENCES setor (id_setor), -- cargo -> setor remove a dependência transitiva cargo->setor da tabela funcionario (3FN)
    CONSTRAINT ck_cargo_pode_comprar CHECK (pode_comprar IN (0, 1)), -- domínio booleano
    CONSTRAINT ck_cargo_pode_autorizar CHECK (pode_autorizar IN (0, 1)) -- domínio booleano
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cargos e permissões operacionais que sustentam as políticas da empresa';

CREATE TABLE pessoa (
    id_pessoa INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da pessoa (chave substituta)',
    cpf CHAR(11) NULL COMMENT 'CPF apenas com dígitos; opcional porque cliente de balcão ou de aplicativo pode não informar',
    nome VARCHAR(100) NOT NULL COMMENT 'Nome completo da pessoa',
    telefone VARCHAR(11) NULL COMMENT 'Telefone com DDD, apenas dígitos',
    email VARCHAR(120) NULL COMMENT 'E-mail de contato',
    data_nascimento DATE NULL COMMENT 'Data de nascimento; necessária para a promoção de aniversário',
    CONSTRAINT pk_pessoa PRIMARY KEY (id_pessoa),
    CONSTRAINT uq_pessoa_cpf UNIQUE (cpf), -- um CPF identifica uma única pessoa; NULL pode repetir
    CONSTRAINT ck_pessoa_cpf CHECK (cpf IS NULL OR cpf REGEXP '^[0-9]{11}$'), -- CPF com exatamente 11 dígitos
    CONSTRAINT ck_pessoa_telefone CHECK (telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$'), -- telefone com DDD (10 ou 11 dígitos)
    CONSTRAINT ck_pessoa_email CHECK (email IS NULL OR email LIKE '%_@_%.__%') -- formato mínimo de e-mail
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Qualquer pessoa conhecida pelo sistema: cliente e/ou funcionário';

CREATE TABLE endereco (
    id_endereco INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do endereço',
    id_pessoa INT NOT NULL COMMENT 'Pessoa dona do endereço',
    logradouro VARCHAR(120) NOT NULL COMMENT 'Rua, avenida ou similar',
    numero VARCHAR(10) NOT NULL COMMENT 'Número do imóvel (texto, para aceitar S/N e letras)',
    complemento VARCHAR(60) NULL COMMENT 'Complemento (apto, bloco, referência)',
    bairro VARCHAR(60) NOT NULL COMMENT 'Bairro',
    cidade VARCHAR(60) NOT NULL DEFAULT 'São Paulo' COMMENT 'Cidade',
    uf CHAR(2) NOT NULL DEFAULT 'SP' COMMENT 'Sigla do estado',
    cep CHAR(8) NOT NULL COMMENT 'CEP apenas com dígitos',
    CONSTRAINT pk_endereco PRIMARY KEY (id_endereco),
    CONSTRAINT fk_endereco_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa), -- 1FN: endereço composto e multivalorado saiu de pessoa; uma pessoa pode ter vários endereços
    CONSTRAINT ck_endereco_cep CHECK (cep REGEXP '^[0-9]{8}$') -- CEP com 8 dígitos
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Endereços de pessoas (principalmente para delivery)';

CREATE TABLE funcionario (
    id_funcionario INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do funcionário',
    id_pessoa INT NOT NULL COMMENT 'Pessoa que é o funcionário (nome, CPF e contato ficam em pessoa)',
    id_cargo INT NOT NULL COMMENT 'Cargo exercido',
    salario_bruto DECIMAL(10,2) NOT NULL COMMENT 'Remuneração mensal bruta em reais',
    data_admissao DATE NOT NULL COMMENT 'Data de admissão',
    data_desligamento DATE NULL COMMENT 'Data de desligamento; NULL enquanto o funcionário está ativo',
    CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario),
    CONSTRAINT uq_funcionario_pessoa UNIQUE (id_pessoa), -- uma pessoa é no máximo um funcionário (especialização 1:1)
    CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa), -- 3FN: nome e CPF não se repetem em funcionario
    CONSTRAINT fk_funcionario_cargo FOREIGN KEY (id_cargo) REFERENCES cargo (id_cargo), -- cargo é um domínio cadastrado
    CONSTRAINT ck_funcionario_salario CHECK (salario_bruto > 0), -- remuneração positiva
    CONSTRAINT ck_funcionario_desligamento CHECK (data_desligamento IS NULL OR data_desligamento >= data_admissao) -- não se desliga antes de admitir
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Funcionários (especialização de pessoa)';

-- ---------------------------------------------------------------------
-- BLOCO 2: SALÃO (MESAS E RESERVAS)
-- ---------------------------------------------------------------------

CREATE TABLE mesa (
    id_mesa INT NOT NULL COMMENT 'Número da mesa no salão (definido pela casa, sem auto incremento)',
    capacidade TINYINT NOT NULL COMMENT 'Quantidade máxima de pessoas',
    status_mesa VARCHAR(10) NOT NULL DEFAULT 'LIVRE' COMMENT 'Estado operacional atual: LIVRE, OCUPADA, RESERVADA ou EM_LIMPEZA',
    CONSTRAINT pk_mesa PRIMARY KEY (id_mesa),
    CONSTRAINT ck_mesa_capacidade CHECK (capacidade BETWEEN 1 AND 20), -- capacidade numérica e plausível
    CONSTRAINT ck_mesa_status CHECK (status_mesa IN ('LIVRE', 'OCUPADA', 'RESERVADA', 'EM_LIMPEZA')) -- RDN03: a limpeza só ocorre após o uso, então precisa de um estado próprio
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mesas do salão; a ocupação ao longo do tempo é obtida de pedido e reserva';

CREATE TABLE reserva (
    id_reserva INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da reserva',
    id_mesa INT NOT NULL COMMENT 'Mesa reservada',
    id_pessoa INT NULL COMMENT 'Cliente cadastrado que reservou, quando houver',
    nome_contato VARCHAR(100) NOT NULL COMMENT 'Nome de quem reservou',
    id_funcionario INT NOT NULL COMMENT 'Funcionário que registrou a reserva (RDN02: reserva só presencial)',
    data_hora_inicio DATETIME NOT NULL COMMENT 'Início do período reservado',
    data_hora_fim DATETIME NOT NULL COMMENT 'Fim do período reservado',
    status_reserva VARCHAR(15) NOT NULL DEFAULT 'ATIVA' COMMENT 'ATIVA, CUMPRIDA, CANCELADA ou NAO_COMPARECEU',
    CONSTRAINT pk_reserva PRIMARY KEY (id_reserva),
    CONSTRAINT fk_reserva_mesa FOREIGN KEY (id_mesa) REFERENCES mesa (id_mesa), -- reserva sempre de uma mesa existente
    CONSTRAINT fk_reserva_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa), -- vínculo opcional com cliente cadastrado
    CONSTRAINT fk_reserva_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario), -- rastreia quem registrou
    CONSTRAINT ck_reserva_periodo CHECK (data_hora_fim > data_hora_inicio), -- período válido
    CONSTRAINT ck_reserva_status CHECK (status_reserva IN ('ATIVA', 'CUMPRIDA', 'CANCELADA', 'NAO_COMPARECEU')) -- domínio fechado
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Reservas de mesa feitas presencialmente (RDN02)';

-- ---------------------------------------------------------------------
-- BLOCO 3: CARDÁPIO (PRODUTOS, COMBOS E FICHA TÉCNICA)
-- ---------------------------------------------------------------------

CREATE TABLE categoria_produto (
    id_categoria_produto INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da categoria de produto',
    nome VARCHAR(40) NOT NULL COMMENT 'Nome da categoria (Lanche, Bebida, Porção, Sobremesa)',
    CONSTRAINT pk_categoria_produto PRIMARY KEY (id_categoria_produto),
    CONSTRAINT uq_categoria_produto_nome UNIQUE (nome) -- uma única grafia por categoria
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Domínio fechado de categorias do cardápio';

CREATE TABLE produto (
    id_produto INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do produto vendável',
    nome VARCHAR(80) NOT NULL COMMENT 'Nome do produto no cardápio',
    descricao VARCHAR(255) NULL COMMENT 'Descrição curta e ingredientes para o cliente (RF09)',
    id_categoria_produto INT NOT NULL COMMENT 'Categoria do produto',
    preco_venda DECIMAL(8,2) NOT NULL COMMENT 'Preço de venda atual em reais',
    peso_g INT NULL COMMENT 'Peso do produto em gramas (RF09); NULL quando não se aplica',
    tempo_preparo_min SMALLINT NOT NULL COMMENT 'Tempo padrão de preparo em minutos, base da estimativa ao cliente (RF08)',
    disponivel TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Indica se o produto pode ser vendido agora (RDN04)',
    montagem_especial TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica produto de montagem especial, vedado no delivery (RDN06)',
    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT uq_produto_nome UNIQUE (nome), -- evita duplicidade acidental no cadastro
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria_produto) REFERENCES categoria_produto (id_categoria_produto), -- categoria é domínio fixo
    CONSTRAINT ck_produto_preco CHECK (preco_venda > 0), -- preço positivo
    CONSTRAINT ck_produto_peso CHECK (peso_g IS NULL OR peso_g > 0), -- peso positivo quando informado
    CONSTRAINT ck_produto_tempo CHECK (tempo_preparo_min >= 0), -- tempo não negativo
    CONSTRAINT ck_produto_disponivel CHECK (disponivel IN (0, 1)), -- domínio booleano
    CONSTRAINT ck_produto_montagem CHECK (montagem_especial IN (0, 1)) -- domínio booleano
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Itens do cardápio vendidos individualmente';

CREATE TABLE combo (
    id_combo INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do combo (cadastro)',
    nome VARCHAR(80) NOT NULL COMMENT 'Nome do combo',
    descricao VARCHAR(255) NULL COMMENT 'Descrição do combo',
    preco_venda DECIMAL(8,2) NOT NULL COMMENT 'Preço de venda atual do combo em reais',
    ativo TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Indica se o combo está à venda',
    CONSTRAINT pk_combo PRIMARY KEY (id_combo),
    CONSTRAINT uq_combo_nome UNIQUE (nome), -- sem combos duplicados
    CONSTRAINT ck_combo_preco CHECK (preco_venda > 0), -- preço positivo
    CONSTRAINT ck_combo_ativo CHECK (ativo IN (0, 1)) -- domínio booleano
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cadastro de combos: uma entidade para todas as combinações (decisão da 1ª entrega)';

CREATE TABLE item_combo (
    id_combo INT NOT NULL COMMENT 'Combo ao qual o item pertence',
    id_produto INT NOT NULL COMMENT 'Produto que compõe o combo',
    quantidade SMALLINT NOT NULL COMMENT 'Quantidade do produto dentro do combo',
    CONSTRAINT pk_item_combo PRIMARY KEY (id_combo, id_produto), -- um produto aparece uma vez por combo; a quantidade é atributo da associação
    CONSTRAINT fk_item_combo_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo), -- item sempre de um combo existente
    CONSTRAINT fk_item_combo_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto), -- item sempre de um produto existente
    CONSTRAINT ck_item_combo_quantidade CHECK (quantidade > 0) -- devolutiva: validar a quantidade dos produtos do combo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Composição do combo (associativa N:N combo x produto)';

CREATE TABLE favorito (
    id_pessoa INT NOT NULL COMMENT 'Cliente que salvou o produto',
    id_produto INT NOT NULL COMMENT 'Produto salvo como favorito',
    data_hora_salvo DATETIME NOT NULL COMMENT 'Momento em que o cliente salvou (define a ordem da lista: do mais recente ao mais antigo)',
    CONSTRAINT pk_favorito PRIMARY KEY (id_pessoa, id_produto), -- um produto só entra uma vez na lista de cada cliente
    CONSTRAINT fk_favorito_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa), -- favorito de uma pessoa cadastrada
    CONSTRAINT fk_favorito_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto) -- favorito é um produto do cardápio
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Produtos favoritos do cliente (RF18, antigo RNF02: era funcionalidade, não requisito não funcional)';

-- ---------------------------------------------------------------------
-- BLOCO 4: INSUMOS, FORNECEDORES, COMPRAS E ESTOQUE
-- ---------------------------------------------------------------------

CREATE TABLE categoria_insumo (
    id_categoria_insumo INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da categoria de insumo',
    nome VARCHAR(40) NOT NULL COMMENT 'Nome da categoria (Pães, Carnes, Queijos, Bebidas, Embalagens...)',
    CONSTRAINT pk_categoria_insumo PRIMARY KEY (id_categoria_insumo),
    CONSTRAINT uq_categoria_insumo_nome UNIQUE (nome) -- resolve categorias genéricas ou fragmentadas da lista de compras
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Categorias de insumo padronizadas (problema: nomenclaturas confusas)';

CREATE TABLE insumo (
    id_insumo INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do insumo',
    nome VARCHAR(80) NOT NULL COMMENT 'Nome do insumo (ex.: Queijo cheddar fatiado)',
    marca VARCHAR(60) NOT NULL DEFAULT 'SEM MARCA' COMMENT 'Marca do insumo, como na lista de compras',
    id_categoria_insumo INT NOT NULL COMMENT 'Categoria do insumo',
    unidade_medida VARCHAR(2) NOT NULL COMMENT 'Unidade base de estoque e de consumo: G, ML ou UN',
    unidade_compra VARCHAR(20) NOT NULL COMMENT 'Unidade em que o item é pedido ao fornecedor, como na lista de compras (fardo, caixa, pacote, balde...)',
    fator_conversao DECIMAL(12,3) NOT NULL COMMENT 'Quantos da unidade de medida base há em uma unidade de compra (ex.: 1 fardo = 12 UN)',
    estoque_minimo DECIMAL(12,3) NOT NULL DEFAULT 0 COMMENT 'Saldo mínimo, na unidade de medida, que dispara a reposição',
    CONSTRAINT pk_insumo PRIMARY KEY (id_insumo),
    CONSTRAINT uq_insumo_nome_marca UNIQUE (nome, marca), -- impede cadastro duplicado do mesmo item e marca
    CONSTRAINT fk_insumo_categoria FOREIGN KEY (id_categoria_insumo) REFERENCES categoria_insumo (id_categoria_insumo), -- categoria padronizada
    CONSTRAINT ck_insumo_unidade CHECK (unidade_medida IN ('G', 'ML', 'UN')), -- unidades de consumo suportadas; compras em kg, L ou caixa são convertidas para a unidade base
    CONSTRAINT ck_insumo_minimo CHECK (estoque_minimo >= 0), -- mínimo não negativo
    CONSTRAINT ck_insumo_fator CHECK (fator_conversao > 0) -- conversão positiva
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Insumos (matéria-prima) controlados em estoque; a validade fica no lote';

CREATE TABLE ficha_tecnica (
    id_produto INT NOT NULL COMMENT 'Produto que consome o insumo',
    id_insumo INT NOT NULL COMMENT 'Insumo consumido',
    quantidade DECIMAL(10,3) NOT NULL COMMENT 'Quantidade do insumo, na unidade de medida do insumo, por unidade do produto',
    CONSTRAINT pk_ficha_tecnica PRIMARY KEY (id_produto, id_insumo), -- um insumo aparece uma vez na receita de cada produto
    CONSTRAINT fk_ficha_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto), -- receita de um produto existente
    CONSTRAINT fk_ficha_insumo FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo), -- insumo existente
    CONSTRAINT ck_ficha_quantidade CHECK (quantidade > 0) -- consumo positivo; base do cálculo de baixa de estoque
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Receita do produto (associativa N:N produto x insumo); inclui a embalagem como insumo (RDN07)';

CREATE TABLE fornecedor (
    id_fornecedor INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do fornecedor',
    cnpj CHAR(14) NOT NULL COMMENT 'CNPJ apenas com dígitos',
    razao_social VARCHAR(120) NOT NULL COMMENT 'Razão social ou nome do fornecedor',
    telefone VARCHAR(11) NULL COMMENT 'Telefone com DDD, apenas dígitos',
    email VARCHAR(120) NULL COMMENT 'E-mail de contato',
    CONSTRAINT pk_fornecedor PRIMARY KEY (id_fornecedor),
    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj), -- um CNPJ por fornecedor
    CONSTRAINT ck_fornecedor_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$'), -- CNPJ com 14 dígitos
    CONSTRAINT ck_fornecedor_telefone CHECK (telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$') -- telefone com DDD
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Fornecedores de insumos';

CREATE TABLE fornecedor_insumo (
    id_fornecedor INT NOT NULL COMMENT 'Fornecedor que oferece o insumo',
    id_insumo INT NOT NULL COMMENT 'Insumo oferecido',
    prazo_entrega_dias SMALLINT NULL COMMENT 'Prazo habitual de entrega em dias',
    CONSTRAINT pk_fornecedor_insumo PRIMARY KEY (id_fornecedor, id_insumo), -- o par fornecedor x insumo é único
    CONSTRAINT fk_forn_insumo_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor), -- fornecedor existente
    CONSTRAINT fk_forn_insumo_insumo FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo), -- insumo existente
    CONSTRAINT ck_forn_insumo_prazo CHECK (prazo_entrega_dias IS NULL OR prazo_entrega_dias >= 0) -- prazo não negativo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Quais insumos cada fornecedor atende (associativa N:N fornecedor x insumo)';

CREATE TABLE compra (
    id_compra INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do pedido de compra',
    id_fornecedor INT NOT NULL COMMENT 'Fornecedor contratado',
    id_funcionario INT NOT NULL COMMENT 'Funcionário que realizou a compra (política: gerente ou proprietário)',
    data_hora_compra DATETIME NOT NULL COMMENT 'Momento em que a compra foi feita',
    status_compra VARCHAR(16) NOT NULL DEFAULT 'PEDIDA' COMMENT 'PEDIDA, RECEBIDA_PARCIAL, RECEBIDA ou CANCELADA',
    observacao VARCHAR(255) NULL COMMENT 'Observações da compra',
    CONSTRAINT pk_compra PRIMARY KEY (id_compra),
    CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor), -- compra sempre de um fornecedor
    CONSTRAINT fk_compra_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario), -- rastreia o comprador; a permissão é validada no trigger trg_compra_bi
    CONSTRAINT ck_compra_status CHECK (status_compra IN ('PEDIDA', 'RECEBIDA_PARCIAL', 'RECEBIDA', 'CANCELADA')) -- compra, recebimento e conferência são etapas distintas
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cabeçalho da compra de insumos (substitui o antigo Fornecimento)';

CREATE TABLE item_compra (
    id_compra INT NOT NULL COMMENT 'Compra à qual o item pertence',
    id_insumo INT NOT NULL COMMENT 'Insumo comprado',
    quantidade DECIMAL(12,3) NOT NULL COMMENT 'Quantidade comprada, convertida para a unidade de medida do insumo',
    valor_total DECIMAL(10,2) NOT NULL COMMENT 'Valor total pago pelo item em reais (o preço unitário é derivado)',
    CONSTRAINT pk_item_compra PRIMARY KEY (id_compra, id_insumo), -- 2FN: data da compra e fornecedor dependem só de id_compra e ficam no cabeçalho
    CONSTRAINT fk_item_compra_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra), -- item de uma compra existente
    CONSTRAINT fk_item_compra_insumo FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo), -- insumo existente
    CONSTRAINT ck_item_compra_quantidade CHECK (quantidade > 0), -- quantidade positiva
    CONSTRAINT ck_item_compra_valor CHECK (valor_total >= 0) -- valor não negativo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Itens de cada compra (associativa N:N compra x insumo)';

CREATE TABLE recebimento (
    id_recebimento INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do recebimento (conferência de entrega)',
    id_compra INT NOT NULL COMMENT 'Compra que está sendo recebida',
    id_funcionario INT NOT NULL COMMENT 'Funcionário que conferiu a entrega',
    data_hora_recebimento DATETIME NOT NULL COMMENT 'Momento da conferência',
    numero_nota_fiscal VARCHAR(20) NULL COMMENT 'Número da nota fiscal do fornecedor',
    observacao VARCHAR(255) NULL COMMENT 'Divergências ou observações da conferência',
    CONSTRAINT pk_recebimento PRIMARY KEY (id_recebimento),
    CONSTRAINT fk_recebimento_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra), -- toda entrega pertence a uma compra; uma compra pode ter vários recebimentos
    CONSTRAINT fk_recebimento_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario) -- registra quem conferiu
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Recebimento e conferência de mercadorias';

CREATE TABLE lote (
    id_lote INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do lote recebido',
    id_recebimento INT NOT NULL COMMENT 'Recebimento em que o lote chegou',
    id_insumo INT NOT NULL COMMENT 'Insumo do lote',
    codigo_lote VARCHAR(30) NULL COMMENT 'Código do lote impresso pelo fornecedor',
    quantidade_recebida DECIMAL(12,3) NOT NULL COMMENT 'Quantidade que chegou, na unidade de medida do insumo',
    data_validade DATE NULL COMMENT 'Validade do lote; NULL para itens sem validade controlada',
    CONSTRAINT pk_lote PRIMARY KEY (id_lote),
    CONSTRAINT fk_lote_recebimento FOREIGN KEY (id_recebimento) REFERENCES recebimento (id_recebimento), -- lote nasce de um recebimento
    CONSTRAINT fk_lote_insumo FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo), -- validade pertence ao lote e não ao insumo (normalização)
    CONSTRAINT ck_lote_quantidade CHECK (quantidade_recebida > 0) -- quantidade positiva
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Lotes recebidos, com validade própria';

-- ---------------------------------------------------------------------
-- BLOCO 5: VENDAS (PEDIDOS, ITENS, PROMOÇÕES, ENTREGA)
-- ---------------------------------------------------------------------

CREATE TABLE promocao (
    id_promocao INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da promoção',
    nome VARCHAR(60) NOT NULL COMMENT 'Nome da promoção',
    tipo_promocao VARCHAR(12) NOT NULL COMMENT 'ANIVERSARIO ou CUPOM',
    percentual_desconto DECIMAL(5,2) NOT NULL COMMENT 'Percentual de desconto aplicado ao pedido',
    exige_documento TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica se exige conferência de documento pessoal (promoção de aniversário)',
    ativa TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Indica se a promoção está vigente',
    CONSTRAINT pk_promocao PRIMARY KEY (id_promocao),
    CONSTRAINT uq_promocao_nome UNIQUE (nome), -- sem promoções duplicadas
    CONSTRAINT ck_promocao_tipo CHECK (tipo_promocao IN ('ANIVERSARIO', 'CUPOM')), -- domínio fechado
    CONSTRAINT ck_promocao_percentual CHECK (percentual_desconto > 0 AND percentual_desconto <= 100), -- percentual válido
    CONSTRAINT ck_promocao_exige_doc CHECK (exige_documento IN (0, 1)), -- domínio booleano
    CONSTRAINT ck_promocao_ativa CHECK (ativa IN (0, 1)) -- domínio booleano
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Promoções aplicáveis a pedidos (política de aniversário)';

CREATE TABLE forma_pagamento (
    id_forma_pagamento INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da forma de pagamento',
    nome VARCHAR(30) NOT NULL COMMENT 'PIX, Cartão de débito, Cartão de crédito, Dinheiro, Online iFood, Online 99food',
    taxa_percentual DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT 'Taxa percentual cobrada pela operadora ou plataforma sobre o valor recebido',
    grupo_fechamento VARCHAR(8) NOT NULL COMMENT 'Linha da fita de fechamento em que a forma é somada: DINHEIRO, CARTAO ou OUTRAS',
    CONSTRAINT pk_forma_pagamento PRIMARY KEY (id_forma_pagamento),
    CONSTRAINT uq_forma_pagamento_nome UNIQUE (nome), -- forma de pagamento com grafia única (substitui o texto livre)
    CONSTRAINT ck_forma_pagamento_taxa CHECK (taxa_percentual BETWEEN 0 AND 100), -- percentual válido
    CONSTRAINT ck_forma_pagamento_grupo CHECK (grupo_fechamento IN ('DINHEIRO', 'CARTAO', 'OUTRAS')) -- as três linhas de recebimento da fita de fechamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Domínio das formas de pagamento e custo de recebimento';

CREATE TABLE caixa (
    id_caixa INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da sessão de caixa (turno)',
    terminal VARCHAR(30) NOT NULL COMMENT 'Nome do terminal/PDV que operou o turno (na fita: "Mont Ararat Delivery", que também registra vendas de mesa e balcão)',
    id_funcionario_abertura INT NOT NULL COMMENT 'Funcionário que abriu o caixa',
    id_funcionario_fechamento INT NULL COMMENT 'Funcionário que fechou o caixa',
    data_hora_abertura DATETIME NOT NULL COMMENT 'Momento da abertura',
    data_hora_fechamento DATETIME NULL COMMENT 'Momento do fechamento; NULL enquanto aberto',
    valor_abertura DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT 'Fundo de troco informado na abertura',
    valor_fechamento DECIMAL(10,2) NULL COMMENT 'Valor de fechamento informado pelo operador (fita: "VALOR DE FECHAMENTO"); esperado = abertura + soma de recebimentos',
    CONSTRAINT pk_caixa PRIMARY KEY (id_caixa),
    CONSTRAINT fk_caixa_abertura FOREIGN KEY (id_funcionario_abertura) REFERENCES funcionario (id_funcionario), -- quem abriu
    CONSTRAINT fk_caixa_fechamento FOREIGN KEY (id_funcionario_fechamento) REFERENCES funcionario (id_funcionario), -- quem fechou
    CONSTRAINT ck_caixa_terminal CHECK (LENGTH(TRIM(terminal)) > 0), -- terminal identificado (o relatório de fechamento traz o nome do terminal)
    CONSTRAINT ck_caixa_valor_abertura CHECK (valor_abertura >= 0), -- fundo não negativo
    CONSTRAINT ck_caixa_fechamento CHECK ((data_hora_fechamento IS NULL AND id_funcionario_fechamento IS NULL AND valor_fechamento IS NULL) OR (data_hora_fechamento IS NOT NULL AND id_funcionario_fechamento IS NOT NULL AND valor_fechamento IS NOT NULL AND data_hora_fechamento >= data_hora_abertura)) -- fechamento é tudo ou nada e não precede a abertura
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Turnos de caixa por terminal (fechamento de turno, como na fita de fechamento)';

CREATE TABLE entregador (
    id_entregador INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do entregador (motoboy)',
    nome VARCHAR(100) NOT NULL COMMENT 'Nome do entregador',
    telefone VARCHAR(11) NULL COMMENT 'Telefone com DDD, apenas dígitos',
    vinculo VARCHAR(10) NOT NULL COMMENT 'PROPRIO (da casa) ou PLATAFORMA (iFood/99food)',
    CONSTRAINT pk_entregador PRIMARY KEY (id_entregador),
    CONSTRAINT ck_entregador_vinculo CHECK (vinculo IN ('PROPRIO', 'PLATAFORMA')), -- domínio fechado
    CONSTRAINT ck_entregador_telefone CHECK (telefone IS NULL OR telefone REGEXP '^[0-9]{10,11}$') -- telefone com DDD
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Entregadores (o texto do projeto cita o motoboy, que não estava modelado)';

CREATE TABLE pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do pedido',
    id_pessoa INT NULL COMMENT 'Cliente que fez o pedido; NULL para cliente não identificado',
    id_funcionario INT NOT NULL COMMENT 'Funcionário que lançou o pedido (atendente ou garçom)',
    id_mesa INT NULL COMMENT 'Mesa do pedido presencial; NULL quando não há mesa',
    id_promocao INT NULL COMMENT 'Promoção aplicada, quando houver',
    id_funcionario_autorizador INT NULL COMMENT 'Funcionário que autorizou o desconto (obrigatório quando há desconto)',
    canal VARCHAR(10) NOT NULL COMMENT 'Origem do pedido: SALAO, BALCAO, IFOOD ou 99FOOD',
    modalidade VARCHAR(10) NOT NULL COMMENT 'LOCAL (consumo no estabelecimento), RETIRADA ou DELIVERY; define a prioridade na fila',
    status_pedido VARCHAR(12) NOT NULL DEFAULT 'ABERTO' COMMENT 'ABERTO, EM_PRODUCAO, PRONTO, ENTREGUE, CONCLUIDO (entregue e pago) ou CANCELADO',
    data_hora_pedido DATETIME NOT NULL COMMENT 'Momento em que o pedido foi lançado',
    data_hora_inicio_preparo DATETIME NULL COMMENT 'Momento em que a cozinha iniciou o preparo',
    data_hora_pronto DATETIME NULL COMMENT 'Momento em que o pedido ficou pronto',
    data_hora_encerramento DATETIME NULL COMMENT 'Momento em que o pedido foi concluído ou cancelado',
    valor_desconto DECIMAL(8,2) NOT NULL DEFAULT 0 COMMENT 'Desconto total em reais concedido ao pedido',
    valor_servico DECIMAL(8,2) NOT NULL DEFAULT 0 COMMENT 'Taxa de serviço de mesa cobrada em reais (aparece como "Serviço de mesa" na fita de fechamento); 0 fora do salão',
    documento_conferido TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica que o documento pessoal foi conferido (promoção de aniversário)',
    CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa), -- cliente opcional: venda de balcão pode ser anônima
    CONSTRAINT fk_pedido_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario), -- RF01: quem atendeu
    CONSTRAINT fk_pedido_mesa FOREIGN KEY (id_mesa) REFERENCES mesa (id_mesa), -- RF07: liga a mesa ao consumo
    CONSTRAINT fk_pedido_promocao FOREIGN KEY (id_promocao) REFERENCES promocao (id_promocao), -- promoção cadastrada
    CONSTRAINT fk_pedido_autorizador FOREIGN KEY (id_funcionario_autorizador) REFERENCES funcionario (id_funcionario), -- política: descontos são autorizados pelo gerente
    CONSTRAINT ck_pedido_canal CHECK (canal IN ('SALAO', 'BALCAO', 'IFOOD', '99FOOD')), -- domínio fechado dos canais
    CONSTRAINT ck_pedido_modalidade CHECK (modalidade IN ('LOCAL', 'RETIRADA', 'DELIVERY')), -- RF11 e RDN09 (prioridade da fila)
    CONSTRAINT ck_pedido_status CHECK (status_pedido IN ('ABERTO', 'EM_PRODUCAO', 'PRONTO', 'ENTREGUE', 'CONCLUIDO', 'CANCELADO')), -- devolutiva: distinguir entregue, cancelado e concluído
    CONSTRAINT ck_pedido_canal_modalidade CHECK ((canal <> 'SALAO' OR modalidade = 'LOCAL') AND (canal NOT IN ('IFOOD', '99FOOD') OR modalidade <> 'LOCAL')), -- pedido de salão é local; pedido de aplicativo nunca é consumido no local
    CONSTRAINT ck_pedido_mesa_local CHECK (id_mesa IS NULL OR modalidade = 'LOCAL'), -- mesa só existe em consumo no local
    CONSTRAINT ck_pedido_desconto CHECK (valor_desconto >= 0), -- desconto não negativo
    CONSTRAINT ck_pedido_servico CHECK (valor_servico >= 0 AND (valor_servico = 0 OR id_mesa IS NOT NULL)), -- taxa de serviço só existe em atendimento de mesa
    CONSTRAINT ck_pedido_desconto_autorizado CHECK (valor_desconto = 0 OR id_funcionario_autorizador IS NOT NULL), -- política: desconto exige autorização
    CONSTRAINT ck_pedido_documento CHECK (documento_conferido IN (0, 1)), -- domínio booleano
    CONSTRAINT ck_pedido_ordem_inicio CHECK (data_hora_inicio_preparo IS NULL OR data_hora_inicio_preparo >= data_hora_pedido), -- o preparo não começa antes do pedido
    CONSTRAINT ck_pedido_ordem_pronto CHECK (data_hora_pronto IS NULL OR (data_hora_inicio_preparo IS NOT NULL AND data_hora_pronto >= data_hora_inicio_preparo)), -- pronto exige início e vem depois
    CONSTRAINT ck_pedido_ordem_encerra CHECK (data_hora_encerramento IS NULL OR data_hora_encerramento >= data_hora_pedido), -- encerramento não precede o pedido
    CONSTRAINT ck_pedido_encerramento CHECK ((status_pedido IN ('CONCLUIDO', 'CANCELADO')) = (data_hora_encerramento IS NOT NULL)), -- só pedidos concluídos ou cancelados têm encerramento
    CONSTRAINT ck_pedido_marcos CHECK (status_pedido NOT IN ('PRONTO', 'ENTREGUE', 'CONCLUIDO') OR data_hora_pronto IS NOT NULL) -- estados avançados exigem o marco "pronto"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pedidos de clientes; totais e situação de pagamento são derivados por view';

CREATE TABLE item_pedido (
    id_pedido INT NOT NULL COMMENT 'Pedido ao qual o item pertence',
    numero_item SMALLINT NOT NULL COMMENT 'Sequência da linha dentro do pedido (permite o mesmo produto com observações diferentes)',
    id_produto INT NOT NULL COMMENT 'Produto vendido',
    quantidade SMALLINT NOT NULL COMMENT 'Quantidade vendida',
    preco_unitario DECIMAL(8,2) NOT NULL COMMENT 'Preço unitário praticado na venda (cópia do preço vigente no momento; RDN14: o preço histórico não muda com reajustes)',
    observacao VARCHAR(200) NULL COMMENT 'Observação do cliente sobre o item (ex.: sem cebola)',
    cancelado TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Indica item cancelado antes do preparo: continua registrado, mas não entra no total nem no consumo (fita: "Cancelamentos mesa")',
    CONSTRAINT pk_item_pedido PRIMARY KEY (id_pedido, numero_item), -- chave composta: o mesmo produto pode aparecer em linhas distintas
    CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- item de um pedido existente
    CONSTRAINT fk_item_pedido_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto), -- produto existente
    CONSTRAINT ck_item_pedido_quantidade CHECK (quantidade > 0), -- RF03: quantidade positiva
    CONSTRAINT ck_item_pedido_preco CHECK (preco_unitario > 0), -- preço positivo
    CONSTRAINT ck_item_pedido_cancelado CHECK (cancelado IN (0, 1)) -- domínio booleano
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Itens avulsos do pedido (associativa N:N pedido x produto); o subtotal é calculado';

CREATE TABLE item_combo_pedido (
    id_pedido INT NOT NULL COMMENT 'Pedido ao qual o combo pertence',
    numero_item SMALLINT NOT NULL COMMENT 'Sequência da linha de combo dentro do pedido',
    id_combo INT NOT NULL COMMENT 'Combo vendido (cadastro distinto da inclusão no pedido)',
    quantidade SMALLINT NOT NULL COMMENT 'Quantidade de combos vendidos',
    preco_unitario DECIMAL(8,2) NOT NULL COMMENT 'Preço do combo praticado na venda (RDN14)',
    observacao VARCHAR(200) NULL COMMENT 'Observação do cliente sobre o combo',
    CONSTRAINT pk_item_combo_pedido PRIMARY KEY (id_pedido, numero_item), -- chave composta própria dos combos no pedido
    CONSTRAINT fk_item_combo_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- pedido existente
    CONSTRAINT fk_item_combo_pedido_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo), -- referencia o combo (e não um produto), distinguindo cadastro e inclusão
    CONSTRAINT ck_item_combo_pedido_quantidade CHECK (quantidade > 0), -- quantidade positiva
    CONSTRAINT ck_item_combo_pedido_preco CHECK (preco_unitario > 0) -- preço positivo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Combos incluídos no pedido (associativa N:N pedido x combo)';

CREATE TABLE pagamento (
    id_pagamento INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador do pagamento',
    id_pedido INT NOT NULL COMMENT 'Pedido pago (um pedido pode ter vários pagamentos)',
    id_forma_pagamento INT NOT NULL COMMENT 'Forma de pagamento utilizada',
    id_caixa INT NOT NULL COMMENT 'Sessão de caixa em que o pagamento foi registrado',
    valor DECIMAL(8,2) NOT NULL COMMENT 'Valor pago em reais',
    data_hora_pagamento DATETIME NOT NULL COMMENT 'Momento do pagamento',
    status_pagamento VARCHAR(10) NOT NULL DEFAULT 'CONFIRMADO' COMMENT 'PENDENTE, CONFIRMADO, ESTORNADO ou RECUSADO',
    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- corrige a 1ª entrega: o pagamento não estava ligado ao pedido
    CONSTRAINT fk_pagamento_forma FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento (id_forma_pagamento), -- RF02: forma de pagamento cadastrada
    CONSTRAINT fk_pagamento_caixa FOREIGN KEY (id_caixa) REFERENCES caixa (id_caixa), -- movimento de caixa rastreável
    CONSTRAINT ck_pagamento_valor CHECK (valor > 0), -- estorno é um status e não um valor negativo
    CONSTRAINT ck_pagamento_status CHECK (status_pagamento IN ('PENDENTE', 'CONFIRMADO', 'ESTORNADO', 'RECUSADO')) -- etapas do pagamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pagamentos recebidos (permite pagamento dividido e pagamento online)';

CREATE TABLE ocorrencia (
    id_ocorrencia INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da ocorrência',
    id_pedido INT NOT NULL COMMENT 'Pedido afetado',
    id_funcionario_autorizador INT NOT NULL COMMENT 'Funcionário que autorizou (política: gerente)',
    tipo_ocorrencia VARCHAR(12) NOT NULL COMMENT 'TROCA, CANCELAMENTO ou REEMBOLSO',
    causa VARCHAR(15) NOT NULL COMMENT 'ERRO_DA_CASA, INSATISFACAO, DESISTENCIA ou OUTRO',
    houve_consumo TINYINT(1) NOT NULL COMMENT 'Indica se o produto já havia sido consumido',
    valor_reembolso DECIMAL(8,2) NULL COMMENT 'Valor devolvido; preenchido somente no reembolso',
    descricao VARCHAR(255) NULL COMMENT 'Detalhes da ocorrência',
    data_hora_ocorrencia DATETIME NOT NULL COMMENT 'Momento da ocorrência',
    CONSTRAINT pk_ocorrencia PRIMARY KEY (id_ocorrencia),
    CONSTRAINT fk_ocorrencia_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- ocorrência sempre de um pedido
    CONSTRAINT fk_ocorrencia_autorizador FOREIGN KEY (id_funcionario_autorizador) REFERENCES funcionario (id_funcionario), -- autorização rastreável
    CONSTRAINT ck_ocorrencia_tipo CHECK (tipo_ocorrencia IN ('TROCA', 'CANCELAMENTO', 'REEMBOLSO')), -- domínio fechado
    CONSTRAINT ck_ocorrencia_causa CHECK (causa IN ('ERRO_DA_CASA', 'INSATISFACAO', 'DESISTENCIA', 'OUTRO')), -- domínio fechado
    CONSTRAINT ck_ocorrencia_consumo CHECK (houve_consumo IN (0, 1)), -- domínio booleano
    CONSTRAINT ck_ocorrencia_politica CHECK ((tipo_ocorrencia = 'TROCA' AND (houve_consumo = 0 OR causa = 'ERRO_DA_CASA')) OR (tipo_ocorrencia IN ('CANCELAMENTO', 'REEMBOLSO') AND houve_consumo = 0)), -- política resolvida (RDN05): cancelamento e reembolso só sem consumo; troca após consumo só por erro da casa
    CONSTRAINT ck_ocorrencia_reembolso CHECK ((tipo_ocorrencia = 'REEMBOLSO' AND valor_reembolso IS NOT NULL AND valor_reembolso > 0) OR (tipo_ocorrencia <> 'REEMBOLSO' AND valor_reembolso IS NULL)) -- valor só existe no reembolso
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='RF16: trocas, cancelamentos e reembolsos (resolve a contradição entre RDN05 e a política de cancelamento)';

CREATE TABLE entrega (
    id_entrega INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da entrega',
    id_pedido INT NOT NULL COMMENT 'Pedido entregue (somente modalidade DELIVERY)',
    id_endereco INT NOT NULL COMMENT 'Endereço de destino',
    id_entregador INT NULL COMMENT 'Entregador responsável; NULL até ser designado',
    taxa_entrega DECIMAL(6,2) NOT NULL DEFAULT 0 COMMENT 'Taxa de entrega cobrada em reais',
    status_entrega VARCHAR(12) NOT NULL DEFAULT 'AGUARDANDO' COMMENT 'AGUARDANDO, EM_ROTA, ENTREGUE ou NAO_ENTREGUE',
    data_hora_saida DATETIME NULL COMMENT 'Momento em que o entregador saiu',
    data_hora_entrega DATETIME NULL COMMENT 'Momento em que o pedido chegou ao cliente',
    CONSTRAINT pk_entrega PRIMARY KEY (id_entrega),
    CONSTRAINT uq_entrega_pedido UNIQUE (id_pedido), -- um pedido tem no máximo uma entrega
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- entrega de um pedido existente
    CONSTRAINT fk_entrega_endereco FOREIGN KEY (id_endereco) REFERENCES endereco (id_endereco), -- o endereço fica em endereco, sem duplicação de texto
    CONSTRAINT fk_entrega_entregador FOREIGN KEY (id_entregador) REFERENCES entregador (id_entregador), -- motoboy cadastrado
    CONSTRAINT ck_entrega_status CHECK (status_entrega IN ('AGUARDANDO', 'EM_ROTA', 'ENTREGUE', 'NAO_ENTREGUE')), -- etapas da entrega
    CONSTRAINT ck_entrega_taxa CHECK (taxa_entrega >= 0), -- taxa não negativa
    CONSTRAINT ck_entrega_saida CHECK (status_entrega NOT IN ('EM_ROTA', 'ENTREGUE') OR (id_entregador IS NOT NULL AND data_hora_saida IS NOT NULL)), -- em rota exige entregador e saída
    CONSTRAINT ck_entrega_chegada CHECK ((status_entrega = 'ENTREGUE') = (data_hora_entrega IS NOT NULL)), -- chegada só existe quando entregue
    CONSTRAINT ck_entrega_ordem CHECK (data_hora_entrega IS NULL OR (data_hora_saida IS NOT NULL AND data_hora_entrega >= data_hora_saida)) -- chegada depois da saída
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Entrega de pedidos delivery (RF11); a retirada pelo entregador na porta é procedimento (RDN08) e só a saída é registrada';

CREATE TABLE avaliacao (
    id_avaliacao INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da avaliação ou reclamação',
    id_pedido INT NOT NULL COMMENT 'Pedido avaliado',
    tipo_avaliacao VARCHAR(10) NOT NULL COMMENT 'AVALIACAO ou RECLAMACAO (RF10)',
    nota TINYINT NOT NULL COMMENT 'Nota de 1 a 5 estrelas',
    comentario VARCHAR(500) NULL COMMENT 'Texto livre do cliente',
    data_hora_avaliacao DATETIME NOT NULL COMMENT 'Momento do registro',
    status_tratamento VARCHAR(10) NULL COMMENT 'Ciclo de tratamento da reclamação: ABERTA, EM_ANALISE ou RESOLVIDA; NULL para avaliações',
    id_funcionario_responsavel INT NULL COMMENT 'Funcionário que trata a reclamação',
    CONSTRAINT pk_avaliacao PRIMARY KEY (id_avaliacao),
    CONSTRAINT uq_avaliacao_pedido UNIQUE (id_pedido), -- uma avaliação por pedido (cardinalidade 0,1)
    CONSTRAINT fk_avaliacao_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- avaliação de um pedido existente
    CONSTRAINT fk_avaliacao_responsavel FOREIGN KEY (id_funcionario_responsavel) REFERENCES funcionario (id_funcionario), -- responsável pelo tratamento
    CONSTRAINT ck_avaliacao_tipo CHECK (tipo_avaliacao IN ('AVALIACAO', 'RECLAMACAO')), -- RF10 cobre avaliação e reclamação
    CONSTRAINT ck_avaliacao_nota CHECK (nota BETWEEN 1 AND 5), -- escala de 1 a 5 estrelas (0 não é uma nota)
    CONSTRAINT ck_avaliacao_status CHECK (status_tratamento IS NULL OR status_tratamento IN ('ABERTA', 'EM_ANALISE', 'RESOLVIDA')), -- ciclo de tratamento
    CONSTRAINT ck_avaliacao_tratamento CHECK ((tipo_avaliacao = 'RECLAMACAO') = (status_tratamento IS NOT NULL)), -- só reclamação tem tratamento; avaliação não precisa de ação
    CONSTRAINT ck_avaliacao_responsavel CHECK (id_funcionario_responsavel IS NULL OR tipo_avaliacao = 'RECLAMACAO') -- responsável existe apenas para reclamação
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Avaliações e reclamações dos clientes';

-- ---------------------------------------------------------------------
-- BLOCO 5B: MOVIMENTAÇÃO DE ESTOQUE (depende de lote e pedido)
-- ---------------------------------------------------------------------

CREATE TABLE movimentacao_estoque (
    id_movimentacao INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da movimentação de estoque',
    id_insumo INT NOT NULL COMMENT 'Insumo movimentado',
    id_lote INT NULL COMMENT 'Lote de origem (obrigatório na entrada; opcional nas demais)',
    id_pedido INT NULL COMMENT 'Pedido que originou o consumo (obrigatório quando o tipo é CONSUMO)',
    id_funcionario INT NOT NULL COMMENT 'Funcionário responsável pelo registro',
    tipo_movimentacao VARCHAR(20) NOT NULL COMMENT 'ENTRADA, CONSUMO, PERDA ou AJUSTE_INVENTARIO',
    quantidade DECIMAL(12,3) NOT NULL COMMENT 'Quantidade com sinal na unidade do insumo: positiva entra, negativa sai',
    data_hora_movimentacao DATETIME NOT NULL COMMENT 'Momento da movimentação',
    motivo VARCHAR(120) NULL COMMENT 'Motivo (obrigatório para perda e ajuste de inventário)',
    CONSTRAINT pk_movimentacao_estoque PRIMARY KEY (id_movimentacao),
    CONSTRAINT fk_mov_insumo FOREIGN KEY (id_insumo) REFERENCES insumo (id_insumo), -- movimenta um insumo existente
    CONSTRAINT fk_mov_lote FOREIGN KEY (id_lote) REFERENCES lote (id_lote), -- rastreia o lote quando conhecido
    CONSTRAINT fk_mov_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido), -- liga o consumo ao pedido que o gerou
    CONSTRAINT fk_mov_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario), -- responsável pela operação
    CONSTRAINT ck_mov_tipo CHECK (tipo_movimentacao IN ('ENTRADA', 'CONSUMO', 'PERDA', 'AJUSTE_INVENTARIO')), -- RF04: entrada, saída, consumo, perda e inventário
    CONSTRAINT ck_mov_sinal CHECK ((tipo_movimentacao = 'ENTRADA' AND quantidade > 0) OR (tipo_movimentacao IN ('CONSUMO', 'PERDA') AND quantidade < 0) OR (tipo_movimentacao = 'AJUSTE_INVENTARIO' AND quantidade <> 0)), -- o sinal da quantidade precisa combinar com o tipo
    CONSTRAINT ck_mov_entrada_lote CHECK (tipo_movimentacao <> 'ENTRADA' OR id_lote IS NOT NULL), -- toda entrada vem de um lote
    CONSTRAINT ck_mov_consumo_pedido CHECK (tipo_movimentacao <> 'CONSUMO' OR id_pedido IS NOT NULL), -- consumo é calculado a partir de um pedido
    CONSTRAINT ck_mov_motivo CHECK (tipo_movimentacao NOT IN ('PERDA', 'AJUSTE_INVENTARIO') OR motivo IS NOT NULL) -- perdas e ajustes precisam de justificativa
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Livro de movimentações: o saldo do estoque é a soma desta tabela (não há saldo armazenado)';

-- ---------------------------------------------------------------------
-- BLOCO 6: FINANCEIRO
-- ---------------------------------------------------------------------

CREATE TABLE conta_pagar (
    id_conta_pagar INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador da obrigação financeira',
    id_compra INT NULL COMMENT 'Compra que originou a obrigação; NULL para outras despesas',
    descricao VARCHAR(120) NOT NULL COMMENT 'Descrição da obrigação (ex.: boleto do fornecedor, aluguel)',
    valor DECIMAL(10,2) NOT NULL COMMENT 'Valor a pagar em reais',
    data_vencimento DATE NOT NULL COMMENT 'Data de vencimento',
    data_pagamento DATE NULL COMMENT 'Data em que foi paga; NULL enquanto aberta',
    status_conta VARCHAR(10) NOT NULL DEFAULT 'ABERTA' COMMENT 'ABERTA, PAGA ou CANCELADA',
    CONSTRAINT pk_conta_pagar PRIMARY KEY (id_conta_pagar),
    CONSTRAINT fk_conta_pagar_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra), -- liga a obrigação à compra que a gerou
    CONSTRAINT ck_conta_pagar_valor CHECK (valor > 0), -- valor positivo
    CONSTRAINT ck_conta_pagar_status CHECK (status_conta IN ('ABERTA', 'PAGA', 'CANCELADA')), -- domínio fechado
    CONSTRAINT ck_conta_pagar_pagamento CHECK ((status_conta = 'PAGA' AND data_pagamento IS NOT NULL) OR (status_conta <> 'PAGA' AND data_pagamento IS NULL)) -- data de pagamento só existe quando paga
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Contas a pagar: obrigações com fornecedores e outras despesas';
