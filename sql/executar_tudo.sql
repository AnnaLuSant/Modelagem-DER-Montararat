-- =====================================================================
-- MontArarat ERP - Execução completa, na ordem correta (MySQL 8.0.16+ / MariaDB 10.5+).
-- Use o cliente de linha de comando a partir da pasta sql/:
--     mysql -u root -p --force < executar_tudo.sql  > ../evidencias/saida_mysql.txt 2>&1
-- (--force: continua após os erros ESPERADOS dos testes de restrição; confira a saída.)
-- No MySQL Workbench: File > Run SQL Script apontando para cada arquivo, nesta ordem.
-- =====================================================================
SOURCE ddl/01_create_database.sql;
SOURCE ddl/02_create_tables.sql;
SOURCE ddl/03_views.sql;
SOURCE dados/01_massa_dados.sql;
SOURCE ddl/04_triggers.sql;
SOURCE dml/01_dml_demonstracao.sql;
SOURCE consultas/gerenciais.sql;
SOURCE auditoria/auditoria.sql;
SOURCE testes/02_testes_restricoes.sql;
