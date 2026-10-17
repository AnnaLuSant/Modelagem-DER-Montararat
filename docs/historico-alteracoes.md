# Histórico de alterações: da 1ª entrega (nota 5,25) à versão revisada

Cada linha da devolutiva do professor foi mapeada para a correção e para a **evidência verificável** no repositório.

| # | Item da devolutiva | Correção feita | Onde está / como verificar |
|---|---|---|---|
| 1 | Requisitos e regras: classificação dos RNF e ambiguidades (cancelamento, pagamento, prioridade) | Catálogo revisado, IDs mantidos, RNF02/RNF05 reclassificados, RDN09/RDN10 preenchidos | `docs/requisitos/requisitos.md`, `.xlsx` |
| 2 | RF04: faltavam entrada, saída, consumo, perdas, inventário, reposição | RF04 reescrito; tabelas `lote`, `movimentacao_estoque` (ENTRADA, CONSUMO, PERDA, AJUSTE_INVENTARIO); `estoque_minimo`; consulta de reposição | DDL; consultas G08, G09, AUD09, AUD10; teste T25 |
| 3 | RF07: ocupação da mesa ao longo do tempo | Ocupação derivada de `pedido.id_mesa` (início/fim) e `reserva` (início/fim); regra de não sobreposição | RF07; consulta O01; trigger `trg_reserva_bi`; testes T30-T31 |
| 4 | RF08: informações da estimativa | Tempo base (maior tempo de preparo) + pedidos à frente na fila | `v_tempo_base_pedido`, `v_estimativa_preparo`; consulta O02. Fórmula final: decisão D02 |
| 5 | RNF02 e RNF05 não são RNF | Reclassificados como RF18 (favoritos, com tabela `favorito`) e RF19 (ordem dos itens, `numero_item`) | `requisitos.md`; consultas O04, O05 |
| 6 | RDN03: justificar a limpeza das mesas | Justificada: o estado EM_LIMPEZA afeta a disponibilidade (RF07); o ato de limpar é procedimento | RDN03; trigger `trg_mesa_bu`; testes T32-T34 |
| 7 | Política de cancelamento: RDN05 x política organizacional | Regra única: sem consumo → troca/cancelamento/reembolso; exceção a confirmar (erro da casa) | RDN05/RDN10; CHECK `ck_ocorrencia_politica`; testes T21-T24 |
| 8 | Política de prioridade: como aplicar à fila | Prioridade 1 = LOCAL, 2 = demais; fila ordenada por (prioridade, horário) | RDN09; `v_fila_producao`; consultas O06, G07 |
| 9 | Combo: validar quantidade; distinguir cadastro de inclusão no pedido | `combo`/`item_combo` (quantidade > 0) separados de `item_combo_pedido` | `ck_item_combo_quantidade`; DER |
| 10 | Fluxo de disponibilidade pouco claro | Fluxograma mostra as três saídas: substituir, alterar ou desistir | `docs/diagramas/fluxograma-pedido.png` |
| 11 | Pagamento presencial x delivery: separar momentos | Delivery/retirada: pagar antes de produzir; local: pagar após o consumo | RDN01; trigger `trg_pedido_bu`; testes T16-T17 |
| 12 | Baixa de estoque: como o consumo é calculado | Consumo = itens × ficha técnica + combos × composição × ficha técnica, lançado ao iniciar o preparo | `v_consumo_pedido_insumo`; AUD09 (diferença = 0) |
| 13 | Encerramento: distinguir entregue, cancelado, pago, concluído | Status ENTREGUE, CANCELADO, CONCLUIDO + situação de pagamento por view; concluir exige pagamento integral | RDN15; `trg_pedido_bu`; teste T37 |
| 14 | Escopo: compras, recebimento, conferência e reposição ausentes | Tabelas `fornecedor_insumo`, `compra`, `item_compra`, `recebimento`, `lote`; fluxograma próprio | `fluxograma-compras-estoque.png`; AUD01 |
| 15 | Visão financeira: obrigações, recebimentos, pagamentos, caixa | `forma_pagamento`, `pagamento` (N por pedido), `caixa`, `conta_pagar` | RF13, RF14; G10; AUD03, AUD05 |
| 16 | Fluxograma: decisões e caminhos; estoque e compras | Três fluxogramas (pedido, compras/estoque, caixa) com decisões rotuladas | `docs/diagramas/*.png` |
| 17 | Parte C: documentação consolidada | Repositório único com README, docs, SQL, evidências, apresentação | este repositório |
| 18 | Sequência Problema→...→Dicionário | Documentos seguem essa ordem (README seções 3 a 8) | `README.md` |
| 19 | (Extra, não pedido) Pessoa com PK cpf; avaliação 0-5; observação com "OBS"; comentário sem símbolos | PK substituta; nota 1-5; regras de apresentação removidas do banco | `normalizacao.md` N12; decisão D07 |
