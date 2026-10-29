# SPRINT 5/5 — Validação Final, Integração e Entrega do Banco de Dados

**Aluno:** Gabriel Sakaizawa Campos
**Banco:** db_restaurante_sabor

---

## 3. Revisão da Sprint 1/5 — Planejamento

**Tema do banco:** Sistema de gerenciamento de restaurante.

**Objetivo principal:** Registrar clientes, funcionários, mesas, produtos do cardápio, pedidos e os itens de cada pedido, permitindo consultar o funcionamento do restaurante (vendas, atendimento, faturamento).

**Quantidade final de tabelas:** 6.

**Principais entidades do banco:**
1. Cliente
2. Funcionário
3. Mesa
4. Produto
5. Pedido
6. Item_Pedido

**O projeto final permaneceu igual ao planejamento inicial?** Sim, com uma pequena adição: o campo `observacao` foi incluído em `pedido` durante a Sprint 2/5, para registrar pedidos especiais (ex.: "sem cebola").

---

## 4. Mudanças realizadas ao longo das Sprints

| Alteração | Sprint | Justificativa |
|---|---|---|
| Adição da coluna `observacao` em `pedido` | 2/5 | Necessidade de registrar pedidos especiais do cliente, não prevista no planejamento inicial |
| Remoção de item de pedido duplicado (id_item_pedido 11) | 3/5 | Item inserido por engano durante os testes de DML |
| Remoção do cliente Juliana Costa (id 5) | 3/5 | Cliente sem nenhum pedido vinculado, usado apenas para testar DELETE sem violar integridade referencial |

---

## 5–7. Revisão da estrutura, PRIMARY KEY e FOREIGN KEY

| Tabela | PK | FKs |
|---|---|---|
| cliente | id_cliente (AUTO_INCREMENT) | — |
| funcionario | id_funcionario (AUTO_INCREMENT) | — |
| mesa | id_mesa (AUTO_INCREMENT) | — |
| produto | id_produto (AUTO_INCREMENT) | — |
| pedido | id_pedido (AUTO_INCREMENT) | id_cliente → cliente, id_mesa → mesa, id_funcionario → funcionario |
| item_pedido | id_item_pedido (AUTO_INCREMENT) | id_pedido → pedido, id_produto → produto |

Todas as tabelas independentes (cliente, funcionario, mesa, produto) são criadas antes das dependentes (pedido, item_pedido), respeitando a ordem exigida pelas FKs.

---

## 8. Restrições utilizadas

| Tabela | Campo | Restrição | Regra de negócio protegida |
|---|---|---|---|
| cliente | cpf | UNIQUE | Impede cadastro de CPF duplicado |
| funcionario | email | UNIQUE | Impede e-mails corporativos duplicados |
| pedido/item_pedido | id_cliente, id_pedido, etc. | FOREIGN KEY | Impede pedidos ou itens "órfãos", sem cliente/mesa/produto válido |
| todas | maioria dos campos | NOT NULL | Garante que dados essenciais não fiquem vazios |
| mesa.status, pedido.status | — | DEFAULT | Toda mesa nasce "livre" e todo pedido nasce "aberto" |

---

## 9–10. Revisão dos dados e INSERTs

| Tabela | Registros finais |
|---|---:|
| cliente | 4 (5 inseridos, 1 removido) |
| funcionario | 5 |
| mesa | 5 |
| produto | 5 |
| pedido | 5 |
| item_pedido | 10 (11 inseridos, 1 removido) |

Os INSERTs executam sem erro, respeitam as FKs (nenhum pedido referencia cliente/mesa/funcionário inexistente) e não violam as restrições UNIQUE/NOT NULL. Há dados suficientes para testar relacionamentos, filtros, `GROUP BY` (categorias de produto, status de pedido) e agregações (`SUM`, `AVG`, `MIN`/`MAX`).

---

## 11. Revisão dos UPDATEs

Os 3 UPDATEs finais possuem `WHERE` e alteram apenas o registro pretendido:
```sql
UPDATE cliente SET telefone = '11999990000' WHERE id_cliente = 2;
UPDATE mesa SET status = 'ocupada' WHERE id_mesa = 1;
UPDATE pedido SET status = 'finalizado' WHERE id_pedido = 1;
```

## 12. Revisão dos DELETEs

Os 2 DELETEs finais possuem `WHERE`, respeitam as dependências de FK e não comprometem consultas posteriores:
```sql
DELETE FROM item_pedido WHERE id_item_pedido = 11;
DELETE FROM cliente WHERE id_cliente = 5;
```

---

## 13. Revisão das consultas da Sprint 4/5

| Recurso SQL | Possui consulta válida? | Pergunta respondida |
|---|---|---|
| SELECT | Sim | Quais produtos existem no cardápio? |
| WHERE | Sim | Quais produtos são bebidas / pratos > R$50? |
| ORDER BY | Sim | Produtos do mais caro ao mais barato |
| COUNT | Sim | Pedidos atendidos por funcionário |
| SUM | Sim | Valor total de cada pedido |
| AVG | Sim | Preço médio por categoria |
| MIN/MAX | Sim | Produto mais barato/caro |
| GROUP BY | Sim | Pedidos por status |
| HAVING | Sim | Categorias com média acima de R$10 |

---

## 22. Testando a integridade referencial

**Tabela testada:** `cliente` → `pedido`
**Restrição testada:** FOREIGN KEY (`pedido.id_cliente`)
**Resultado:** ao tentar excluir o cliente id 1 (que possui pedidos 1 e 3 vinculados), o MySQL rejeita a operação com erro de restrição de chave estrangeira, confirmando que a integridade referencial está funcionando corretamente.

---

## 26. Consulta final mais importante

**Pergunta:** Qual o valor total de cada pedido?
**Por que é importante:** é a consulta que sustenta a operação real do restaurante — fechar a conta do cliente.

## 27. Consulta final mais complexa

**Pergunta:** Quantos pedidos cada funcionário atendeu?
**Conceitos utilizados:** `LEFT JOIN`, `GROUP BY`, `COUNT`, `ORDER BY`.
**Explicação:** usa LEFT JOIN (em vez de INNER JOIN) para que funcionários sem pedidos atendidos, como a gerente, também apareçam no resultado com contagem zero.

---

## 28. Registro dos testes finais

Testes realizados executando o `SPRINT5-5.sql` completo no MySQL Workbench 26.7.0, após reconstruir o banco do zero.

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | OK | Não |
| CREATE TABLE (6 tabelas) | OK — todas apareceram no painel SCHEMAS | Não |
| PRIMARY KEY | OK | Não |
| FOREIGN KEY | OK | Não |
| NOT NULL | OK | Não |
| UNIQUE | OK | Não |
| INSERT | OK | Não |
| UPDATE | OK | Não |
| DELETE | OK | Não |
| SELECT | OK | Não |
| WHERE | OK | Não |
| ORDER BY | OK | Não |
| GROUP BY | OK | Não |
| HAVING | OK | Não |
| funções de agregação (COUNT/SUM/AVG/MIN/MAX) | OK — SUM por pedido conferido manualmente, bateu com o esperado | Não |

---

## 29. Problemas encontrados na validação final

Nenhum problema identificado após a execução completa do projeto: todas as tabelas, restrições, dados e consultas funcionaram conforme esperado ao reconstruir o banco do zero.

---

## 42. Checklist técnico final

**Banco**
- [x] `CREATE DATABASE` funciona;
- [x] `USE` funciona;
- [x] todas as tabelas são criadas;
- [x] nenhuma tabela necessária está ausente.

**Estrutura**
- [x] todas as tabelas possuem PK;
- [x] FKs estão corretas;
- [x] tipos de dados estão coerentes;
- [x] `NOT NULL` está coerente;
- [x] `UNIQUE` está coerente;
- [x] `DEFAULT` está coerente.

**Dados**
- [x] INSERTs funcionam;
- [x] dados são coerentes;
- [x] FKs são respeitadas.

**Manipulação**
- [x] UPDATEs funcionam;
- [x] UPDATEs possuem `WHERE`;
- [x] DELETEs funcionam;
- [x] DELETEs possuem `WHERE`.

**Consultas**
- [x] SELECT funciona;
- [x] WHERE funciona;
- [x] ORDER BY funciona;
- [x] COUNT funciona;
- [x] SUM funciona quando aplicável;
- [x] AVG funciona quando aplicável;
- [x] MIN/MAX funcionam;
- [x] GROUP BY funciona;
- [x] HAVING funciona.

**Arquivos**
- [x] `SPRINT1-5.md`;
- [x] `SPRINT2-5.md`;
- [x] `SPRINT2-5.sql`;
- [x] `SPRINT3-5.md`;
- [x] `SPRINT3-5.sql`;
- [x] `SPRINT4-5.md`;
- [x] `SPRINT4-5.sql`;
- [ ] `SPRINT5-5.md` (revisar antes do commit);
- [x] `SPRINT5-5.sql`.

---

## 43. Autoavaliação

**O que aprendi melhor:** a diferença entre `WHERE` (filtra linhas antes do agrupamento) e `HAVING` (filtra grupos depois do agrupamento).

**Maior dificuldade:** montar a consulta de contagem de pedidos por funcionário garantindo que funcionários sem pedidos ainda aparecessem (uso de `LEFT JOIN`).

**Erro que mais contribuiu para o aprendizado:** o item de pedido inserido por engano no Pedido 1 (Sprint 3/5), que exigiu um DELETE cuidadoso para não afetar os demais itens.

**Parte mais bem implementada:** o relacionamento entre `pedido` e `item_pedido`, que reflete corretamente a lógica de "um pedido tem vários itens".

**Se tivesse mais tempo:** adicionaria uma tabela de "categoria" separada, normalizando o campo `categoria` de `produto` em vez de mantê-lo como texto livre.
