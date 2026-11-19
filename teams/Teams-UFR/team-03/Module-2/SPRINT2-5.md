# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Resolver perguntas em que uma consulta depende do resultado de outra (subconsultas), no mesmo banco do `Module-1`.

---

# 1. Identificação

**Nome completo:**

> Gabriel Sakaizawa Campos

**Banco utilizado:**

```text
db_restaurante_sabor
```

---

# 2. O que é uma subconsulta?

É um `SELECT` dentro de outro comando SQL. A consulta interna roda primeiro e produz um valor (ou uma lista de valores); a consulta externa usa esse resultado. Exemplo: "produtos mais caros que a média" precisa primeiro calcular a média (interna) e depois comparar cada produto com ela (externa).

---

# 3. Perguntas que exigem subconsulta

1. Quais produtos custam mais que a média?
2. Quais clientes já fizeram pelo menos um pedido?
3. Quais mesas não tiveram nenhum pedido finalizado?
4. Quais funcionários nunca atenderam um pedido?
5. Qual é o produto mais caro do cardápio? E qual o pedido mais antigo?
6. Quais itens têm preço acima da média dos itens do mesmo pedido?

---

# 4. Subconsulta com comparação

**Pergunta:**

> Quais produtos custam mais que a média de preços?

```sql
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto)
ORDER BY preco DESC;
```

**Explique primeiro a consulta interna:**

> `SELECT AVG(preco) FROM produto` calcula a média dos 5 preços: R$ 28,18.

**Depois explique a consulta externa:**

> Mostra os produtos com `preco > 28,18`: Picanha na Chapa (68,50) e Feijoada Completa (45,90).

---

# 5. Subconsulta com IN

**Pergunta:**

> Quais clientes já fizeram algum pedido?

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (SELECT id_cliente FROM pedido)
ORDER BY nome;
```

**Explique:**

> A interna devolve a lista de `id_cliente` que aparecem em `pedido`. A externa mostra os clientes cujo id está nessa lista. Retornou os 4 clientes (Ana, Carlos, Mariana e Pedro).

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais mesas não tiveram nenhum pedido finalizado?

```sql
SELECT numero, capacidade, status
FROM mesa
WHERE id_mesa NOT IN (SELECT id_mesa FROM pedido WHERE status = 'finalizado')
ORDER BY numero;
```

**Que registros você está procurando?**

> Mesas cujo id não aparece na lista de mesas com pedido finalizado. Só o pedido 1 está finalizado (mesa 1), então o resultado é as mesas 2, 3, 4 e 5. O `NOT IN` é seguro aqui porque `pedido.id_mesa` é `NOT NULL` (um `NULL` na lista faria o `NOT IN` não retornar nada).

---

# 7. EXISTS

**Pergunta:**

> Quais mesas já receberam pelo menos um pedido?

```sql
SELECT m.numero, m.capacidade
FROM mesa AS m
WHERE EXISTS (SELECT 1 FROM pedido AS p WHERE p.id_mesa = m.id_mesa)
ORDER BY m.numero;
```

> Para cada mesa, o `EXISTS` pergunta "existe algum pedido com este `id_mesa`?". Retornou as 5 mesas.

---

# 8. NOT EXISTS

**Pergunta:**

> Quais funcionários não atenderam nenhum pedido?

```sql
SELECT f.nome, f.cargo
FROM funcionario AS f
WHERE NOT EXISTS (SELECT 1 FROM pedido AS p WHERE p.id_funcionario = f.id_funcionario);
```

**Explique a diferença em relação a `EXISTS`:**

> `EXISTS` mantém a linha se a subconsulta achar algo; `NOT EXISTS` mantém a linha se a subconsulta não achar nada. Retornou Fernanda Dias (Gerente).

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o produto mais caro? Qual(is) o(s) pedido(s) mais antigo(s)?

```sql
SELECT nome, preco
FROM produto
WHERE preco = (SELECT MAX(preco) FROM produto);
```

```sql
SELECT id_pedido, data_pedido, status
FROM pedido
WHERE data_pedido = (SELECT MIN(data_pedido) FROM pedido)
ORDER BY id_pedido;
```

**Explique:**

> A interna acha o maior preço (68,50) ou a menor data (2026-09-01); a externa traz o registro que tem esse valor. Resultado: Picanha na Chapa; pedidos 1 e 2 (empatados na data).

---

# 10. Subconsulta correlacionada

**Pergunta:**

> Quais itens têm preço unitário acima da média dos itens do mesmo pedido?

```sql
SELECT ip.id_pedido, pr.nome AS produto, ip.preco_unitario
FROM item_pedido AS ip
INNER JOIN produto AS pr ON pr.id_produto = ip.id_produto
WHERE ip.preco_unitario > (
    SELECT AVG(ip2.preco_unitario)
    FROM item_pedido AS ip2
    WHERE ip2.id_pedido = ip.id_pedido
)
ORDER BY ip.id_pedido;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> `ip.id_pedido`. A subconsulta é recalculada para cada linha externa, usando a média apenas dos itens daquele pedido (`ip2.id_pedido = ip.id_pedido`). Retornou o item mais caro de cada pedido: Feijoada (pedidos 1 e 3), Picanha (2 e 4) e Pudim (5).

---

# 11. Resolver a mesma pergunta de duas formas

## Pergunta 1

> Quais clientes já fizeram pedido?

### JOIN

```sql
SELECT DISTINCT c.nome
FROM cliente AS c
INNER JOIN pedido AS p ON c.id_cliente = p.id_cliente
ORDER BY c.nome;
```

### SUBQUERY

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (SELECT id_cliente FROM pedido)
ORDER BY nome;
```

### Qual abordagem ficou mais compreensível?

> A subconsulta, porque lê quase como a pergunta ("clientes cujo id está nos pedidos"). O `JOIN` precisa do `DISTINCT` para não repetir a Ana, que tem 2 pedidos. Os dois retornam os mesmos 4 clientes.

---

## Pergunta 2

> Quais funcionários não atenderam nenhum pedido?

### JOIN

```sql
SELECT f.nome
FROM funcionario AS f
LEFT JOIN pedido AS p ON f.id_funcionario = p.id_funcionario
WHERE p.id_pedido IS NULL;
```

### SUBQUERY

```sql
SELECT nome
FROM funcionario
WHERE id_funcionario NOT IN (SELECT id_funcionario FROM pedido);
```

### Comparação

> Ambas retornam a Fernanda Dias. O `LEFT JOIN ... IS NULL` procura as linhas sem correspondência; o `NOT IN` diz isso diretamente. Prefiro o `NOT IN` pela leitura, mas o `LEFT JOIN` é mais seguro se a coluna aceitar `NULL`.

---

# 12. Quantidade mínima exigida

| Exigência | Seção |
|---|---|
| subconsulta com comparação | 4 |
| `IN` | 5 |
| `NOT IN` | 6 |
| `EXISTS` | 7 |
| `NOT EXISTS` | 8 |
| `MAX` ou `MIN` | 9 (os dois) |
| subconsulta correlacionada | 10 |
| 2 problemas com JOIN e SUBQUERY | 11 |

---

# 13. Validação prática

```sql
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto)
ORDER BY preco DESC;
```

1. **Qual consulta é executada primeiro?** A interna, `SELECT AVG(preco) FROM produto`.
2. **O que ela retorna?** Um único valor: 28,18.
3. **Como a externa usa?** Compara o `preco` de cada produto com esse valor e mantém só os maiores.

---

# 14. Teste operacional no Workbench

**Consulta original:**

```sql
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto)
ORDER BY preco DESC;
```

**Alteração realizada:**

> Troquei a média geral pela média só da categoria "Bebida" (R$ 7,25): `WHERE categoria = 'Bebida'` dentro da subconsulta.

**Mudança observada:**

> Com a média mais baixa, mais produtos passam no filtro: de 2 para 4 (Feijoada, Picanha, Suco Natural e Pudim de Leite).

---

# 15. Problemas encontrados

A primeira a ser executada é a consulta interna, SELECT AVG(preco) FROM produto.
Ela devolve um único valor, a média dos preços: 28,18.
A consulta externa pega esse valor e compara com o preco de cada produto, mantendo só os que custam mais: Picanha na Chapa e Feijoada Completa.

---

# 16. Estrutura do SPRINT2-5.sql

Comparação, `IN`, `NOT IN`, `EXISTS`, `NOT EXISTS`, `MAX`/`MIN`, correlacionada, problema 1 (JOIN e SUBQUERY), problema 2 (JOIN e SUBQUERY) e o teste operacional.

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei subconsulta com comparação;
- [x] utilizei `IN`;
- [x] utilizei `NOT IN`;
- [x] utilizei `EXISTS`;
- [x] utilizei `NOT EXISTS`;
- [x] utilizei `MAX` ou `MIN`;
- [x] criei subconsulta correlacionada;
- [x] resolvi duas perguntas usando JOIN e SUBQUERY;
- [x] expliquei o raciocínio;
- [x] testei no MySQL;
- [x] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Branch `team-03`.

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```
