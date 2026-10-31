# Normalização - Mont Ararat

organizar informações de forma lógica, reduzir redundâncias e eliminar anomalias durante operações de inserção, atualização ou exclusão. garante a integridade dos dados, assegurando que as informações sejam consistentes e precisas.

A normalização é o processo de organizar os dados de um banco de forma lógica, dividindo-os em tabelas menores e relacionadas entre si. Seu objetivo é reduzir a redundância e evitar as anomalias de inserção, atualização e exclusão, que acontecem quando a mesma informação aparece repetida em vários lugares ou quando mexer em um dado afeta outros sem querer

---
## Primeira Forma Normal (1FN)

**Conceito:** uma tabela está em 1FN quando todos os atributos são atômicos (indivisíveis), não existem atributos multivalorados nem grupos repetidos, e cada tabela possui chave primária.

**O que mudou:** os atributos multivalorados e os grupos repetidos foram retirados das tabelas originais e viraram tabelas próprias.

### Tabelas criadas para os atributos multivalorados
| Atributo multivalorado | Tabela criada |
|---|---|
| Vários telefones por pessoa/fornecedor | <i>Telefone</i> |
| caada produto tem a sua categoria | <i>categoria</i> |
| Vários e-mails por pessoa/fornecedor | <i>Email</i> |
| Vários endereços por pessoa (e várias pessoas por endereço) | <i>Endereco + PessoaEndereco</i> |


---

## Segunda Forma Normal (2FN)

**Conceito:** uma tabela está em 2FN quando está em 1FN e nenhum atributo comum depende de apenas parte de uma chave primária composta.

**O que mudou:** nada. Todas as tabelas com chave composta (as 9 listadas acima) têm seus atributos dependendo da chave inteira, e as demais tabelas têm chave simples. Como o modelo **já estava em conformidade com a 2FN**, nenhuma tabela precisou ser alterada.

---

## Terceira Forma Normal (3FN)

**Conceito:** uma tabela está em 3FN quando está em 2FN e nenhum atributo comum depende de outro atributo comum (dependência transitiva), ou seja, todo atributo depende apenas da chave primária.

**O que foi alterado:** os dados que dependeriam de outro atributo ficam em tabelas próprias, ligadas por chave estrangeira.

### Tabelas que evitam dependência transitiva

| Dependência transitiva evitada | Tabela própria |
|---|---|
| id_funcionario → id_cargo → salario_base | <i>Cargo</i> |
| id_produto → id_categoria → descricao | <i>Categoria</i> |
| id_pagamento → id_forma_pagamento → tipo | <i>FormaPagamento</i> |
| id_pedido → id_mesa → capacidade, numero | <i>Mesa</i> |
| id_lote → id_insumo → nome, unidade_medida | <i>Insumo</i> |
| id_entrega → id_endereco → cep, logradouro | <i>Endereco</i> |