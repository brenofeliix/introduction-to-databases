
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

> Anna Beatriz Oliveira Moura

**Branch:**

```text
team-06
```

**Nome do banco:**

```text
Locação de Filmes
```

**Tema do projeto:**

> Locadora.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | cliente | id_cliente | — |
| 2 | funcionario | id_funcionario | — |
| 3 | genero | id_genero | — |
| 4 | filme | id_filme | id_genero |
| 5 | locacao | id_locacao | id_cliente, id_funcionario |
| 6 | item_locacao | id_item_locacao | id_locacao, id_filme |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| genero | 1:N | filme | filme.id_genero |
| cliente | 1:N | locacao | locacao.id_cliente |
| funcionario | 1:N | locacao | locacao.id_funcionario |
| locacao | 1:N | item_locacao | item_locacao.id_locacao |
| filme | 1:N | item_locacao | item_locacao.id_filme |

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

> Quais filmes estão cadastrados e a qual gênero cada um pertence?

**Tabelas utilizadas:**

```text
filme
genero
```

**PK/FK utilizadas:**

```text
filme.id_genero → genero.id_genero
```

**SQL:**

```sql
SELECT
    f.titulo AS filme,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

**Explique o resultado:**

> A consulta relaciona as tabelas filme e genero por meio do campo id_genero. O INNER JOIN apresenta somente os registros que possuem correspondência entre as duas tabelas, permitindo visualizar o título de cada filme juntamente com seu respectivo gênero.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais clientes realizaram locações e em quais datas elas ocorreram?

```sql
SELECT
    c.nome AS cliente,
    l.id_locacao,
    l.data_locacao,
    l.data_devolucao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente;
```

**Explique:**

> A consulta relaciona os clientes às locações realizadas por meio do id_cliente. O resultado apresenta somente clientes que possuem uma locação correspondente, mostrando também o identificador e as datas de cada locação.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais funcionários estão cadastrados e quantas locações cada um registrou, incluindo funcionários sem locações?

```sql
SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> O LEFT JOIN permite visualizar todos os funcionários cadastrados, inclusive aqueles que não possuem nenhuma locação registrada. Quando não há correspondência na tabela locacao, a função COUNT(l.id_locacao) retorna zero para esse funcionário.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais funcionários estão cadastrados e quais locações foram registradas por eles, incluindo funcionários que não registraram locações?

```sql
SELECT
    f.nome AS funcionario,
    l.id_locacao,
    l.data_locacao
FROM locacao AS l
RIGHT JOIN funcionario AS f
    ON l.id_funcionario = f.id_funcionario
ORDER BY f.nome;
```

**Explique o resultado:**

> O RIGHT JOIN mantém todos os registros da tabela funcionario, que está à direita da junção. Assim, funcionários que ainda não registraram locações também aparecem no resultado, apresentando valores NULL nos campos provenientes da tabela locacao.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Quais clientes alugaram quais filmes?

```sql
SELECT
    c.nome AS cliente,
    f.titulo AS filme,
    l.data_locacao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS f
    ON i.id_filme = f.id_filme;
```

## Consulta 2

**Pergunta:**

> Quais funcionários registraram as locações e para quais clientes?

```sql
SELECT
    l.id_locacao,
    f.nome AS funcionario,
    c.nome AS cliente,
    l.data_locacao
FROM locacao AS l
INNER JOIN funcionario AS f
    ON l.id_funcionario = f.id_funcionario
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais clientes alugaram filmes com avaliação igual ou superior a 7,0?

```sql
SELECT
    c.nome AS cliente,
    f.titulo AS filme,
    f.avaliacao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS f
    ON i.id_filme = f.id_filme
WHERE f.avaliacao >= 7.0;
```

**Explique o filtro:**

> O WHERE foi utilizado após os relacionamentos para manter no resultado somente os filmes cuja avaliação seja igual ou superior a 7,0. Assim, clientes que alugaram filmes com avaliações inferiores a esse valor não aparecem nessa consulta.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais filmes foram alugados, apresentados da maior para a menor avaliação?

```sql
SELECT
    f.titulo AS filme,
    g.nome AS genero,
    f.avaliacao
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero
INNER JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
ORDER BY f.avaliacao DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Quantas locações cada funcionário registrou?

```sql
SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome
ORDER BY quantidade_locacoes DESC;
```

**Explique o agrupamento:**

> O GROUP BY agrupa os registros de acordo com cada funcionário. Em seguida, COUNT(l.id_locacao) calcula quantas locações foram registradas por cada um. O LEFT JOIN permite que funcionários que ainda não registraram nenhuma locação também sejam apresentados, com quantidade igual a zero.

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

> Quais clientes alugaram quais filmes, em quais datas e qual funcionário registrou a locação?

```sql
SELECT
    l.id_locacao,
    c.nome AS cliente,
    fi.titulo AS filme,
    fun.nome AS funcionario,
    l.data_locacao,
    l.data_devolucao
FROM locacao AS l
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
INNER JOIN funcionario AS fun
    ON l.id_funcionario = fun.id_funcionario
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS fi
    ON i.id_filme = fi.id_filme
ORDER BY l.id_locacao;
```

**Por que ela é útil?**

> Essa consulta é útil porque reúne em um único resultado as principais informações de uma operação da locadora: o cliente responsável, o filme alugado, o funcionário que registrou a operação e as datas da locação e devolução. Dessa forma, permite visualizar o histórico das locações de maneira mais completa.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT
    f.titulo AS filme,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> A consulta utiliza as tabelas filme e genero. A chave primária utilizada no relacionamento é genero.id_genero, enquanto a chave estrangeira é filme.id_genero. A cláusula `ON` determina como os registros das duas tabelas devem ser relacionados. Nesse caso, o MySQL compara o valor de filme.id_genero com genero.id_genero. Quando os valores correspondem, é possível apresentar na mesma linha o título do filme e o nome de seu gênero. Caso a condição de relacionamento estivesse incorreta, os registros poderiam ser associados de maneira errada, apresentar resultados sem significado ou não retornar as correspondências esperadas.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT
    f.titulo AS filme,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

**Resultado esperado:**

> Apresentar os filmes cadastrados juntamente com os gêneros aos quais pertencem.

**Resultado obtido:**

> A consulta foi executada corretamente no MySQL Workbench e apresentou os filmes cadastrados juntamente com seus respectivos gêneros.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Não foram encontrados problemas. | -- | -- |
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
