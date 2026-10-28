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
teams/Teams-UNEMAT/team-03/Module-2/
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

> Célia Hiromi Watanabe

**Branch:**

```text
team-03
```

**Nome do banco:**

```text
db_salao_beleza
```

**Tema do projeto:**

> Sistema de Gestão de Atendimentos e Agendamentos para Salão de Beleza.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | `cliente` | `id_cliente` | nenhuma |
| 2 | `profissional` | `id_profissional` | nenhuma |
| 3 | `servico` | `id_servico` | nenhuma |
| 4 | `agendamento` | `id_agendamento` | `id_cliente`, `id_profissional`, `id_servico` |

**Carga complementar para o Module-2:** no início do `SPRINT1-5.sql` foram inseridos 1 cliente sem agendamento (Patrícia Almeida, `id_cliente = 7`), 1 profissional sem agendamento (Gabriela Torres) e 4 novos agendamentos (ids 7 a 10: dois concluídos, um agendado e um cancelado). Com isso o banco passa a ter 6 clientes, 6 profissionais, 6 serviços e 9 agendamentos. A Patrícia recebe o id 7, e não o 6, porque o `AUTO_INCREMENT` não reaproveita o id do cliente excluído no Module-1.

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| `cliente` | 1:N | `agendamento` | `agendamento.id_cliente` |
| `profissional` | 1:N | `agendamento` | `agendamento.id_profissional` |
| `servico` | 1:N | `agendamento` | `agendamento.id_servico` |
| `cliente` | N:N (resolvido por `agendamento`) | `servico` | `agendamento.id_cliente` e `agendamento.id_servico` |

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

> Quais clientes possuem agendamento, e quando e em qual situação (status) está cada um?

**Tabelas utilizadas:**

```text
cliente, agendamento
```

**PK/FK utilizadas:**

```text
PK: cliente.id_cliente
FK: agendamento.id_cliente
```

**SQL:**

```sql
SELECT
    c.id_cliente,
    c.nome AS cliente,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM cliente AS c
INNER JOIN agendamento AS a
    ON c.id_cliente = a.id_cliente;
```

**Explique o resultado:**

> A consulta junta cada cliente aos seus agendamentos comparando o `id_cliente` das duas tabelas. Só aparecem clientes que têm ao menos um agendamento; quem não tem nenhum fica fora do resultado. Cada linha mostra o cliente, o número do agendamento, a data e hora e o status. O resultado esperado é de 9 linhas: a Mariana aparece 3 vezes, porque tem 3 agendamentos, e a Patrícia não aparece, porque não tem nenhum.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais profissionais possuem agendamentos e quais são as datas desses atendimentos?

```sql
SELECT
    p.id_profissional,
    p.nome AS profissional,
    p.especialidade,
    a.id_agendamento,
    a.data_hora
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional;
```

**Explique:**

> A consulta liga `profissional` a `agendamento` pelo `id_profissional`. Retorna apenas os profissionais que têm atendimento marcado, com a especialidade e a data de cada atendimento. São esperadas 9 linhas; a Gabriela Torres não aparece, porque ainda não tem agendamento.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais serviços existem no salão e em quais agendamentos aparecem, inclusive os serviços que ainda não foram agendados por nenhum cliente?

```sql
SELECT
    s.id_servico,
    s.nome_servico,
    s.preco,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM servico AS s
LEFT JOIN agendamento AS a
    ON s.id_servico = a.id_servico
ORDER BY s.id_servico;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite ver todos os serviços cadastrados, mesmo os que nenhum cliente agendou. Para um serviço sem agendamento, as colunas vindas de `agendamento` (`id_agendamento`, `data_hora` e `status`) aparecem como `NULL`. Assim é possível identificar serviços sem procura. No banco, o resultado esperado é de 10 linhas: os 9 agendamentos mais a "Escova e Hidratação", que aparece com `NULL` por nunca ter sido agendada.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais profissionais o salão possui e quais agendamentos cada um tem, incluindo quem ainda não tem nenhum atendimento marcado?

```sql
SELECT
    p.id_profissional,
    p.nome AS profissional,
    p.especialidade,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM agendamento AS a
RIGHT JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
ORDER BY p.id_profissional;
```

**Explique o resultado:**

> Aqui `agendamento` fica à esquerda e `profissional` à direita. O `RIGHT JOIN` mantém todas as linhas de `profissional`, mesmo as que não têm correspondência em `agendamento`. O resultado esperado é de 10 linhas: os 9 agendamentos com seus profissionais e mais a Gabriela Torres, que aparece com `NULL` em `id_agendamento`, `data_hora` e `status` por ainda não ter atendimento marcado. Com um `INNER JOIN`, ela não apareceria.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Qual é a agenda completa do salão, com cliente, profissional, serviço, data e valor?

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    p.nome AS profissional,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico;
```

## Consulta 2

**Pergunta:**

> Quais atendimentos já foram concluídos, com o nome do cliente, o serviço realizado e a forma de pagamento?

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    s.nome_servico AS servico,
    s.preco,
    a.forma_pagamento,
    a.observacoes
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status = 'Concluído';
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais agendamentos ainda estão com status 'Agendado' e valor de serviço a partir de R$ 80,00?

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status = 'Agendado'
  AND s.preco >= 80.00;
```

**Explique o filtro:**

> Primeiro as três tabelas são unidas pelos `ON`. Depois o `WHERE` mantém só as linhas em que o status é 'Agendado' **e** o preço do serviço é maior ou igual a R$ 80,00. As duas condições precisam ser verdadeiras ao mesmo tempo (`AND`).

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Qual é a ordem cronológica dos atendimentos, com o cliente e o profissional de cada um?

```sql
SELECT
    a.data_hora,
    c.nome AS cliente,
    p.nome AS profissional,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
ORDER BY a.data_hora ASC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Quantos atendimentos cada profissional tem e qual é o faturamento previsto e o ticket médio, desconsiderando os agendamentos cancelados?

```sql
SELECT
    p.nome AS profissional,
    COUNT(a.id_agendamento) AS total_atendimentos,
    SUM(s.preco)            AS faturamento_previsto,
    ROUND(AVG(s.preco), 2)  AS ticket_medio
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status <> 'Cancelado'
GROUP BY p.id_profissional, p.nome
ORDER BY faturamento_previsto DESC;
```

**Explique o agrupamento:**

> Os dois `INNER JOIN` ligam cada profissional aos seus agendamentos e cada agendamento ao preço do serviço. O `WHERE a.status <> 'Cancelado'` retira os cancelados **antes** do agrupamento. O `GROUP BY` reúne as linhas de cada profissional em uma só; em cada grupo, `COUNT` conta os atendimentos, `SUM` soma os preços (faturamento previsto) e `AVG` calcula o ticket médio, arredondado com `ROUND(..., 2)`. O `ORDER BY` mostra primeiro quem tem maior faturamento.
>
> Resultado esperado: Fabiana Silveira (2 atendimentos, R$ 240,00), Ana Paula Nogueira (2, R$ 160,00), Daniela Rocha (1, R$ 150,00), Carla Mendes (2, R$ 130,00) e Eduardo Martins (1, R$ 50,00). A Daniela tem só 1 atendimento porque o agendamento 10 dela foi cancelado e saiu pelo `WHERE`.

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

> Qual é a agenda completa do salão, com cliente, profissional, serviço, data e valor?

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    p.nome AS profissional,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico;
```

**Por que ela é útil?**

> Ela reúne em uma só tela as informações que a recepção do salão precisa no dia a dia: quem será atendido, por qual profissional, qual serviço, quanto custa, quando e em que situação está. Sem o `JOIN`, essas informações ficariam separadas em quatro tabelas.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    p.nome AS profissional,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> 1. Participam `agendamento`, `cliente`, `profissional` e `servico`.
> 2. As PKs usadas são `cliente.id_cliente`, `profissional.id_profissional` e `servico.id_servico`.
> 3. As FKs usadas são `agendamento.id_cliente`, `agendamento.id_profissional` e `agendamento.id_servico`.
> 4. Cada cláusula `ON` diz como duas tabelas se relacionam: ela compara o código guardado em `agendamento` (FK) com o código da tabela de origem (PK), e só junta as linhas em que os dois valores são iguais.
> 5. Se a condição estivesse errada, por exemplo `ON a.id_cliente = p.id_profissional`, o MySQL compararia códigos de tabelas diferentes e uniria linhas sem relação real, mostrando o cliente com o profissional ou o serviço errado, ou perdendo linhas. Se a condição fosse omitida, o resultado seria um produto cartesiano: cada linha de uma tabela combinada com todas as da outra.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    p.nome AS profissional,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico;
```

**Resultado esperado:**

> 9 linhas, uma para cada agendamento do banco (ids 1 a 5 e 7 a 10), cada uma com o nome do cliente, do profissional, do serviço, o preço, a data e hora e o status.

**Resultado obtido:**

> Consulta executada com sucesso no MySQL Workbench em 27/10/2026, retornando **9 linhas** (mensagem "9 row(s) returned"), uma para cada agendamento (ids 1 a 5 e 7 a 10), com os nomes de cliente, profissional e serviço no lugar dos códigos. O resultado foi igual ao esperado. As demais consultas do script também foram executadas sem erros: RIGHT JOIN com 10 linhas (Gabriela Torres com `NULL`), concluídos com 3 linhas, JOIN + WHERE com 3 linhas, ORDER BY com 9 linhas e GROUP BY com 5 linhas (Fabiana Silveira R$ 240,00, Ana Paula Nogueira R$ 160,00, Daniela Rocha R$ 150,00, Carla Mendes R$ 130,00 e Eduardo Martins R$ 50,00).

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Nas consultas com `GROUP BY`, o `COUNT` dava sempre 1 | Após o Module-1, cada cliente e cada profissional tinha exatamente 1 agendamento | Carga complementar com 4 novos agendamentos (clientes que voltaram, concluídos e um cancelado) |
| `LEFT JOIN` e `RIGHT JOIN` mostravam o mesmo que o `INNER JOIN` para clientes e profissionais | Não havia cliente nem profissional sem agendamento | Inserção de 1 cliente (Patrícia) e 1 profissional (Gabriela) sem agendamento |
| O `RIGHT JOIN` repetia o resultado do `LEFT JOIN` | As duas consultas usavam as mesmas tabelas (`servico` e `agendamento`) em ordem inversa | O `RIGHT JOIN` passou a usar `profissional`, mostrando a Gabriela com `NULL` |

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

- [x] utilizei o mesmo banco do Module-1;
- [x] identifiquei PKs e FKs;
- [x] produzi 2 `INNER JOIN`;
- [x] produzi 1 `LEFT JOIN`;
- [x] produzi 1 `RIGHT JOIN`;
- [x] produzi consultas com 3 ou mais tabelas;
- [x] utilizei `WHERE`;
- [x] utilizei `ORDER BY`;
- [x] utilizei agregação e `GROUP BY`;
- [x] as consultas respondem perguntas reais;
- [x] testei tudo no MySQL Workbench;
- [ ] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando:

```text
team-03
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
