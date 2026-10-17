-- =====================================================================
-- MontArarat ERP - Script 04: triggers (regras que CHECK não consegue expressar)
-- Um CHECK só enxerga a própria linha; estas regras consultam outras tabelas.
-- Padrão das mensagens: 'RDNxx violada: ...' (xx = regra de negócio de docs/requisitos).
-- Execute com o cliente mysql ou MySQL Workbench (usa DELIMITER).
-- Ordem: depois da carga da massa (dados/01), pois a massa contém anomalias INTENCIONAIS
-- que a auditoria deve detectar (ver cabeçalho de dados/01_massa_dados.sql).
-- =====================================================================
SET NAMES utf8mb4;
USE montararat_erp;

DELIMITER $$

-- RDN12: somente cargo com permissão de compra (gerente e proprietário) compra insumos
CREATE TRIGGER trg_compra_bi BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1
                     FROM funcionario f
                     JOIN cargo c ON c.id_cargo = f.id_cargo
                    WHERE f.id_funcionario = NEW.id_funcionario
                      AND c.pode_comprar = 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN12 violada: apenas cargo com permissao de compra pode comprar insumos';
    END IF;
END$$

-- RDN11: desconto só com autorizador que tenha permissão; promoção que exige documento só vale com documento conferido
CREATE TRIGGER trg_pedido_bi BEFORE INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE v_exige_doc TINYINT DEFAULT 0;
    IF NEW.id_funcionario_autorizador IS NOT NULL
       AND NOT EXISTS (SELECT 1
                         FROM funcionario f
                         JOIN cargo c ON c.id_cargo = f.id_cargo
                        WHERE f.id_funcionario = NEW.id_funcionario_autorizador
                          AND c.pode_autorizar = 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN11 violada: autorizador sem permissao para autorizar descontos';
    END IF;
    IF NEW.id_promocao IS NOT NULL THEN
        SELECT exige_documento INTO v_exige_doc FROM promocao WHERE id_promocao = NEW.id_promocao;
        IF v_exige_doc = 1 AND NEW.documento_conferido = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RDN11 violada: promocao de aniversario exige documento conferido';
        END IF;
    END IF;
END$$

-- RDN01: retirada/delivery só entra em produção depois de pago
-- RDN15: pedido só é concluído com pagamento confirmado integral
CREATE TRIGGER trg_pedido_bu BEFORE UPDATE ON pedido
FOR EACH ROW
BEGIN
    DECLARE v_pago DECIMAL(12,2);
    DECLARE v_total DECIMAL(12,2);
    IF NEW.status_pedido = 'EM_PRODUCAO' AND OLD.status_pedido <> 'EM_PRODUCAO'
       AND NEW.modalidade <> 'LOCAL' THEN
        SELECT valor_pago, valor_total INTO v_pago, v_total
          FROM v_pedido_pagamento
         WHERE id_pedido = NEW.id_pedido;
        IF ROUND(v_pago, 2) < ROUND(v_total, 2) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RDN01 violada: pedido de retirada ou delivery exige pagamento confirmado antes da producao';
        END IF;
    END IF;
    IF NEW.status_pedido = 'CONCLUIDO' AND OLD.status_pedido <> 'CONCLUIDO' THEN
        SELECT valor_pago, valor_total INTO v_pago, v_total
          FROM v_pedido_pagamento
         WHERE id_pedido = NEW.id_pedido;
        IF ROUND(v_pago, 2) <> ROUND(v_total, 2) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RDN15 violada: pedido so pode ser concluido com pagamento confirmado integral';
        END IF;
    END IF;
END$$

-- RDN04 (disponibilidade e estoque) e RDN06 (montagem especial não vai por delivery)
CREATE TRIGGER trg_item_pedido_bi BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
    DECLARE v_disponivel TINYINT;
    DECLARE v_montagem TINYINT;
    DECLARE v_modalidade VARCHAR(10);
    DECLARE v_porcoes DECIMAL(14,3);
    SELECT disponivel, montagem_especial INTO v_disponivel, v_montagem
      FROM produto WHERE id_produto = NEW.id_produto;
    SELECT modalidade INTO v_modalidade
      FROM pedido WHERE id_pedido = NEW.id_pedido;
    IF v_disponivel = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN04 violada: produto indisponivel nao pode ser vendido';
    END IF;
    IF v_modalidade = 'DELIVERY' AND v_montagem = 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN06 violada: produto de montagem especial nao pode ser enviado por delivery';
    END IF;
    SELECT porcoes_possiveis_estoque INTO v_porcoes
      FROM v_disponibilidade_produto WHERE id_produto = NEW.id_produto;
    IF v_porcoes IS NOT NULL AND v_porcoes < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN04 violada: estoque insuficiente para a quantidade pedida (saldo e checado antes da venda)';
    END IF;
END$$

-- RDN06 também vale para combos: combo que contém produto de montagem especial não vai por delivery
CREATE TRIGGER trg_item_combo_pedido_bi BEFORE INSERT ON item_combo_pedido
FOR EACH ROW
BEGIN
    DECLARE v_modalidade VARCHAR(10);
    SELECT modalidade INTO v_modalidade
      FROM pedido WHERE id_pedido = NEW.id_pedido;
    IF v_modalidade = 'DELIVERY' AND EXISTS (SELECT 1
                                              FROM item_combo ic
                                              JOIN produto pr ON pr.id_produto = ic.id_produto
                                             WHERE ic.id_combo = NEW.id_combo
                                               AND pr.montagem_especial = 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN06 violada: combo com produto de montagem especial nao pode ser enviado por delivery';
    END IF;
END$$

-- RDN10: troca, cancelamento e reembolso só com autorização de cargo que tenha permissão
CREATE TRIGGER trg_ocorrencia_bi BEFORE INSERT ON ocorrencia
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1
                     FROM funcionario f
                     JOIN cargo c ON c.id_cargo = f.id_cargo
                    WHERE f.id_funcionario = NEW.id_funcionario_autorizador
                      AND c.pode_autorizar = 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN10 violada: ocorrencia exige autorizacao de cargo autorizado';
    END IF;
END$$

-- RDN13: uma saída não pode deixar o saldo do insumo negativo
CREATE TRIGGER trg_movimentacao_bi BEFORE INSERT ON movimentacao_estoque
FOR EACH ROW
BEGIN
    DECLARE v_saldo DECIMAL(14,3);
    IF NEW.quantidade < 0 THEN
        SELECT COALESCE(SUM(quantidade), 0) INTO v_saldo
          FROM movimentacao_estoque
         WHERE id_insumo = NEW.id_insumo;
        IF v_saldo + NEW.quantidade < 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'RDN13 violada: a saida deixaria o saldo do insumo negativo';
        END IF;
    END IF;
END$$

-- RDN02: uma mesa não pode ter duas reservas não canceladas com períodos sobrepostos
CREATE TRIGGER trg_reserva_bi BEFORE INSERT ON reserva
FOR EACH ROW
BEGIN
    IF NEW.status_reserva <> 'CANCELADA'
       AND EXISTS (SELECT 1
                     FROM reserva r
                    WHERE r.id_mesa = NEW.id_mesa
                      AND r.status_reserva <> 'CANCELADA'
                      AND r.data_hora_inicio < NEW.data_hora_fim
                      AND NEW.data_hora_inicio < r.data_hora_fim) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN02 violada: mesa ja reservada no periodo informado';
    END IF;
END$$

-- RDN03: a limpeza só ocorre após o uso (OCUPADA -> EM_LIMPEZA -> LIVRE; não se libera uma mesa ocupada sem limpar)
CREATE TRIGGER trg_mesa_bu BEFORE UPDATE ON mesa
FOR EACH ROW
BEGIN
    IF NEW.status_mesa = 'EM_LIMPEZA' AND OLD.status_mesa <> 'OCUPADA' AND OLD.status_mesa <> 'EM_LIMPEZA' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN03 violada: a limpeza so ocorre apos a utilizacao da mesa';
    END IF;
    IF OLD.status_mesa = 'OCUPADA' AND NEW.status_mesa = 'LIVRE' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RDN03 violada: mesa ocupada deve passar por limpeza antes de ficar livre';
    END IF;
END$$

DELIMITER ;
