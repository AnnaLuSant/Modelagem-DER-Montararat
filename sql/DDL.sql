CREATE DATABASE montararat_banco;
USE montararat_banco;

-- CADASTROS IMPORTANTES

CREATE TABLE Pessoa (
  cpf CHAR(11) PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  CHECK (cpf REGEXP '^[0-9]{11}$')
) ENGINE=InnoDB;

CREATE TABLE Cargo (
  id_cargo int AUTO_INCREMENT PRIMARY KEY,
  nome_cargo VARCHAR(80) NOT NULL,
  salario_base DECIMAL(8,2) NOT NULL,
  CONSTRAINT chk_cargo_salario  CHECK ( salario_base >= 0)
) ENGINE=InnoDB;

CREATE TABLE Funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NOT NULL,
  id_cargo INT NOT NULL,
  data_admissao DATE NOT NULL,
  status_funcionario ENUM ('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo)
) ENGINE=InnoDB;

CREATE TABLE Fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  cnpj CHAR(14) NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  CHECK (cnpj REGEXP '^[0-9]{14}$')
) ENGINE=InnoDB;

CREATE TABLE Endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY,
  cep CHAR(8) NOT NULL,
  logradouro VARCHAR(180) NOT NULL,
  numero VARCHAR(15) NOT NULL,
  complemento VARCHAR(90) NULL
) ENGINE=InnoDB;

CREATE TABLE PessoaEndereco (
  cpf CHAR(11) NOT NULL,
  id_endereco INT NOT NULL,
  PRIMARY KEY (cpf, id_endereco),
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco)
) ENGINE=InnoDB;

CREATE TABLE Telefone (
  id_telefone INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NULL,
  id_fornecedor INT NULL,
  ddd CHAR(2) NOT NULL,
  numero VARCHAR(11) NOT NULL,
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor),
  CONSTRAINT chk_telefone_titular CHECK ((cpf IS NOT NULL) <> (id_fornecedor IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE Email (
  id_email INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NULL,
  id_fornecedor INT NULL,
  email VARCHAR(254) NOT NULL,
  tipo ENUM('PESSOAL','CORPORATIVO') NOT NULL,
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor),
  CONSTRAINT chk_email_titular CHECK ((cpf IS NOT NULL) <> (id_fornecedor IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE FormaPagamento (
  id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  tipo ENUM('PIX','CARTAO DE CREDITO','CARTAO DE DEBITO','DINHEIRO') NOT NULL 
) ENGINE=InnoDB;

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nome ENUM('BEBIDA','LANCHE','ACOMPANHAMENTO','PORCAO','SOBREMESA') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  id_categoria INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  preco_base DECIMAL(6,2) NOT NULL,
  descricao TEXT NULL,
  montagem_especial BOOLEAN NOT NULL DEFAULT FALSE,
  tempo_preparo_min SMALLINT UNSIGNED NULL,
  disponivel BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
  CONSTRAINT chk_produto_preco CHECK (preco_base >= 0),
  CONSTRAINT chk_produto_tempo
  CHECK (
    tempo_preparo_min IS NULL
    OR tempo_preparo_min > 0)
) ENGINE=InnoDB;

CREATE TABLE Combo (
  id_combo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  preco_combo DECIMAL(6,2) NOT NULL,
  descricao TEXT NULL,
  CONSTRAINT chk_combo_preco CHECK (preco_combo >= 0)
) ENGINE=InnoDB;

CREATE TABLE ItemCombo (
  id_combo INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade_prod INT NOT NULL,
  PRIMARY KEY (id_combo, id_produto),
  FOREIGN KEY (id_combo) REFERENCES Combo(id_combo),
  FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
  CONSTRAINT chk_ic_quantidade CHECK (quantidade_prod > 0)
) ENGINE=InnoDB;

CREATE TABLE Insumo (
  id_insumo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  unidade_medida ENUM('L','KG','UNI','ML','PCT','CX','G'),
  quantidade_minima DECIMAL(11,2) NOT NULL DEFAULT 0,
  CONSTRAINT chk_insumo_minima CHECK (quantidade_minima >= 0)
) ENGINE=InnoDB;

CREATE TABLE FichaTecnica (
  id_produto INT NOT NULL,
  id_insumo INT NOT NULL,
  quantidade_necessaria DECIMAL(11,2) NOT NULL,
  PRIMARY KEY (id_produto, id_insumo),
  FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
  FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo),
  CONSTRAINT chk_ft_quantidade CHECK (quantidade_necessaria > 0)
) ENGINE=InnoDB;

-- GESTÃO DE ESTOQUES E COMPRAS

CREATE TABLE Compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor INT NOT NULL,
  id_funcionario INT NOT NULL,
  data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_compra ENUM('PENDENTE','SOLICITADO','EM TRANSPORTE','RECEBIDA','CANCELADA') NOT NULL, -- ENUM? 
  FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor),
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE ItemCompra (
  id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_compra INT NOT NULL,
  id_insumo INT NOT NULL,
  quantidade_solicitada DECIMAL(11,2) NOT NULL,
  preco_unitario DECIMAL(6,2) NOT NULL,
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
  FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo),
  CONSTRAINT chk_itemcompra_qtd CHECK (quantidade_solicitada > 0),
  CONSTRAINT chk_itemcompra_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE Lote (
  id_lote INT AUTO_INCREMENT PRIMARY KEY,
  id_insumo INT NOT NULL,
  id_item_compra INT NULL,
  numero_lote VARCHAR(80) NOT NULL,
  data_validade DATE NOT NULL,
  data_recebimento DATETIME NULL,
  quantidade_inicial DECIMAL(11,2) NULL,
  status_lote ENUM('DISPONIVEL','ESGOTADO','VENCIDO','DESCARTADO') NOT NULL DEFAULT 'DISPONIVEL',
  FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo),
  FOREIGN KEY (id_item_compra) REFERENCES ItemCompra(id_item_compra),
  CONSTRAINT chk_lote_qtd CHECK (quantidade_inicial IS NULL OR quantidade_inicial >= 0)
) ENGINE=InnoDB;

CREATE TABLE Mesa (
  id_mesa INT AUTO_INCREMENT PRIMARY KEY,
  capacidade SMALLINT UNSIGNED NOT NULL,
  numero VARCHAR(15) NOT NULL UNIQUE,
  status_mesa ENUM ('OCUPADO','LIVRE','EM LIMPEZA'),
  CONSTRAINT chk_mesa_capacidade CHECK (capacidade > 0)
) ENGINE=InnoDB;

CREATE TABLE Reserva ( -- DROP
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NOT NULL,
  id_funcionario INT NOT NULL,
  quantidade_pessoas SMALLINT UNSIGNED NOT NULL,
  data_hora_inicio DATETIME NOT NULL,
  status ENUM ('PENDENTE','CANCELADA','CONCLUIDA') NOT NULL,
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
  CONSTRAINT chk_reserva_pessoas CHECK (quantidade_pessoas > 0)
) ENGINE=InnoDB;

CREATE TABLE ReservaMesa ( -- DROP
  id_reserva INT NOT NULL,
  id_mesa INT NOT NULL,
  PRIMARY KEY (id_reserva, id_mesa),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
) ENGINE=InnoDB;


CREATE TABLE Atendimento (
  id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario INT NOT NULL,
  id_reserva INT NULL,
  hora_chegada DATETIME NOT NULL,
  hora_saida DATETIME NULL,
  qtd_pessoas SMALLINT UNSIGNED NOT NULL,
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  CONSTRAINT chk_atendimento_qtd CHECK (qtd_pessoas > 0),
  CONSTRAINT chk_atendimento_horarios CHECK (hora_saida IS NULL OR hora_saida >= hora_chegada)
) ENGINE=InnoDB;

CREATE TABLE AtendimentoMesa (
  id_atendimento INT NOT NULL,
  id_mesa INT NOT NULL,
  PRIMARY KEY (id_atendimento, id_mesa),
  FOREIGN KEY (id_atendimento) REFERENCES Atendimento(id_atendimento),
  FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
) ENGINE=InnoDB;

CREATE TABLE Caixa (
  id_caixa INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario_abertura INT NOT NULL,
  id_funcionario_fechamento INT NULL,
  data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_fechamento DATETIME NULL,
  tipo_caixa ENUM ('LOCAL','DELIVERY') NOT NULL,
  valor_abertura DECIMAL(12,2) NOT NULL,
  valor_fechamento DECIMAL(12,2) NULL,
  status_caixa ENUM('ABERTO','FECHADO')NOT NULL DEFAULT 'ABERTO',
  FOREIGN KEY (id_funcionario_abertura) REFERENCES Funcionario(id_funcionario),
  FOREIGN KEY (id_funcionario_fechamento) REFERENCES Funcionario(id_funcionario),
  CONSTRAINT chk_caixa_valores CHECK (valor_abertura >= 0 AND (valor_fechamento IS NULL OR valor_fechamento >= 0)),
  CONSTRAINT chk_caixa_fechamento CHECK (
	status_caixa <> 'FECHADO' OR
    (id_funcionario_fechamento IS NOT NULL AND data_fechamento IS NOT NULL AND valor_fechamento IS NOT NULL)
 ),
	CONSTRAINT chk_caixa_datas CHECK (data_fechamento IS NULL OR data_fechamento >= data_abertura)
) ENGINE=InnoDB;

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NOT NULL,
  id_mesa INT NULL,
  id_funcionario INT NULL,
  id_atendimento INT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_pedido ENUM('PENDENTE','EM PRODUCAO','CONCLUIDO','ENTREGUE','CANCELADO') NOT NULL,
  modalidade ENUM('LOCAL','RETIRADA','ENTREGA') NOT NULL,
  canal_origem ENUM('SALAO','IFOOD','99FOOD') NULL,
  data_hora_inicio_producao DATETIME NULL,
  data_hora_fim_producao DATETIME NULL,
  FOREIGN KEY (cpf) REFERENCES Pessoa(cpf),
  FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa),
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
  FOREIGN KEY (id_atendimento) REFERENCES Atendimento(id_atendimento),
  CONSTRAINT chk_pedido_producao CHECK (
    data_hora_fim_producao IS NULL OR
    (data_hora_inicio_producao IS NOT NULL AND data_hora_fim_producao >= data_hora_inicio_producao)
  )
) ENGINE=InnoDB;

CREATE TABLE ItemPedido (
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(6,2) NOT NULL,
  observacao VARCHAR(250) NULL,
  
  PRIMARY KEY (id_pedido, id_produto),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
  CONSTRAINT chk_ip_qtd CHECK (quantidade > 0),
  CONSTRAINT chk_ip_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE ItemComboPedido (
  id_pedido INT NOT NULL,
  id_combo INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(6,2) NOT NULL,
  observacao VARCHAR(250) NULL,
  PRIMARY KEY (id_pedido, id_combo),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_combo) REFERENCES Combo(id_combo),
  CONSTRAINT chk_icp_qtd CHECK (quantidade > 0),
  CONSTRAINT chk_icp_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE Pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_caixa INT NOT NULL,
  id_forma_pagamento INT NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_pagamento ENUM('PENDENTE','APROVADO','RECUSADO','CANCELADO','ESTORNADO') NOT NULL default 'PENDENTE',
  valor_total DECIMAL(6,2) NOT NULL,
  referencia_externa ENUM('IFOOD', '99FOOD') NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_caixa) REFERENCES Caixa(id_caixa),
  FOREIGN KEY (id_forma_pagamento) REFERENCES FormaPagamento(id_forma_pagamento),
  CONSTRAINT chk_pagamento_valor CHECK (valor_total > 0)
) ENGINE=InnoDB;

CREATE TABLE Entregador (
  id_entregador INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario INT NULL,
  tipo_vinculo ENUM('LOCAL','EXTERNO') NOT NULL,
  plataforma ENUM('IFOOD','99FOOD') NULL,
  identificador_externo CHAR(4) NULL,
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE Entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL UNIQUE,
  id_entregador INT NULL,
  id_endereco INT NOT NULL,
  status_entrega ENUM('PENDENTE','AGUARDANDO_ENTREGADOR','EM_TRANSITO','ENTREGUE','NAO_ENTREGUE','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  taxa_entrega DECIMAL(12,2) NOT NULL DEFAULT 0,
  data_saida DATETIME NULL,
  data_chegada DATETIME NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_entregador) REFERENCES Entregador(id_entregador),
  FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco),
  CONSTRAINT chk_entrega_taxa CHECK (taxa_entrega >= 0),
  CONSTRAINT chk_entrega_datas CHECK (data_chegada IS NULL OR (data_saida IS NOT NULL AND data_chegada >= data_saida))
) ENGINE=InnoDB;

CREATE TABLE EventoEntrega ( -- gerencia data e hora e historico de mudança de status da entrega
  id_evento_entrega INT AUTO_INCREMENT PRIMARY KEY,
  id_entrega INT NOT NULL,
  origem_atualizacao ENUM('IFOOD','99FOOD','LOCAL')NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_entrega ENUM('PENDENTE','AGUARDANDO_ENTREGADOR','EM_TRANSITO','ENTREGUE','NAO_ENTREGUE','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  FOREIGN KEY (id_entrega) REFERENCES Entrega(id_entrega),
  INDEX idx_evento_entrega_tempo (id_entrega, data_hora)
) ENGINE=InnoDB;


CREATE TABLE Avaliacao (
  id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL UNIQUE,
  comentario TEXT NULL,
  data DATE NOT NULL,
  nota TINYINT UNSIGNED NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  CONSTRAINT chk_avaliacao_nota CHECK (nota BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE Ocorrencia (
  id_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_funcionario_responsavel INT NULL,
  classificacao ENUM('PRODUTO_INCORRETO','ITEM_FALTANTE','QUALIDADE_PRODUTO','ATRASO_PEDIDO','ERRO_COBRANCA','PROBLEMA_ATENDIMENTO','CANCELAMENTO','OUTROS') NOT NULL,
  descricao VARCHAR(255) NULL,
  consumo_produto ENUM('CONSUMO','SEM_CONSUMO','CONSUMO_PARCIAL') NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_ocorrencia ENUM('ABERTA','EM ANALISE','RESOLVIDA','ENCERRADA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  CONSTRAINT chk_ocorrencia_descricao
    CHECK (classificacao <> 'OUTROS' OR (descricao IS NOT NULL AND TRIM(descricao) <> '')),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_funcionario_responsavel) REFERENCES Funcionario(id_funcionario)
) ENGINE=InnoDB;

CREATE TABLE Reembolso (
  id_reembolso INT AUTO_INCREMENT PRIMARY KEY,
  id_ocorrencia INT NOT NULL,
  id_pagamento INT NOT NULL,
  valor_reembolso DECIMAL(6,2) NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_reembolso ENUM('SOLICITADO','EM_ANALISE','APROVADO','REJEITADO','PROCESSANDO','CONCLUIDO','CANCELADO','FALHO') NOT NULL DEFAULT 'SOLICITADO',
  FOREIGN KEY (id_ocorrencia) REFERENCES Ocorrencia(id_ocorrencia),
  FOREIGN KEY (id_pagamento) REFERENCES Pagamento(id_pagamento),
  CONSTRAINT chk_reembolso_valor CHECK (valor_reembolso > 0)
) ENGINE=InnoDB;

CREATE TABLE Promocao (
  id_promocao INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  status_promocao ENUM('ATIVA', 'SUSPENSA', 'ENCERRADA') NOT NULL DEFAULT 'ATIVA',
  tipo ENUM('COMBO PROMOCIONAL','PERCENTUAL','FRETE_GRATIS','VALOR_FIXO') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE PromocaoProduto (
  id_produto INT NOT NULL,
  id_promocao INT NOT NULL,
  percentual_desconto DECIMAL(5,2) NOT NULL,
  quantidade_limite INT UNSIGNED NULL,
  PRIMARY KEY (id_produto, id_promocao),
  FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
  FOREIGN KEY (id_promocao) REFERENCES Promocao(id_promocao),
  CONSTRAINT chk_pp_desconto CHECK (percentual_desconto BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE PromocaoCombo (
  id_combo INT NOT NULL,
  id_promocao INT NOT NULL,
  percentual_desconto DECIMAL(5,2) NOT NULL,
  quantidade_limite INT UNSIGNED NULL,
  PRIMARY KEY (id_combo, id_promocao),
  FOREIGN KEY (id_combo) REFERENCES Combo(id_combo),
  FOREIGN KEY (id_promocao) REFERENCES Promocao(id_promocao),
  CONSTRAINT chk_pc_desconto CHECK (percentual_desconto BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE MovimentacaoEstoque (
  id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
  id_lote INT NOT NULL,
  id_funcionario INT NULL,
  id_pedido INT NULL,
  tipo_movimentacao ENUM('ENTRADA','CONSUMO','DESPERDICIO','PERDA','AJUSTE_SAIDA','AJUSTE_ENTRADA') NOT NULL,
  quantidade DECIMAL(14,2) NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  motivo VARCHAR(255) NULL,
  FOREIGN KEY (id_lote) REFERENCES Lote(id_lote),
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  CONSTRAINT chk_mov_quantidade CHECK (quantidade > 0),
  INDEX idx_mov_lote_data (id_lote, data_hora),
  INDEX idx_mov_pedido (id_pedido)
) ENGINE=InnoDB;



CREATE TABLE Despesa (
  id_despesa INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario INT NOT NULL,
  id_forma_pagamento INT NULL,
  id_compra INT NULL,
  descricao VARCHAR(150) NOT NULL,
  valor DECIMAL(7,2) NOT NULL,
  data_vencimento DATE NOT NULL,
  data_pagamento DATE NULL,
  status_despesa ENUM('PENDENTE','PAGA','VENCIDA','CANCELADA') NOT NULL DEFAULT 'PENDENTE',
  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
  FOREIGN KEY (id_forma_pagamento) REFERENCES FormaPagamento(id_forma_pagamento),
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
  CONSTRAINT chk_despesa_valor CHECK (valor >= 0)
) ENGINE=InnoDB;

-- Criação de vews

CREATE OR REPLACE VIEW vw_estoque_insumos AS
SELECT
  i.id_insumo,
  i.nome,
  i.unidade_medida,
  i.quantidade_minima,
  COALESCE(SUM(CASE
    WHEN m.tipo_movimentacao IN ('ENTRADA','AJUSTE_ENTRADA') THEN m.quantidade
    WHEN m.tipo_movimentacao IN ('CONSUMO','PERDA','DESPERDICIO','AJUSTE_SAIDA') THEN -m.quantidade
    ELSE 0 END), 0) AS saldo_atual,
  CASE WHEN COALESCE(SUM(CASE
    WHEN m.tipo_movimentacao IN ('ENTRADA','AJUSTE_ENTRADA') THEN m.quantidade
    WHEN m.tipo_movimentacao IN ('CONSUMO','PERDA','DESPERDICIO','AJUSTE_SAIDA') THEN -m.quantidade
    ELSE 0 END), 0) <= i.quantidade_minima THEN 'REPOR' ELSE 'OK' END AS situacao_reposicao
FROM Insumo i
LEFT JOIN Lote l ON l.id_insumo = i.id_insumo
LEFT JOIN MovimentacaoEstoque m ON m.id_lote = l.id_lote
GROUP BY i.id_insumo, i.nome, i.unidade_medida, i.quantidade_minima;

CREATE OR REPLACE VIEW vw_produtos_mais_vendidos AS
SELECT p.id_produto, p.nome, SUM(ip.quantidade) AS quantidade_vendida
FROM Produto p
JOIN ItemPedido ip ON ip.id_produto = p.id_produto
JOIN Pedido ped ON ped.id_pedido = ip.id_pedido
WHERE ped.status_pedido = 'CONCLUIDO'
GROUP BY p.id_produto, p.nome;

CREATE OR REPLACE VIEW vw_combos_mais_vendidos AS
SELECT c.id_combo, c.nome, SUM(icp.quantidade) AS quantidade_vendida
FROM Combo c
JOIN ItemComboPedido icp ON icp.id_combo = c.id_combo
JOIN Pedido ped ON ped.id_pedido = icp.id_pedido
WHERE ped.status_pedido = 'CONCLUIDO'
GROUP BY c.id_combo, c.nome;

CREATE VIEW vw_fila_prioridade_pedidos AS
SELECT
    p.id_pedido,
    p.cpf,
    p.id_mesa,
    p.id_funcionario,
    p.data_hora,
    p.status_pedido,
    p.modalidade,

    CASE
        WHEN p.modalidade = 'LOCAL' THEN 1
        WHEN p.modalidade IN ('RETIRADA', 'ENTREGA') THEN 2
    END AS prioridade

FROM Pedido p

WHERE p.status_pedido = 'PENDENTE';

-- view para combos

CREATE OR REPLACE VIEW vw_combos_mais_vendidos AS
SELECT
    c.id_combo,
    c.nome AS nome_combo,
    SUM(icp.quantidade) AS quantidade_vendida
FROM Combo c
INNER JOIN ItemComboPedido icp
    ON c.id_combo = icp.id_combo
INNER JOIN Pedido p
    ON icp.id_pedido = p.id_pedido
WHERE p.status_pedido = 'CONCLUIDO'
GROUP BY
    c.id_combo,
    c.nome;


-- view para lanches mais vendidos

CREATE OR REPLACE VIEW vw_lanches_mais_vendidos AS
SELECT
    p.id_produto,
    p.nome AS nome_lanche,
    SUM(ip.quantidade) AS quantidade_vendida
FROM Produto p
INNER JOIN Categoria c
    ON p.id_categoria = c.id_categoria
INNER JOIN ItemPedido ip
    ON p.id_produto = ip.id_produto
INNER JOIN Pedido ped
    ON ip.id_pedido = ped.id_pedido
WHERE
    c.nome = 'LANCHE'
    AND ped.status_pedido = 'CONCLUIDO'
GROUP BY
    p.id_produto,
    p.nome;