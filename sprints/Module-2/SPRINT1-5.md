# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Nesta primeira Sprint do **Module-2**, cada aluno deverá continuar utilizando o mesmo banco de dados desenvolvido no `Module-1`.

O foco agora será a consulta de dados relacionados entre duas ou mais tabelas por meio de:

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
ON
AS
WHERE
ORDER BY
GROUP BY
COUNT
SUM
AVG
MIN
MAX
```

Ao final da Sprint, o aluno deverá ser capaz de identificar as tabelas necessárias, reconhecer PK e FK envolvidas, construir consultas com `JOIN`, interpretar os resultados e explicar presencialmente como cada consulta funciona.

> **Importante:** não crie um novo banco. Utilize o mesmo projeto desenvolvido no `Module-1`.

---

# 1. Estrutura do repositório

Os arquivos desta Sprint deverão ficar em:

```text
teams/Teams-UNEMAT/team-XX/Module-2/
```

Ao final:

```text
Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Não altere nem apague os arquivos do `Module-1`.

---

# 2. Identificação

**Nome completo:**

> Raquel Silva dos Santos

**Branch:**

```text
team-01
```

**Nome do banco:**

```text

series_watchlist_db

```

**Tema do projeto:**

> Sistema de Catálogo de Séries e Gerenciamento de Watchlist com Avaliações de Usuários.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | plataforma | id_plataforma | Nenhuma |
| 2 | usuario | id_usuario | Nenhuma |
| 3 | serie | id_serie | id_plataforma (referencia plataforma.id_plataforma) |
| 4 | item_watchlist | (id_usuario, id_serie) | id_usuario (referencia usuario.id_usuario), id_serie (referencia serie.id_serie) |
| 5 |  |  |  |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| plataforma | 1:N | serie | serie.id_plataforma |
| usuario | 1:N | item_watchlist | item_watchlist.id_usuario |
| serie | 1:N | item_watchlist | item_watchlist.id_serie |
| usuario | N:N | serie | Implementada por meio da associativa item_watchlist |

---

# 5. INNER JOIN

O `INNER JOIN` retorna registros que possuem correspondência nas tabelas relacionadas.

Exemplo genérico:

```sql
SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
```

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Escreva aqui.

**Tabelas utilizadas:**

```text

```

**PK/FK utilizadas:**

```text

```

**SQL:**

```sql
-- Cole aqui.
```

**Explique o resultado:**

> Escreva aqui.

## Consulta INNER JOIN 2

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Escreva aqui.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique o resultado:**

> Escreva aqui.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

## Consulta 2

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique o filtro:**

> Escreva aqui.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique o agrupamento:**

> Escreva aqui.

---

# 12. Quantidade mínima exigida

O `SPRINT1-5.sql` deverá conter, no mínimo:

```text
2 INNER JOIN
1 LEFT JOIN
1 RIGHT JOIN
2 consultas envolvendo 3 ou mais tabelas
1 JOIN + WHERE
1 JOIN + ORDER BY
1 JOIN + GROUP BY + agregação
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Consulta mais útil

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Por que ela é útil?**

> Escreva aqui.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
-- Cole aqui.
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Escreva aqui.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- Cole aqui.
```

**Resultado esperado:**

> Escreva aqui.

**Resultado obtido:**

> Escreva aqui.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 17. Uso de LLMs

LLMs podem ser utilizadas como apoio, mas todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno deverá ser capaz de explicar presencialmente qualquer consulta entregue.

---

# 18. Estrutura recomendada do SPRINT1-5.sql

```sql
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- INNER JOIN 1

-- INNER JOIN 2

-- LEFT JOIN

-- RIGHT JOIN

-- JOIN COM 3+ TABELAS 1

-- JOIN COM 3+ TABELAS 2

-- JOIN + WHERE

-- JOIN + ORDER BY

-- JOIN + GROUP BY + AGREGAÇÃO
```

---

# 19. Checklist

- [ ] utilizei o mesmo banco do Module-1;
- [ ] identifiquei PKs e FKs;
- [ ] produzi 2 `INNER JOIN`;
- [ ] produzi 1 `LEFT JOIN`;
- [ ] produzi 1 `RIGHT JOIN`;
- [ ] produzi consultas com 3 ou mais tabelas;
- [ ] utilizei `WHERE`;
- [ ] utilizei `ORDER BY`;
- [ ] utilizei agregação e `GROUP BY`;
- [ ] as consultas respondem perguntas reais;
- [ ] testei tudo no MySQL Workbench;
- [ ] consigo explicar as consultas;
- [ ] salvei `SPRINT1-5.md`;
- [ ] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos do commit:

```text
Module-2/SPRINT1-5.md
Module-2/SPRINT1-5.sql
```

Mensagem sugerida:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```

**Não abra o Pull Request final nesta Sprint.**

---

# Próxima etapa

Na Sprint 2/5 serão trabalhadas subconsultas:

```sql
IN
NOT IN
EXISTS
NOT EXISTS
subconsultas correlacionadas
```
