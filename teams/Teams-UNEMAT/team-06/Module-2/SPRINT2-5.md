# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Nesta etapa, cada aluno deverá aprofundar as consultas SQL por meio de **subconsultas**.

O objetivo é resolver perguntas em que uma consulta depende do resultado produzido por outra consulta.

Serão trabalhados:

```sql
SUBQUERY
IN
NOT IN
EXISTS
NOT EXISTS
AVG
MAX
MIN
COUNT
subconsulta correlacionada
```

O aluno deverá continuar utilizando o mesmo banco do `Module-1`.

---

# 1. Identificação

**Nome completo:**

> Mariano Lino da Silva Neto

**Banco utilizado:**

```
BD_Conveniencia
```

---

# 2. O que é uma subconsulta?

Uma subconsulta é um `SELECT` utilizado dentro de outro comando SQL.

Exemplo:

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

Neste exemplo:

1. a consulta interna calcula a média;
2. a consulta externa utiliza esse resultado.

---

# 3. Perguntas que exigem subconsulta

Defina pelo menos cinco perguntas do seu domínio que possam ser resolvidas com subconsultas.

1. Quais produtos custam mais do que o preço médio de todos os produtos cadastrados na conveniência?
2. Quais produtos do catalogo já foram comercializados em pelo menos um cupom fiscal?
3. Quais produtos do catálogo nunca saíram no caixa?
4. Quais categorias possuem ao menos um produto com valor de venda superior a R$20,00?
5. Qual é o produto mais caro cadastrado na loja de conveniência? 

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

>  Quais produtos custam mais do que o preço médio de todos os produtos cadastrados na conveniência?

```sql
SELECT 
nome_produto,
preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda)
FROM Produto
);
```

**Explique primeiro a consulta interna:**

> A subconsulta é executada primeiro para fazer uma varredura na tabela produto pra ai ela calcular a media aritmética de todos os preços cadastrados e depois retornar um valor numérico

**Depois explique a consulta externa:**

> e a consulta externa vai receber o valor numérico e vai utilizar como linha de corte no WHERE voltando apenas os produtos onde preco_venda seja maior que essa media calculada

---

# 5. Subconsulta com IN

Exemplo:

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedido
);
```

## Consulta obrigatória

**Pergunta:**

> Quais produtos do catalogo já foram comercializados em pelo menos um cupom fiscal?

```sql
SELECT
nome_produto,
preco_venda
FROM Produto
WHERE id_produto IN (
SELECT DISTINCT id_produto
FROM Item_venda
);
```

**Explique:**

> nesse caso a Sub vai criar uma lista contendo todos os id_produto que vão aparecer na tabela Item_venda e em sequencia ela a consulta externa vai verificar produto por produto da tabela Produto e se o id_produto estiver na lista ele vai ser exibido no resultado.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais produtos do catálogo nunca saíram no caixa?

```sql
SELECT
nome_produto,
preco_venda
FROM Produto
WHERE id_produto NOT IN (
SELECT distinct id_produto
FROM Item_venda
WHERE id_produto is NOT NULL
);
```

**Que registros você está procurando?**

> Estamos procurando produtos que não tem saido do estoque, itens que estão no cadastro da tabela produto mas não possuem nenhum registro na tabela Item_venda 

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais categorias possuem ao menos um produto com valor de venda superior a R$20,00?

```sql
SELECT
c.nome_categoria
FROM Categoria AS c
WHERE EXISTS (
SELECT 1
FROM Produto AS p
WHERE p.id_categoria = c.id_categoria
AND p.preco_venda > 20.00
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Qual é a categoria cadastrada no sistema que não possui nenhum produto associado a ele

```sql
SELECT
c.nome_categoria
FROM Categoria AS c
WHERE NOT EXISTS (
SELECT 1
FROM Produto AS p
WHERE p.id_categoria = c.id_categoria
);
```

**Explique a diferença em relação a `EXISTS`:**

> a diferença base acaba sendo que o EXISTS valida se a nossa consulta retornou pelo menos um registro, já no NOT ele basicamente valida se a consulta voltou um conjunto vazio pra gente.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o Produto de maior valor cadastrado na loja?

```sql
SELECT
nome_produto,
preco_venda
FROM Produto
WHERE preco_venda = (
SELECT MAX(preco_venda)
FROM Produto
);
```

**Explique:**

> a subconsulta descobre qual é valor maximo absoluto contido na coluna preco_venda do Produto e depois filtra esse valor pra descobrir qual o teto de preço.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais produtos tem o preço de venda superior a media de preços da sua propria categoria

```sql
SELECT
p1.nome_produto,
p1.preco_venda,
p1.id_categoria
FROM Produto as p1
WHERE p1.preco_venda > (
SELECT AVG(p2.preco_venda)
FROM Produto AS p2
WHERE p2.id_categoria = p1.id_categoria
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna p1.id_categoria.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN 
b) SUBQUERY
```

## Pergunta 1

> Quais são os produtos que pertecem a categoria salgados?

### JOIN

```sql
SELECT
p.nome_produto,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria = 'Salgados';
```

### SUBQUERY

```sql
SELECT 
nome_produto
FROM Produto
WHERE id_categoria IN (
SELECT id_categoria
FROM Categoria
WHERE nome_categoria = 'Salgados'
```

### Qual abordagem ficou mais compreensível?

> Em termos de complexidade acho que a SUBQUERY fica bem mais simples da pessoa fazer, fora que deixa o Layout bem mais limpo, mas se formos querer o maximo de informações possiveis, acho que a JOIN fica bem melhor, então vai variar bastante para oq você está precisando naquele momento.

---

## Pergunta 2

> Quais Produtos nunca foram Vendidos?

### JOIN

```sql
SELECT 
p.nome_produto
FROM Produto AS p
LEFT JOIN Item_venda AS iv
ON p.id_produto = iv.id_produto
WHERE iv.id_produto is NULL;
```

### SUBQUERY

```sql
SELECT
p.nome_produto
FROM Produto AS p
WHERE NOT EXISTS (
SELECT 1
FROM Item_venda AS iv
WHERE iv.id_produto = p.id_produto
);
```

### Comparação

> NOT EXISTS deixa mais expressivo a mostra das informações e a LEFT JOIN você precisa ter um pouco de conhecimento a mais pra poder usar pq tem um raciocínio que você precisa fazer na hora da junção. 

---

# 12. Quantidade mínima exigida

O `SPRINT2-5.sql` deverá conter no mínimo:

```text
1 subconsulta com comparação
1 subconsulta com IN
1 subconsulta com NOT IN
1 consulta com EXISTS
1 consulta com NOT EXISTS
1 subconsulta com MAX ou MIN
1 subconsulta correlacionada
2 problemas resolvidos com JOIN e SUBQUERY
```

---

# 13. Validação prática

Escolha uma subconsulta.

```sql
SELECT nome_produto, preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda)
FROM Produto
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1. A consulta interna: SELECT AVG(preco_venda) FROM Produto.
2. ele volta um conjunto de valores medio da cada produto, no caso 25, 15 e 22
3. Ela substitui o bloco da subconsulta pelo numero retornado e avalia a condição do WHERE para cada linha da tabela Produto, mostrando só quem tá acima dela. 

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT nome_produto, preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda) + 10.00 FROM Produto
);
```

**Alteração realizada:**

> Adicionamos mais 10 de valor medio na subconsulta

**Mudança observada:**

> Com essa mudança tivemos menos produtos aparecendo, visto que agora tivemos uma nota de corte bem maior do que na primeira tentativa.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```sql
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- SUBQUERY COM COMPARAÇÃO

-- IN

-- NOT IN

-- EXISTS

-- NOT EXISTS

-- MAX / MIN

-- SUBQUERY CORRELACIONADA

-- PROBLEMA 1 - JOIN

-- PROBLEMA 1 - SUBQUERY

-- PROBLEMA 2 - JOIN

-- PROBLEMA 2 - SUBQUERY
```

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei subconsulta com comparação;
- [x] utilizei `IN`;
- [x] utilizei `NOT IN`;
- [x] utilizei `EXISTS`;
- [x] utilizei `NOT EXISTS`;
- [X] utilizei `MAX` ou `MIN`;
- [x] criei subconsulta correlacionada;
- [X] resolvi duas perguntas usando JOIN e SUBQUERY;
- [x] expliquei o raciocínio;
- [x] testei no MySQL Workbench;
- [x] consigo explicar as consultas presencialmente;
- [X] salvei `SPRINT2-5.md`;
- [X] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

**Não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 3/5 serão trabalhadas:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT em VIEW
DROP VIEW
```
