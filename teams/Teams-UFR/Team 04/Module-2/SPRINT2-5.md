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

> Escreva aqui.

**Banco utilizado:**

```text

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

1. 
2. 
3. 
4. 
5. 

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique primeiro a consulta interna:**

> Escreva aqui.

**Depois explique a consulta externa:**

> Escreva aqui.

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

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Que registros você está procurando?**

> Escreva aqui.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

---

# 8. NOT EXISTS

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique a diferença em relação a `EXISTS`:**

> Escreva aqui.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> Escreva aqui.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Escreva aqui.

### JOIN

```sql
-- Cole aqui.
```

### SUBQUERY

```sql
-- Cole aqui.
```

### Qual abordagem ficou mais compreensível?

> Escreva aqui e justifique.

---

## Pergunta 2

> Escreva aqui.

### JOIN

```sql
-- Cole aqui.
```

### SUBQUERY

```sql
-- Cole aqui.
```

### Comparação

> Escreva aqui.

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
-- Cole aqui.
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> Escreva aqui.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
-- Cole aqui.
```

**Alteração realizada:**

> Escreva aqui.

**Mudança observada:**

> Escreva aqui.

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
