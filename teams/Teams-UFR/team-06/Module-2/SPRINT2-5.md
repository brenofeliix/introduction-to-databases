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

> Anna Beatriz Oliveira Moura

**Banco utilizado:**

```text
Locação de Filmes
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

1. Quais filmes possuem avaliação acima da média dos filmes cadastrados?
2. Quais clientes já realizaram pelo menos uma locação?
3. Quais funcionários não registraram nenhuma locação?
4. Qual filme possui a maior avaliação cadastrada?
5. Quais funcionários registraram mais de uma locação?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais filmes possuem avaliação acima da média dos filmes cadastrados?

```sql
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao > (
    SELECT AVG(avaliacao)
    FROM filme
);
```

**Explique primeiro a consulta interna:**

> A subconsulta calcula a média das avaliações de todos os filmes cadastrados.

**Depois explique a consulta externa:**

> A consulta externa compara a avaliação de cada filme com a média obtida pela subconsulta e apresenta apenas os filmes cuja avaliação é superior a esse valor.

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

> Quais clientes já realizaram pelo menos uma locação?

```sql
SELECT
    id_cliente,
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM locacao
);
```

**Explique:**

> A subconsulta retorna os identificadores dos clientes que possuem locações registradas. A consulta externa utiliza IN para exibir somente os clientes cujos identificadores aparecem nesse conjunto.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais funcionários não registraram nenhuma locação?

```sql
SELECT
    id_funcionario,
    nome
FROM funcionario
WHERE id_funcionario NOT IN (
    SELECT id_funcionario
    FROM locacao
);
```

**Que registros você está procurando?**

> A consulta procura funcionários cadastrados cujo identificador não aparece em nenhum registro da tabela locacao, ou seja, funcionários que ainda não registraram nenhuma locação.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais clientes possuem pelo menos uma locação cadastrada?

```sql
SELECT
    c.id_cliente,
    c.nome
FROM cliente AS c
WHERE EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_cliente = c.id_cliente
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais funcionários não possuem nenhuma locação registrada?

```sql
SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
);
```

**Explique a diferença em relação a `EXISTS`:**

> EXISTS retorna o registro da consulta externa quando existe pelo menos uma correspondência na subconsulta. NOT EXISTS faz o contrário: retorna o registro quando nenhuma correspondência é encontrada.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual filme possui a maior avaliação cadastrada?

```sql
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao = (
    SELECT MAX(avaliacao)
    FROM filme
);
```

**Explique:**

> A subconsulta calcula a maior avaliação existente na tabela filme. A consulta externa procura todos os filmes cuja avaliação seja igual ao valor máximo encontrado.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais funcionários registraram mais de uma locação?

```sql
SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE (
    SELECT COUNT(*)
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
) > 1;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A subconsulta utiliza a coluna f.id_funcionario da consulta externa. Para cada funcionário analisado, a subconsulta compara esse identificador com l.id_funcionario na tabela locacao e contabiliza quantas locações foram registradas por ele. Como a subconsulta depende do funcionário que está sendo analisado pela consulta externa, ela é classificada como uma subconsulta correlacionada.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais clientes já realizaram locações?

### JOIN

```sql
SELECT DISTINCT
    c.id_cliente,
    c.nome
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente;
```

### SUBQUERY

```sql
SELECT
    id_cliente,
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM locacao
);
```

### Qual abordagem ficou mais compreensível?

> A subconsulta com IN ficou mais direta para essa pergunta, pois permite interpretar a lógica como “mostrar os clientes cujo identificador está entre os identificadores presentes nas locações”. O JOIN também resolve corretamente, mas exige compreender primeiro o relacionamento entre as duas tabelas.

---

## Pergunta 2

> Quais funcionários não registraram nenhuma locação?

### JOIN

```sql
SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
WHERE l.id_locacao IS NULL;
```

### SUBQUERY

```sql
SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
);
```

### Comparação

> As duas consultas produzem o mesmo objetivo. Com LEFT JOIN, os funcionários sem correspondência em locacao ficam com valores NULL, permitindo filtrar esses registros. Com NOT EXISTS, a consulta expressa diretamente a condição de não existir nenhuma locação relacionada ao funcionário. Neste caso, NOT EXISTS torna a intenção da consulta mais clara.

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
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao > (
    SELECT AVG(avaliacao)
    FROM filme
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> A subconsulta interna SELECT AVG(avaliacao) FROM filme. Ela retorna um único valor correspondente à média das avaliações dos filmes cadastrados. A consulta externa compara a avaliação de cada filme com a média obtida e apresenta apenas aqueles cuja avaliação é superior à média.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao > (
    SELECT AVG(avaliacao)
    FROM filme
);
```

**Alteração realizada:**

> Foi alterado > por <.

**Mudança observada:**

> Ao substituir > por <, a consulta deixou de mostrar os filmes com avaliação acima da média e passou a apresentar os filmes com avaliação abaixo da média.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Não foram encontrados nenhum problema. | -- | -- |
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

- [ ] utilizei o banco do projeto;
- [ ] criei subconsulta com comparação;
- [ ] utilizei `IN`;
- [ ] utilizei `NOT IN`;
- [ ] utilizei `EXISTS`;
- [ ] utilizei `NOT EXISTS`;
- [ ] utilizei `MAX` ou `MIN`;
- [ ] criei subconsulta correlacionada;
- [ ] resolvi duas perguntas usando JOIN e SUBQUERY;
- [ ] expliquei o raciocínio;
- [ ] testei no MySQL Workbench;
- [ ] consigo explicar as consultas presencialmente;
- [ ] salvei `SPRINT2-5.md`;
- [ ] salvei `SPRINT2-5.sql`.

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
