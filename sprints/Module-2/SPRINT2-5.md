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

> Marcos Aurélio Bastos Stanguerlin

**Banco utilizado:**

```text
Rh Sorveteria
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

1. Quais funcionários ocupam cargos de Caixa ou Atendente?
2. Quais funcionários recebem salário-base acima da média dos salários cadastrados?
3. Qual filial possui a maior quantidade de funcionários?
4. Qual é o maior salário-base cadastrado e quais cargos recebem esse valor?
5. Quais funcionários não possuem expediente cadastrado?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais funcionários recebem salário-base acima da média dos salários cadastrados?

```sql
SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base)
    FROM CARGO
)
ORDER BY c.salario_base DESC;
```

**Explique primeiro a consulta interna:**

A consulta interna calcula a média dos salários-base cadastrados na tabela `CARGO`.

**Depois explique a consulta externa:**

A consulta externa mostra os funcionários cujo salário-base é maior que essa média. O `INNER JOIN` relaciona cada funcionário ao seu cargo, e o `ORDER BY` organiza os maiores salários primeiro.

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

> Quais funcionários ocupam cargos de Caixa ou Atendente?

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE f.id_cargo IN (
    SELECT id_cargo
    FROM CARGO
    WHERE nome_cargo IN ('Caixa', 'Atendente')
)
ORDER BY c.nome_cargo, f.nome_func;
```

**Explique:**

A subconsulta retorna os IDs dos cargos chamados Caixa ou Atendente. O `IN` seleciona os funcionários cujo `id_cargo` está nessa lista. O `INNER JOIN` permite exibir também o nome do cargo.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais funcionários ainda não possuem nenhum expediente cadastrado?

```sql
SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE f.id_func NOT IN (
    SELECT e.id_func
    FROM EXPEDIENTE e
)
ORDER BY f.nome_func;
```

**Que registros você está procurando?**

A consulta procura funcionários cujo ID não aparece na tabela `EXPEDIENTE`, ou seja, funcionários sem expediente registrado.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais funcionários possuem pelo menos um expediente cadastrado?

```sql
SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais funcionários não possuem expediente cadastrado?

```sql
SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;
```

**Explique a diferença em relação a `EXISTS`:**

`EXISTS` retorna o funcionário quando a subconsulta encontra pelo menos um expediente relacionado. `NOT EXISTS` faz o contrário: retorna o funcionário quando não encontra nenhum expediente.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o maior salário-base cadastrado e quais cargos recebem esse valor?

```sql
SELECT
    nome_cargo,
    salario_base
FROM CARGO
WHERE salario_base = (
    SELECT MAX(salario_base)
    FROM CARGO
);
```

**Explique:**

A subconsulta encontra o maior valor de `salario_base`. A consulta externa mostra o cargo ou os cargos que possuem exatamente esse salário.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quantos expedientes estão cadastrados para cada funcionário?

```sql
SELECT
    f.id_func,
    f.nome_func,
    (
        SELECT COUNT(*)
        FROM EXPEDIENTE e
        WHERE e.id_func = f.id_func
    ) AS quantidade_expedientes
FROM FUNCIONARIO f
ORDER BY quantidade_expedientes DESC, f.nome_func;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

A subconsulta utiliza `f.id_func`, da consulta externa, e compara com `e.id_func` na tabela `EXPEDIENTE`.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Qual é o nome de cada funcionário e o nome do cargo que ocupa?

### JOIN

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY f.nome_func;
```

### SUBQUERY

```sql
SELECT
    f.nome_func AS funcionario,
    (
        SELECT c.nome_cargo
        FROM CARGO c
        WHERE c.id_cargo = f.id_cargo
    ) AS cargo
FROM FUNCIONARIO f
ORDER BY f.nome_func;
```

### Qual abordagem ficou mais compreensível?

O `JOIN` ficou mais compreensível porque mostra diretamente como as tabelas são relacionadas. A subconsulta também funciona, mas precisa buscar o cargo para cada funcionário.

---

## Pergunta 2

> Qual filial possui a maior quantidade de funcionários?

### JOIN

```sql
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);
```

### SUBQUERY

```sql
SELECT
    fi.id_filial,
    fi.Localizacao AS filial
FROM FILIAL fi
WHERE (
    SELECT COUNT(*)
    FROM FUNCIONARIO f
    WHERE f.id_filial = fi.id_filial
) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);
```

### Comparação

As duas consultas procuram a filial ou as filiais com mais funcionários. A versão com `JOIN` agrupa os dados relacionados; a versão com subconsulta conta os funcionários de cada filial individualmente e compara a quantidade com o maior total.

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
    f.nome_func,
    c.salario_base
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base)
    FROM CARGO
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

A subconsulta calcula primeiro a média dos salários-base em `CARGO` e retorna um único valor numérico. A consulta externa usa esse valor como limite e mostra os funcionários cujo salário-base é maior que a média.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > 3000
ORDER BY c.salario_base DESC;
```

**Alteração realizada:**

O filtro foi alterado de `c.salario_base > 3000` para `c.salario_base > 2000`.

**Mudança observada:**

Com o limite menor, a consulta pode mostrar mais funcionários, pois cargos com salário acima de R$ 2.000 passam a atender ao filtro. A quantidade exata depende dos dados cadastrados no banco.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro de chave estrangeira ao inserir expediente | O `id_func` informado não existia em `FUNCIONARIO` | Conferir os IDs reais e relacionar o expediente ao funcionário correto |
| Resultado vazio em uma consulta com filtro | Nenhum registro atendia à condição usada | Conferir os dados e ajustar o valor do filtro, se necessário |
| Consulta com `JOIN` sem resultado para algum registro | Não havia correspondência entre os IDs relacionados | Conferir as chaves estrangeiras e os valores cadastrados |

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```sql

-- Subconsulta comparação

SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base)
    FROM CARGO
)
ORDER BY c.salario_base DESC;

-- Subconsulta IN

SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE f.id_cargo IN (
    SELECT id_cargo
    FROM CARGO
    WHERE nome_cargo IN ('Caixa', 'Atendente')
)
ORDER BY c.nome_cargo, f.nome_func;

-- Subconsulta NOT IN

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE f.id_func NOT IN (
    SELECT e.id_func
    FROM EXPEDIENTE e
)
ORDER BY f.nome_func;

-- Exists

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;

-- NOT EXISTS

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;

-- MAX e MIN

SELECT
    nome_cargo,
    salario_base
FROM CARGO
WHERE salario_base = (
    SELECT MAX(salario_base)
    FROM CARGO
);

-- Subconsulta coreacionada

SELECT
    f.id_func,
    f.nome_func,
    (
        SELECT COUNT(*)
        FROM EXPEDIENTE e
        WHERE e.id_func = f.id_func
    ) AS quantidade_expedientes
FROM FUNCIONARIO f
ORDER BY quantidade_expedientes DESC, f.nome_func;

-- Mesma pergunta de duas formas

SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY f.nome_func;

-- e 

SELECT
    f.nome_func AS funcionario,
    (
        SELECT c.nome_cargo
        FROM CARGO c
        WHERE c.id_cargo = f.id_cargo
    ) AS cargo
FROM FUNCIONARIO f
ORDER BY f.nome_func;

-- Mesma pergunta de duas formas

SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);

-- e

SELECT
    fi.id_filial,
    fi.Localizacao AS filial
FROM FILIAL fi
WHERE (
    SELECT COUNT(*)
    FROM FUNCIONARIO f
    WHERE f.id_filial = fi.id_filial
) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);

SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > 2000
ORDER BY c.salario_base DESC;
```

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei subconsulta com comparação;
- [x] utilizei `IN`;
- [x] utilizei `NOT IN`;
- [x] utilizei `EXISTS`;
- [x] utilizei `NOT EXISTS`;
- [x] utilizei `MAX`;
- [x] criei subconsulta correlacionada;
- [x] resolvi duas perguntas usando JOIN e SUBQUERY;
- [x] expliquei o raciocínio;
- [X] testei no MySQL Workbench;
- [x] consigo revisar e explicar as consultas;
- [x] preenchi o conteúdo de `SPRINT2-5.md`;
- [X] salvei também o arquivo executável `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-04
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
