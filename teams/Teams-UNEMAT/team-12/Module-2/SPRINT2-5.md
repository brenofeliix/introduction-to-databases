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

> João Guilherme Barros de Lima

**Banco utilizado:**

```text
real_estate_database
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

1. Quais imóveis têm valor acima da média de valor de todos os imóveis cadastrados?
2. Quais clientes já realizaram algum agendamento de visita?
3. Quais clientes nunca agendaram nenhuma visita?
4. Quais imóveis possuem pelo menos um agendamento registrado?
5. Qual é o imóvel mais caro cadastrado no sistema?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais imóveis têm valor acima da média de valor de todos os imóveis cadastrados?

```sql
SELECT titulo, valor
FROM imovel
WHERE valor > (
    SELECT AVG(valor)
    FROM imovel
);
```

**Explique primeiro a consulta interna:**

> A consulta interna (SELECT AVG(valor) FROM imovel) calcula a média de valor considerando todos os imóveis da tabela, sem nenhum filtro. Com os dados atuais, essa média é 448.000,00.

**Depois explique a consulta externa:**

> A consulta externa utiliza esse valor único retornado pela subconsulta como limite de comparação no WHERE, trazendo apenas os imóveis cujo valor é maior que essa média. Como a subconsulta retorna um único valor (um escalar), ela pode ser usada diretamente com o operador >.

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

> Quais clientes já realizaram algum agendamento de visita?

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);
```

**Explique:**

> A subconsulta retorna o conjunto de todos os id_cliente que aparecem na tabela agendamento (podendo haver repetição, já que um cliente pode ter mais de um agendamento). O IN verifica, para cada cliente, se o seu id_cliente está presente nesse conjunto de valores. Diferente do operador =, o IN permite comparar com uma lista de vários resultados, não apenas um único valor.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais clientes nunca agendaram nenhuma visita?

```sql
SELECT nome
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM agendamento
);
```

**Que registros você está procurando?**

> Estou procurando os clientes cujo id_cliente não aparece em nenhuma linha da tabela agendamento — ou seja, clientes cadastrados no sistema que nunca marcaram uma visita. Com os dados atuais, apenas a cliente Mariana Silva se encaixa nessa condição.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais imóveis possuem pelo menos um agendamento registrado?

```sql
SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais imóveis nunca receberam nenhum agendamento de visita?

```sql
SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
```

**Explique a diferença em relação a `EXISTS`:**

> O EXISTS retorna verdadeiro quando a subconsulta encontra pelo menos uma linha correspondente, trazendo os imóveis que têm agendamento. O NOT EXISTS é exatamente o inverso: retorna verdadeiro quando a subconsulta não encontra nenhuma linha correspondente, trazendo os imóveis que nunca foram agendados — no caso atual, apenas o "Terreno amplo".

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o imóvel mais caro cadastrado no sistema?

```sql
SELECT titulo, valor
FROM imovel
WHERE valor = (
    SELECT MAX(valor)
    FROM imovel
);
```

**Explique:**

> A subconsulta (SELECT MAX(valor) FROM imovel) retorna um único valor: o maior valor encontrado entre todos os imóveis cadastrados. A consulta externa compara o valor de cada imóvel a esse número e retorna apenas o imóvel (ou imóveis, em caso de empate) cujo valor é igual ao máximo. Com os dados atuais, o resultado é "Casa na praia", no valor de R$ 800.000,00.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais imóveis têm valor acima da média de valor dos imóveis do mesmo corretor?

```sql
SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna i.id_corretor, da consulta externa, é usada dentro da subconsulta (i2.id_corretor = i.id_corretor). Isso faz com que a subconsulta seja recalculada para cada imóvel analisado, considerando apenas os imóveis pertencentes ao mesmo corretor daquele imóvel específico — e não a média geral de todos os imóveis do banco. Com os dados atuais, apenas o imóvel "Casa com piscina" atende à condição, pois seu corretor (que também anuncia o "Terreno amplo") tem uma média de R$ 300.000,00 entre seus dois imóveis.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais clientes já realizaram algum agendamento de visita?

### JOIN

```sql
SELECT DISTINCT cl.nome
FROM cliente AS cl
INNER JOIN agendamento AS a
    ON cl.id_cliente = a.id_cliente;
```

### SUBQUERY

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);
```

### Qual abordagem ficou mais compreensível?

> A versão com SUBQUERY ficou mais direta para essa pergunta específica. Como alguns clientes possuem mais de um agendamento (ex: o cliente de id 1 tem dois), a versão com JOIN precisa do DISTINCT para não repetir o mesmo nome várias vezes — sem o DISTINCT, o resultado viria com linhas duplicadas. A SUBQUERY com IN já resolve isso naturalmente, porque a subconsulta apenas verifica pertencimento a um conjunto, sem gerar combinação de linhas.

---

## Pergunta 2

> Quais imóveis possuem pelo menos um agendamento registrado?

### JOIN

```sql
SELECT DISTINCT i.titulo
FROM imovel AS i
INNER JOIN agendamento AS a
    ON i.id_imovel = a.id_imovel;
```

### SUBQUERY

```sql
SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
```

### Comparação

> As duas consultas retornam exatamente o mesmo resultado. A diferença está na lógica: o JOIN combina as linhas das duas tabelas e depois precisa do DISTINCT para remover duplicatas (já que o imóvel de id 3 tem dois agendamentos). O EXISTS nunca duplica linhas, porque ele apenas verifica "existe ou não existe correspondência" para cada imóvel, sem multiplicar as linhas pela quantidade de agendamentos. Para esse tipo de pergunta ("existe pelo menos um"), o EXISTS expressa a intenção da pergunta de forma mais fiel do que o JOIN + DISTINCT.

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
SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1. Por ser uma subconsulta correlacionada, ela não é executada uma única vez antes da consulta externa. Em vez disso, o MySQL percorre cada linha da tabela imovel (consulta externa) e, para cada uma delas, executa a subconsulta interna usando o id_corretor daquela linha específica.
> 2. Para cada execução, a subconsulta retorna um único valor: a média de valor dos imóveis que pertencem ao mesmo corretor do imóvel da linha atual.
> 3. Esse valor é usado imediatamente pela cláusula WHERE da consulta externa (i.valor > ...) para decidir se aquela linha específica entra ou não no resultado final. Como o cálculo depende da linha atual, o resultado da subconsulta pode ser diferente para cada imóvel analisado.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT titulo, valor
FROM imovel
WHERE valor = (
    SELECT MAX(valor)
    FROM imovel
);
```

**Alteração realizada:**

> Troquei a função MAX por MIN dentro da subconsulta, para buscar o imóvel mais barato em vez do mais caro:
>
> ```sql
> SELECT titulo, valor
> FROM imovel
> WHERE valor = (
>     SELECT MIN(valor)
>     FROM imovel
> );
> ```

**Mudança observada:**

> O resultado deixou de ser "Casa na praia" (R$ 800.000,00, o maior valor) e passou a ser "Terreno amplo" (R$ 150.000,00, o menor valor). Isso confirma, na prática, que é a subconsulta que define o valor-limite usado pela consulta externa — a estrutura da consulta não mudou, apenas a função de agregação usada internamente.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro "Subquery returns more than 1 row" ao tentar usar `= (SELECT id_cliente FROM agendamento)` | Tentativa de comparar um único valor (`=`) com uma subconsulta que retorna várias linhas | Substituído o operador `=` por `IN`, que aceita um conjunto de valores |
| Resultado com nomes de clientes repetidos ao resolver a pergunta 1 da seção 11 usando JOIN | Clientes com mais de um agendamento (ex: id_cliente 1) geravam uma linha duplicada para cada agendamento no INNER JOIN | Adicionado `DISTINCT` na consulta com JOIN para eliminar as repetições |

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```sql
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- SUBQUERY COM COMPARAÇÃO
SELECT titulo, valor
FROM imovel
WHERE valor > (
    SELECT AVG(valor)
    FROM imovel
);

-- IN
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);

-- NOT IN
SELECT nome
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM agendamento
);

-- EXISTS
SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);

-- NOT EXISTS
SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);

-- MAX / MIN
SELECT titulo, valor
FROM imovel
WHERE valor = (
    SELECT MAX(valor)
    FROM imovel
);

-- SUBQUERY CORRELACIONADA
SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);

-- PROBLEMA 1 - JOIN
SELECT DISTINCT cl.nome
FROM cliente AS cl
INNER JOIN agendamento AS a
    ON cl.id_cliente = a.id_cliente;

-- PROBLEMA 1 - SUBQUERY
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);

-- PROBLEMA 2 - JOIN
SELECT DISTINCT i.titulo
FROM imovel AS i
INNER JOIN agendamento AS a
    ON i.id_imovel = a.id_imovel;

-- PROBLEMA 2 - SUBQUERY
SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
```

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
- [x] testei no MySQL Workbench;
- [x] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.

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
