# SPRINT 3/5 — Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Transformar consultas importantes em **Views** (consultas guardadas que funcionam como tabelas virtuais), usando `CREATE VIEW`, `CREATE OR REPLACE VIEW`, `DROP VIEW` e `SHOW FULL TABLES`.

---

# 1. Identificação

**Nome completo:**

> Gabriel Sakaizawa Campos

**Banco utilizado:**

```text
db_restaurante_sabor
```

---

# 2. Consultas do projeto que merecem reutilização

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Detalhe do pedido (cliente, atendente, mesa) — Sprint 1 | Evita repetir um `JOIN` de 4 tabelas toda vez | Sim: `vw_pedidos_detalhados` |
| Total gasto por cliente — Sprint 1 | Relatório de faturamento por cliente | Sim: `vw_faturamento_por_cliente` |
| Pedidos em aberto — Sprint 1 | O garçom/cozinha precisa ver o que está pendente | Sim: `vw_pedidos_abertos` |
| Produtos acima da média — Sprint 2 | Útil, mas é pontual | Não |

---

# 3. Criando uma VIEW

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

Uma View **não guarda dados**: guarda a consulta. Toda vez que é consultada, o MySQL executa o `SELECT` de novo sobre as tabelas.

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```text
vw_pedidos_detalhados
```

**Pergunta que ela representa:**

> Para cada pedido, quem é o cliente, quem atendeu e em qual mesa?

**SQL:**

```sql
-- VIEW 1: relacionamento (pedido + cliente + funcionario + mesa)
CREATE VIEW vw_pedidos_detalhados AS
SELECT p.id_pedido, p.data_pedido, p.status,
       c.nome AS cliente, f.nome AS atendente, m.numero AS mesa
FROM pedido AS p
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa;
```

**Tabelas utilizadas:**

> `pedido`, `cliente`, `funcionario` e `mesa`.

**Como consultar essa VIEW?**

```sql
SELECT * FROM vw_pedidos_detalhados ORDER BY id_pedido;
```

---

# 5. VIEW 2 — agregação ou resumo

**Pergunta:**

> Quantos pedidos e quanto cada cliente gastou?

```sql
-- VIEW 2: agregacao (total gasto por cliente)
CREATE VIEW vw_faturamento_por_cliente AS
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome;
```

**Explique:**

> Junta `cliente`, `pedido` e `item_pedido`; `COUNT(DISTINCT ...)` conta os pedidos e `SUM(quantidade * preco_unitario)` soma o consumo; `GROUP BY` agrupa por cliente.

---

# 6. VIEW 3 — consulta operacional do sistema

**Nome da VIEW:**

```text
vw_pedidos_abertos
```

```sql
-- VIEW 3: operacional (pedidos em aberto, o que a cozinha/garcom precisa ver)
CREATE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente
FROM pedido AS p
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
WHERE p.status = 'aberto';
```

**Por que essa VIEW é útil?**

> Mostra só o que ainda precisa de atenção (pedidos abertos), com a mesa, o cliente e o atendente. É o tipo de tela que a equipe do salão usaria o dia todo.

---

# 7. Consultando uma VIEW

**SQL executado:**

```sql
SELECT * FROM vw_pedidos_detalhados ORDER BY id_pedido;
SELECT * FROM vw_pedidos_detalhados WHERE cliente = 'Ana Souza';
SELECT * FROM vw_faturamento_por_cliente WHERE total_gasto > 100;
```

**Resultado observado:**

> A primeira retorna os 5 pedidos; a segunda só os pedidos 1 e 3 da Ana; a terceira Ana (161,70) e Mariana (149,00). A View se comporta como uma tabela: aceita `WHERE`, `ORDER BY` etc.

---

# 8. CREATE OR REPLACE VIEW

**VIEW original:**

```sql
-- VIEW 3: operacional (pedidos em aberto, o que a cozinha/garcom precisa ver)
CREATE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente
FROM pedido AS p
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
WHERE p.status = 'aberto';
```

**Nova versão:**

```sql
-- CREATE OR REPLACE VIEW: adiciona o total de cada pedido aberto
CREATE OR REPLACE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente,
       SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedido AS p
INNER JOIN mesa        AS m  ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c  ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f  ON p.id_funcionario = f.id_funcionario
INNER JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
WHERE p.status = 'aberto'
GROUP BY p.id_pedido, m.numero, c.nome, f.nome;
```

**O que mudou?**

> Entrou um `JOIN` com `item_pedido` e a coluna `total_pedido` (soma dos itens), com `GROUP BY`. O pedido 2 passou a aparecer com R$ 77,00, o 3 com 57,90, o 4 com 149,00 e o 5 com 29,00. O `OR REPLACE` troca a definição sem precisar apagar a View antes.

---

# 9. DROP VIEW — exercício controlado

**Código utilizado:**

```sql
-- VIEW TEMPORARIA + DROP VIEW
CREATE VIEW vw_teste AS
SELECT nome, preco FROM produto WHERE preco < 10;
```

```sql
DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> `DROP VIEW` apaga só a consulta guardada; as tabelas e os dados continuam intactos. `DROP TABLE` apaga a tabela e todos os dados dela.

---

# 10. Validando as Views

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. `vw_faturamento_por_cliente`
2. `vw_pedidos_abertos`
3. `vw_pedidos_detalhados`

(`vw_teste` não aparece porque foi removida com `DROP VIEW`.)

---

# 11. Teste de atualização dos dados-base

**VIEW testada:**

```text
vw_faturamento_por_cliente
```

**Alteração realizada:**

```sql
START TRANSACTION;
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (5, 2, 1, 68.50);
SELECT * FROM vw_faturamento_por_cliente WHERE cliente = 'Pedro Santos';
ROLLBACK;
```

**Resultado observado:**

> Antes, Pedro Santos tinha total_gasto = 29,00. Depois de inserir uma Picanha (68,50) no pedido 5, a mesma View passou a mostrar 97,50, sem ninguém alterar a View. Isso mostra que ela lê os dados atuais das tabelas. Usei `ROLLBACK` para desfazer o teste, e o total voltou para 29,00.

---

# 12. Validação prática obrigatória

```sql
-- VIEW 2: agregacao (total gasto por cliente)
CREATE VIEW vw_faturamento_por_cliente AS
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome;
```

1. **Tabelas:** `cliente`, `pedido`, `item_pedido`.
2. **Relacionamentos:** cliente 1:N pedido; pedido 1:N item_pedido.
3. **Campos:** `id_cliente`, `cliente`, `qtd_pedidos`, `total_gasto`.
4. **Problema que resolve:** dá o resumo de consumo por cliente com um simples `SELECT`, sem reescrever o `JOIN` e a soma.
5. **Se os dados mudarem:** a View muda junto, porque é calculada na hora (não guarda cópia).


---

# 13. Quantidade mínima exigida

| Exigência | Atendida |
|---|---|
| 3 Views úteis | `vw_pedidos_detalhados`, `vw_faturamento_por_cliente`, `vw_pedidos_abertos` |
| 1 View com relacionamento | `vw_pedidos_detalhados` |
| 1 View com agregação | `vw_faturamento_por_cliente` |
| 1 `CREATE OR REPLACE VIEW` | `vw_pedidos_abertos` (seção 8) |
| 1 teste com `DROP VIEW` | `vw_teste` (seção 9) |

---

# 14. Estrutura do SPRINT3-5.sql

Limpeza (`DROP VIEW IF EXISTS`), as 3 Views, consultas sobre as Views, `CREATE OR REPLACE VIEW`, View temporária e `DROP VIEW`, `SHOW FULL TABLES` e o teste de atualização dos dados-base. O script pode ser executado várias vezes.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro "View already exists" ao rodar de novo | `CREATE VIEW` não substitui | `DROP VIEW IF EXISTS` no início (ou `CREATE OR REPLACE`) |
| Teste de atualização deixaria o banco alterado | O `INSERT` é permanente | Usar `START TRANSACTION` + `ROLLBACK` |
| Erro 1055 na View de agregação | `ONLY_FULL_GROUP_BY` | Todas as colunas não agregadas no `GROUP BY` |


---

# 16. Uso de LLMs

Usei uma LLM como apoio. Li cada View, executei, conferi o resultado nos dados e consigo explicar de onde vem cada coluna.


---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei pelo menos 3 Views;
- [x] pelo menos uma View usa JOIN;
- [x] pelo menos uma View usa agregação ou resumo;
- [x] consultei as Views;
- [x] utilizei `CREATE OR REPLACE VIEW`;
- [x] pratiquei `DROP VIEW`;
- [x] validei as Views;
- [x] testei mudança em tabela base;
- [ ] compreendo de onde vêm os dados de cada View; <!-- marque depois de estudar -->
- [x] salvei `SPRINT3-5.md`;
- [x] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Branch `team-03`.

```text
Conclui Module 2 Sprint 3 de 5 - views
```
