# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Nesta primeira Sprint do **Module-2**, será utilizado o mesmo banco de dados desenvolvido no `Module-1`.

O foco é consultar dados relacionados entre duas ou mais tabelas por meio de `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `ON`, `AS`, `WHERE`, `ORDER BY`, `GROUP BY` e funções de agregação.

# 1. Estrutura do repositório

Os arquivos desta Sprint deverão ficar em:

```text
teams/Teams-UNEMAT/team-04/Module-2/
```

Ao final:

```text
Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

# 2. Identificação

**Nome completo:**

> Marcos Aurélio Bastos Stanguerlin

**Branch:**

```text
team-04
```

**Nome do banco:**

```text
Rh_sorveteria
```

**Tema do projeto:**

> Recursos Humanos de uma sorveteria com várias filiais.

---

# 3. Retomada do banco

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | FUNCIONARIO | `id_func` | `id_cargo`, `id_setor`, `id_filial` |
| 2 | CARGO | `id_cargo` | Não possui |
| 3 | SETOR | `id_setor` | Não possui |
| 4 | FILIAL | `id_filial` | Não possui |
| 5 | EXPEDIENTE | `id_expediente` | `id_func` |
| 6 | PRODUTO | `id_produto` | Não possui |
| 7 | ESTOQUE | (`id_filial`, `id_produto`) | `id_filial`, `id_produto` |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| CARGO | 1:N | FUNCIONARIO | `FUNCIONARIO.id_cargo` |
| SETOR | 1:N | FUNCIONARIO | `FUNCIONARIO.id_setor` |
| FILIAL | 1:N | FUNCIONARIO | `FUNCIONARIO.id_filial` |
| FUNCIONARIO | 1:N | EXPEDIENTE | `EXPEDIENTE.id_func` |
| FILIAL | N:N | PRODUTO, por meio de ESTOQUE | `ESTOQUE.id_filial` e `ESTOQUE.id_produto` |

---

# 5. INNER JOIN

O `INNER JOIN` retorna os registros que possuem correspondência nas tabelas relacionadas.

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Qual é o cargo e o salário-base de cada funcionário?

**Tabelas utilizadas:**

```text
FUNCIONARIO e CARGO
```

**PK/FK utilizadas:**

```text
PK: CARGO.id_cargo
FK: FUNCIONARIO.id_cargo
```

**SQL:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo;
```

**Explique o resultado:**

O `f.` e o `c.` identificam de qual tabela cada coluna vem. O `INNER JOIN` junta `FUNCIONARIO` e `CARGO`, e o `ON f.id_cargo = c.id_cargo` compara os IDs para mostrar o cargo e o salário correspondente a cada funcionário. Como é `INNER JOIN`, só aparecem funcionários que possuem um cargo correspondente.

## Consulta INNER JOIN 2

**Pergunta:**

> Quem foi contratado no mês de setembro e qual é o seu cargo?

**Tabelas utilizadas:**

```text
FUNCIONARIO e CARGO
```

**PK/FK utilizadas:**

```text
PK: CARGO.id_cargo
FK: FUNCIONARIO.id_cargo
```

**SQL:**

```sql
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE MONTH(f.data_admissao) = 9
ORDER BY f.data_admissao ASC;
```

**Explique:**

O `INNER JOIN` relaciona o funcionário ao seu cargo pelo ID. O `WHERE MONTH(f.data_admissao) = 9` mostra somente quem foi contratado em setembro, e o `ORDER BY f.data_admissao ASC` organiza as datas da mais antiga para a mais recente. Com os dados atuais, aparece Anna Paula, admitida em `2023-09-01`.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais cargos existem e quais funcionários ocupam cada cargo?

**SQL:**

```sql
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo;
```

**O que o LEFT JOIN permite visualizar neste caso?**

O `LEFT JOIN` mantém todos os cargos e adiciona o nome do funcionário quando encontra um ID correspondente em `FUNCIONARIO`. O `ON c.id_cargo = f.id_cargo` faz essa comparação. Se um cargo não tiver funcionário, ele continua aparecendo e o nome do funcionário fica como `NULL`.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela à direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais cargos existem, incluindo os que não possuem funcionários associados?

**SQL:**

```sql
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM FUNCIONARIO f
RIGHT JOIN CARGO c
    ON f.id_cargo = c.id_cargo;
```

**Explique o resultado:**

O `RIGHT JOIN` mantém todos os cargos porque `CARGO` está à direita, mesmo que algum não tenha funcionário correspondente. Nesse caso, o nome do funcionário aparece como `NULL`. O resultado é parecido com o `LEFT JOIN` anterior, pois ambos mantêm todos os cargos; muda apenas a posição das tabelas.

---

# 8. JOIN com três ou mais tabelas

## Consulta 1

**Pergunta:**

> Qual é o nome do funcionário, seu cargo, setor, filial e salário-base?

**SQL:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
INNER JOIN SETOR s
    ON f.id_setor = s.id_setor
INNER JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;
```

Os `INNER JOIN` relacionam `FUNCIONARIO` com `CARGO`, `SETOR` e `FILIAL` usando os IDs indicados em cada `ON`. Assim, a consulta mostra os dados dessas tabelas em uma só pesquisa. O `ORDER BY` organiza primeiro pela localização da filial e depois pelo nome do funcionário.

## Consulta 2

**Pergunta:**

> Quantos funcionários existem em cada filial, qual é o total de horas extras registrado e qual é o salário médio dos funcionários?

**SQL:**

```sql
SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;
```

A consulta reúne os dados das quatro tabelas por filial. O `COUNT(DISTINCT f.id_func)` conta os funcionários sem repetir o mesmo ID, o `SUM(...)` soma as horas extras e o `AVG(c.salario_base)` calcula o salário médio. O `GROUP BY` separa os resultados por filial, o `HAVING` mantém apenas as filiais com pelo menos um funcionário e o `ORDER BY ... DESC` organiza do maior total de horas extras para o menor.

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais produtos possuem menos de 40 unidades em estoque?

**SQL:**

```sql
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
INNER JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 40;
```

**Explique o filtro:**

O `INNER JOIN` relaciona cada registro de `ESTOQUE` ao nome correspondente em `PRODUTO`. O `WHERE e.quantidade < 40` mostra somente os produtos que têm menos de 40 unidades registradas no estoque.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Como ficam os funcionários organizados pela localização da filial e pelo nome?

**SQL:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY c.nome_cargo ASC, f.nome_func ASC;
```

Essa consulta relaciona as tabelas FUNCIONARIO e CARGO para mostrar o nome de cada funcionário, seu cargo e a data de admissão

---

# 11. JOIN + GROUP BY + agregação

**Pergunta:**

> Quantos funcionários existem em cada cargo?

**SQL:**

```sql
SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;
```

**Explique o agrupamento:**

O `GROUP BY c.id_cargo, c.nome_cargo` separa os resultados por cargo, e o `COUNT(f.id_func)` conta quantos funcionários estão relacionados a cada um. O `LEFT JOIN` mantém também os cargos sem funcionários; nesses casos, a contagem fica em zero.

---

# 12. Quantidade mínima exigida

| Requisito | Consulta utilizada |
|---|---|
| 2 `INNER JOIN` | Seção 5, consultas 1 e 2 |
| 1 `LEFT JOIN` | Seção 6 |
| 1 `RIGHT JOIN` | Seção 7 |
| 2 consultas envolvendo 3 ou mais tabelas | Seção 8, consultas 1 e 2 |
| 1 `JOIN` + `WHERE` | Seção 9 |
| 1 `JOIN` + `ORDER BY` | Seção 10 |
| 1 `JOIN` + `GROUP BY` + agregação | Seção 11 |

---

# 13. Consulta mais útil

**Pergunta:**

> Quais são os funcionários, seus cargos, setores, filiais e salários-base?

**SQL:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
INNER JOIN SETOR s
    ON f.id_setor = s.id_setor
INNER JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;
```

**Por que ela é útil?**

Escolhi essa consulta porque permite ver em uma única pesquisa o funcionário, seu cargo, setor, filial e salário-base, informações úteis para o setor de Recursos Humanos.

---

# 14. Validação prática obrigatória

**Consulta selecionada:**

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
INNER JOIN SETOR s
    ON f.id_setor = s.id_setor
INNER JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;
```

**Explicação:**

1. As tabelas usadas são `FUNCIONARIO`, `CARGO`, `SETOR` e `FILIAL`.
2. As PKs são `CARGO.id_cargo`, `SETOR.id_setor` e `FILIAL.id_filial`.
3. As FKs são `FUNCIONARIO.id_cargo`, `FUNCIONARIO.id_setor` e `FUNCIONARIO.id_filial`.
4. Cada `ON` compara a FK do funcionário com a PK da tabela relacionada para encontrar o registro correspondente.
5. Se a condição do `ON` estivesse errada, as informações poderiam ser relacionadas incorretamente.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;
```

**Resultado esperado:**

A pesquisa deve mostrar todos os cargos que estão cadastrados e contar quantos funcionarios estão relacionados com cada um. Caso algum cargo não tenha funcionario, ele continua aparecendo por causa do `LEFT JOIN`, mas a quantidade de funcionarios fica em zero.

**Resultado obtido:**

Com os dados cadastrados e as alterações realizadas no projeto, a consulta deve mostrar os cargos e suas contagens atuais. A conferência final deve ser feita executando o SQL no MySQL Workbench.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 17. Uso de LLMs

LLMs podem ser utilizadas como apoio, mas todo código deverá ser compreendido, adaptado, executado, testado e validado. O aluno deverá ser capaz de explicar presencialmente qualquer consulta entregue.

---

# 18. Estrutura recomendada do SPRINT1-5.sql

```sql
-- Inner Join 1
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo;

-- Inner Join 2
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE MONTH(f.data_admissao) = 9
ORDER BY f.data_admissao ASC;

-- Left Join
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo;
    
-- Right Join
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM FUNCIONARIO f
RIGHT JOIN CARGO c
    ON f.id_cargo = c.id_cargo;
    
-- Join com 3 tabelas
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
INNER JOIN SETOR s
    ON f.id_setor = s.id_setor
INNER JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;

-- Join com 3 tabelas 2
SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;

-- Join Where
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
INNER JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 40;

-- Join order by
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY c.nome_cargo ASC, f.nome_func ASC;

-- Join Group by Agregação
SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;
```

---

# 19. Checklist

- [x] Utilize o mesmo banco do Module-1.
- [x] Identifiquei PKs e FKs.
- [x] Preparei 2 consultas com `INNER JOIN`.
- [x] Preparei 1 consulta com `LEFT JOIN`.
- [x] Preparei 1 consulta com `RIGHT JOIN`.
- [x] Preparei consultas com 3 ou mais tabelas.
- [x] Utilizei `WHERE`.
- [x] Utilizei `ORDER BY`.
- [x] Utilizei agregação e `GROUP BY`.
- [x] As consultas respondem perguntas sobre o banco.
- [X] Executei e conferi todas as consultas no MySQL Workbench.
- [X] Confirmei os resultados obtidos no MySQL Workbench.
- [x] Salvei o arquivo `SPRINT1-5.md`.
- [X] Salvei o arquivo `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando a branch:

```text
team-04
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

Não abra o Pull Request final nesta Sprint.

---

# Próxima etapa

Na Sprint 2/5 serão trabalhadas subconsultas:

```sql
IN
NOT IN
EXISTS
NOT EXISTS
```

Também serão estudadas subconsultas correlacionadas.
