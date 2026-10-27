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

> Vinícius Eduardo Lima de Assis.

**Banco utilizado:**

```text
pacote_viagens
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

1. Quais hospedagens possuem diária acima da média de todas as hospedagens cadastradas?
2. Quais clientes já realizaram ao menos uma reserva no sistema?
3. Quais clientes ainda não realizaram nenhuma reserva de pacote?
4. Quais destinos possuem hospedagens vinculadas a eles?
5. Qual é a hospedagem com a diária mais cara do sistema?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais hospedagens possuem o valor da diária superior à média geral de diárias de todas as hospedagens do sistema?

```sql
-- SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);
```

**Explique primeiro a consulta interna:**

> A subconsulta (SELECT AVG(valor_diaria) FROM hospedagem) calcula a média aritmética de todas as diárias cadastradas na tabela hospedagem.

**Depois explique a consulta externa:**

> A consulta externa seleciona o nome, o tipo e o valor da diária das hospedagens cujo valor_diaria seja estritamente maior do que o valor médio calculado pela subconsulta.

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

> Quais clientes possuem pelo menos uma reserva efetuada?

```sql
-- SELECT 
    id_cliente,
    nome,
    email
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM reserva_pacote
);
```

**Explique:**

> A subconsulta gera uma lista contendo todos os id_cliente presentes na tabela reserva_pacote. A consulta externa filtra e retorna apenas os clientes cujo ID esteja contido (IN) nessa lista.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais clientes cadastrados ainda não efetuaram nenhuma reserva no sistema?

```sql
-- SELECT 
    id_cliente,
    nome,
    email
FROM cliente
WHERE id_cliente NOT IN (
    SELECT DISTINCT id_cliente
    FROM reserva_pacote
);
```

**Que registros você está procurando?**

> Registros da tabela cliente que não possuem nenhuma referência correspondente na tabela de reservas (reserva_pacote), permitindo identificar clientes inativos em termos de compras.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais destinos possuem pelo menos uma hospedagem vinculada a eles?

```sql
-- SELECT 
    d.id_destino,
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE EXISTS (
    SELECT 1
    FROM hospedagem AS h
    WHERE h.id_destino = d.id_destino
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais destinos cadastrados ainda não possuem nenhuma hospedagem vinculada?

```sql
-- SELECT 
    d.id_destino,
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM hospedagem AS h
    WHERE h.id_destino = d.id_destino
);
```

**Explique a diferença em relação a `EXISTS`:**

> Enquanto o EXISTS verifica a presença de pelo menos uma linha correspondente na subconsulta e retorna o registro caso encontre, o NOT EXISTS inverte a lógica: só retorna o registro da consulta externa se a subconsulta retornar um conjunto vazio de linhas.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual hospedagem possuem o maior valor de diária do sistema?

```sql
-- SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria = (
    SELECT MAX(valor_diaria)
    FROM hospedagem
);
```

**Explique:**

> A subconsulta obtém o valor máximo (MAX) armazenado na coluna valor_diaria. A consulta externa seleciona as hospedagens que possuem exatamente esse valor máximo.
---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais hospedagens possuem valor de diária acima da média de diárias do seu próprio tipo/categoria?

```sql
-- SELECT 
    h1.nome,
    h1.tipo,
    h1.valor_diaria
FROM hospedagem AS h1
WHERE h1.valor_diaria > (
    SELECT AVG(h2.valor_diaria)
    FROM hospedagem AS h2
    WHERE h2.tipo = h1.tipo
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna h1.tipo da tabela na consulta externa é referenciada na cláusula WHERE h2.tipo = h1.tipo dentro da subconsulta.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais clientes possuem reservas ativas cadastradas?

### JOIN

```sql
-- SELECT DISTINCT
    c.id_cliente,
    c.nome,
    c.email
FROM cliente AS c
INNER JOIN reserva_pacote AS r ON c.id_cliente = r.id_cliente;
```

### SUBQUERY

```sql
-- SELECT 
    c.id_cliente,
    c.nome,
    c.email
FROM cliente AS c
WHERE c.id_cliente IN (
    SELECT r.id_cliente 
    FROM reserva_pacote AS r
);
```

### Qual abordagem ficou mais compreensível?

> A abordagem por SUBQUERY com IN ficou mais compreensível. Ela expressa a intenção do negócio de forma direta ("selecione os clientes onde o ID esteja na lista de reservas") e elimina a necessidade de tratar duplicatas com a cláusula DISTINCT, que é necessária na abordagem com JOIN.
---

## Pergunta 2

> Quais são os nomes dos destinos onde há reservas efetuadas?

### JOIN

```sql
-- SELECT DISTINCT
    d.nome AS destino,
    d.pais
FROM destino AS d
INNER JOIN hospedagem AS h ON d.id_destino = h.id_destino
INNER JOIN reserva_pacote AS r ON h.id_hospedagem = r.id_hospedagem;
```

### SUBQUERY

```sql
-- SELECT 
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE d.id_destino IN (
    SELECT h.id_destino
    FROM hospedagem AS h
    WHERE h.id_hospedagem IN (
        SELECT r.id_hospedagem
        FROM reserva_pacote AS r
    )
);
```

### Comparação

> Neste caso, a abordagem com JOIN é nitidamente mais limpa e de fácil leitura do que a subconsulta aninhada em múltiplos níveis. O JOIN permite conectar as entidades em uma sequência direta de relacionamentos relacional (destino -> hospedagem -> reserva_pacote).

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
-- SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1)A subconsulta interna (SELECT AVG(valor_diaria) FROM hospedagem);
> 2)Ela retorna um único valor escalar com a média de todas as diárias (exemplo: 1320.00);
> 3)O valor retornado é comparado pela consulta externa usando o operador >, filtrando apenas as linhas da tabela hospedagem cuja coluna valor_diaria possua valor numérico superior ao resultado retornado.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
-- SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);
```

**Alteração realizada:**

> Substituição do operador de comparação > por < para consultar as diárias abaixo da média.

**Mudança observada:**

> A consulta passou a retornar as hospedagens de menor valor do catálogo (ex: 'Fera Palace Hotel' e 'Hotel Colline de France'), invertendo o conjunto de resultados originalmente obtido.

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
