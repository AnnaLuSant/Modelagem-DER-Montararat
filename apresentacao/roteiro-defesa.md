# Roteiro de defesa e perguntas prováveis

Tempo sugerido: 10 min de apresentação + arguição. **Todos os integrantes devem saber responder todas as perguntas.**

## Roteiro
1. Problema (estoque desorganizado) e a empresa (README, seção 1 a 4), com as evidências fotográficas.
2. Processo: fluxogramas (pedido, compras/estoque, caixa) e as decisões nos losangos.
3. Requisitos e regras → o que mudou (`docs/historico-alteracoes.md`, 19 itens).
4. DER conceitual → modelo lógico → normalização (`docs/normalizacao/normalizacao.md`).
5. Demonstração ao vivo no MySQL: carga, G08 (reposição), uma consulta de auditoria (AUD01) e um teste de restrição (T16 ou T25).
6. Limites e decisões a confirmar.

## Perguntas que um professor criterioso (ou uma IA) pode fazer

| Pergunta | Resposta curta e verificável |
|---|---|
| Por que o saldo de estoque não é um atributo? | É derivado: soma das movimentações. Guardar o saldo cria dependência transitiva e risco de divergência (`v_saldo_estoque`). |
| Como a baixa de estoque é calculada? | Itens × ficha técnica + combos × composição × ficha técnica (`v_consumo_pedido_insumo`); AUD09 prova diferença zero. |
| Por que `item_pedido.preco_unitario` não viola a 3FN? | É o preço histórico da venda (RDN14); o Dois Dilúvios mudou de preço em 01/10. |
| Por que `pessoa` não usa CPF como PK? | CPF é opcional (clientes de plataforma) e dado sensível; PK substituta com CPF único e opcional. |
| Como o sistema garante pagar antes de produzir no delivery? | Trigger `trg_pedido_bu` (RDN01) + auditoria AUD06; testes T16/T17. |
| Qual a política de cancelamento? | RDN05/RDN10: sem consumo; exceção de erro da casa para troca (decisão D01 a confirmar). |
| Como a prioridade do salão é aplicada? | `v_fila_producao`: prioridade 1 LOCAL, 2 demais, FIFO; G07 mede o efeito. |
| Como é a ocupação da mesa ao longo do tempo? | `pedido.id_mesa` com início e encerramento + `reserva`; O01 mostra a situação em um instante; trigger evita reservas sobrepostas. |
| Por que a limpeza da mesa está no sistema? | Muda a disponibilidade exibida (RF07); o ato de limpar é procedimento (RDN03). |
| Há anomalias nos dados? | Sim, seis plantadas de propósito (cabeçalho de `01_massa_dados.sql`) para provar a auditoria; nenhuma viola CHECK/FK. |
| O que foi testado? | 39 testes de restrição com controles positivos, 15 invariantes da massa, 13 consultas gerenciais, 7 operacionais, 10 de auditoria. |
| Rodou em MySQL? | **Responder com verdade**: o grupo deve ter executado `executar_tudo.sql` e guardado a saída em `evidencias/`. Se não executou, não afirme. |
| Onde a IA entrou? | `docs/ia/uso-de-ia.md`: o que gerou, o que foi validado e por quem. |
| Quem fez o quê? | `docs/divisao-trabalho.md` e o histórico de commits. |
