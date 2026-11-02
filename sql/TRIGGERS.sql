USE montararat_banco;

DELIMITER $$

-- FUNCIONAAAAAAA

-- RDN10: cargo habilitado a registrar compras (no esquema atual, cargo pelo nome).
DROP TRIGGER IF EXISTS trg_compra_autorizacao$$ 

 CREATE TRIGGER trg_compra_autorizacao BEFORE INSERT ON Compra FOR EACH ROW
 BEGIN
 IF NOT EXISTS (SELECT 1 FROM Funcionario f JOIN Cargo c ON c.id_cargo=f.id_cargo
                WHERE f.id_funcionario=NEW.id_funcionario AND f.status_funcionario='ATIVO'
                AND UPPER(c.nome_cargo) IN ('GERENTE','PROPRIETARIO','PROPRIETÁRIO'))
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='RDN10: funcionario sem permissao de compra'; END IF;
 END$$

--USE montararat_banco;

-- Teste da TRIGGER - trg_compra_autorizacao

-- Teste 1: Atendente (id 2) -> deve dar ERROR 1644: RDN10
START TRANSACTION;
INSERT INTO Compra (id_fornecedor, id_funcionario, status_compra)
VALUES (1, 2, 'PENDENTE');
ROLLBACK;

-- Teste 2: Cozinheiro INATIVO (id 3) -> deve dar ERROR 1644: RDN10
START TRANSACTION;
INSERT INTO Compra (id_fornecedor, id_funcionario, status_compra)
VALUES (1, 3, 'PENDENTE');
ROLLBACK;




