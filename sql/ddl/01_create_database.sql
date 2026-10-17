-- =====================================================================
-- MontArarat ERP - Script 01: criação do banco de dados
-- SGBD alvo: MySQL 8.0.16+ ou MariaDB 10.5+ (CHECK só é aplicado a partir dessas versões)
-- Execute a partir da pasta sql/ (ver sql/executar_tudo.sql)
-- =====================================================================
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS montararat_erp;

CREATE DATABASE montararat_erp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE montararat_erp;
