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

> Célia Hiromi Watanabe

**Banco utilizado:**

```text
db_salao_beleza
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

Perguntas do domínio do salão de beleza que podem ser resolvidas com subconsultas:

1. Quais serviços custam mais do que o preço médio do catálogo?
2. Quais clientes agendaram algum serviço acima de R$ 100,00 (sem contar os cancelados)?
3. Quais serviços nunca foram agendados?
4. Quais profissionais já concluíram pelo menos um atendimento?
5. Quais clientes estão cadastrados mas ainda não fizeram nenhum agendamento?
6. Qual é o serviço mais caro do salão?
7. Quantos agendamentos cada cliente possui?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais serviços custam mais do que o preço médio do catálogo do salão?

```sql
SELECT
    nome_servico,
    preco
FROM servico
WHERE preco > (
    SELECT AVG(preco)
    FROM servico
)
ORDER BY preco DESC;
```

**Explique primeiro a consulta interna:**

> A consulta interna `SELECT AVG(preco) FROM servico` calcula a média de preço de todos os serviços: (80 + 50 + 65 + 95 + 150 + 120) ÷ 6 = **R$ 93,33**. Ela devolve um único valor.

**Depois explique a consulta externa:**

> A consulta externa percorre a tabela `servico` e mantém só os serviços cujo `preco` é maior que esse valor (93,33). Resultado esperado: 3 serviços — Maquiagem Social (R$ 150,00), Limpeza de Pele (R$ 120,00) e Escova e Hidratação (R$ 95,00). O `ORDER BY preco DESC` mostra do mais caro para o mais barato.

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

> Quais clientes têm agendamento (não cancelado) de algum serviço acima de R$ 100,00?

```sql
SELECT
    nome,
    telefone
FROM cliente
WHERE id_cliente IN (
    SELECT a.id_cliente
    FROM agendamento AS a
    WHERE a.status <> 'Cancelado'
      AND a.id_servico IN (
          SELECT s.id_servico
          FROM servico AS s
          WHERE s.preco > 100.00
      )
);
```

**Explique:**

> A execução vai de dentro para fora. (1) A subconsulta mais interna lista os serviços com preço acima de R$ 100,00: Maquiagem Social (id 5) e Limpeza de Pele (id 6). (2) A subconsulta do meio devolve os `id_cliente` dos agendamentos não cancelados desses serviços: Camila (3) e Fernanda (5). (3) A consulta externa mostra nome e telefone dos clientes cujo `id_cliente` está nessa lista. O `IN` compara com um **conjunto** de valores. A Mariana não aparece porque o único agendamento dela de serviço caro (Maquiagem Social, id 10) está cancelado. Resultado esperado: 2 linhas (Camila Oliveira e Fernanda Lima).

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais serviços do catálogo nunca foram agendados?

```sql
SELECT
    id_servico,
    nome_servico,
    preco
FROM servico
WHERE id_servico NOT IN (
    SELECT id_servico
    FROM agendamento
);
```

**Que registros você está procurando?**

> Procuro os serviços que existem no catálogo mas não aparecem em nenhum agendamento, ou seja, serviços sem procura. A subconsulta lista os `id_servico` que já foram agendados e o `NOT IN` mantém os que não estão nessa lista. Resultado esperado: 1 linha — Escova e Hidratação. Observação: o `NOT IN` retorna vazio se a lista da subconsulta tiver algum `NULL`; aqui isso não ocorre porque `agendamento.id_servico` é `NOT NULL`.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais profissionais já concluíram pelo menos um atendimento?

```sql
SELECT
    p.nome,
    p.especialidade
FROM profissional AS p
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_profissional = p.id_profissional
      AND a.status = 'Concluído'
);
```

> Para cada profissional da consulta externa, a subconsulta procura um agendamento dele com status 'Concluído'. Se encontrar ao menos um, o `EXISTS` é verdadeiro e o profissional aparece. O `SELECT 1` é só um marcador: o `EXISTS` só quer saber se existe ou não linha, não importa o que ela contém. Resultado esperado: 2 linhas — Ana Paula Nogueira (agendamentos concluídos 1 e 8) e Carla Mendes (agendamento concluído 7). Mesmo a Ana Paula tendo 2 concluídos, ela aparece uma só vez, pois o `EXISTS` só verifica se existe algum.

---

# 8. NOT EXISTS

**Pergunta:**

> Quais clientes estão cadastrados mas ainda não fizeram nenhum agendamento?

```sql
SELECT
    c.nome,
    c.telefone,
    c.email
FROM cliente AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_cliente = c.id_cliente
);
```

**Explique a diferença em relação a `EXISTS`:**

> O `EXISTS` mantém a linha quando a subconsulta **encontra** algo; o `NOT EXISTS` mantém a linha quando a subconsulta **não encontra nada**. Aqui, para cada cliente, a subconsulta procura agendamentos dele; só aparece quem não tem nenhum. Resultado esperado: 1 linha — Patrícia Almeida.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o serviço mais caro do salão?

```sql
SELECT
    nome_servico,
    duracao_minutos,
    preco
FROM servico
WHERE preco = (
    SELECT MAX(preco)
    FROM servico
);
```

**Explique:**

> A subconsulta `SELECT MAX(preco) FROM servico` devolve o maior preço do catálogo (R$ 150,00). A consulta externa mostra o serviço que tem exatamente esse preço: Maquiagem Social. Usei `=` porque o `MAX` devolve um único valor; se a subconsulta pudesse devolver várias linhas, seria preciso `IN`.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quantos agendamentos cada cliente possui?

```sql
SELECT
    c.nome,
    (
        SELECT COUNT(*)
        FROM agendamento AS a
        WHERE a.id_cliente = c.id_cliente
    ) AS total_agendamentos
FROM cliente AS c
ORDER BY total_agendamentos DESC, c.nome;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna `c.id_cliente`. A subconsulta depende dela, por isso é executada **uma vez para cada cliente** da consulta externa (diferente das subconsultas comuns, que rodam uma única vez). Resultado esperado: Mariana Souza 3, Beatriz Santos 2, Camila Oliveira 2, Fernanda Lima 1, Juliana Costa 1 e Patrícia Almeida 0. A Patrícia aparece com 0 porque o `COUNT` dentro da subconsulta devolve 0 quando não há linhas.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais clientes já tiveram atendimento concluído?

### JOIN

```sql
SELECT DISTINCT
    c.nome
FROM cliente AS c
INNER JOIN agendamento AS a
    ON c.id_cliente = a.id_cliente
WHERE a.status = 'Concluído';
```

### SUBQUERY

```sql
SELECT
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
    WHERE status = 'Concluído'
);
```

### Qual abordagem ficou mais compreensível?

> Para esta pergunta, a subconsulta. Ela se lê quase como a frase: "clientes cujo id está entre os agendamentos concluídos". No `JOIN` foi preciso usar `DISTINCT`, porque a Mariana tem 2 atendimentos concluídos e apareceria duas vezes. Resultado esperado nas duas versões: Mariana Souza e Beatriz Santos.

---

## Pergunta 2

> Quais profissionais já tiveram agendamento com a cliente Mariana Souza?

### JOIN

```sql
SELECT DISTINCT
    p.nome,
    p.especialidade
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
WHERE c.nome = 'Mariana Souza';
```

### SUBQUERY

```sql
SELECT
    nome,
    especialidade
FROM profissional
WHERE id_profissional IN (
    SELECT id_profissional
    FROM agendamento
    WHERE id_cliente = (
        SELECT id_cliente
        FROM cliente
        WHERE nome = 'Mariana Souza'
    )
);
```

### Comparação

> Resultado esperado nas duas versões: Ana Paula Nogueira, Carla Mendes e Daniela Rocha. O `JOIN` liga três tabelas e filtra pelo nome da cliente; é a melhor escolha quando preciso **mostrar colunas de mais de uma tabela**. A subconsulta encadeia dois passos (nome → id da cliente → ids dos profissionais) e dispensa os `ON`, mas só serve quando o resultado final usa colunas de uma tabela só. Para listar apenas dados do profissional, achei a subconsulta mais fácil de ler.

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
    nome_servico,
    preco
FROM servico
WHERE preco > (
    SELECT AVG(preco)
    FROM servico
)
ORDER BY preco DESC;
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1. A consulta interna, `SELECT AVG(preco) FROM servico`, é executada primeiro.
> 2. Ela retorna um único valor: a média dos preços, R$ 93,33.
> 3. A consulta externa usa esse valor como se fosse um número digitado no filtro: `WHERE preco > 93.33`. Assim, só passam os serviços mais caros que a média (Maquiagem Social, Limpeza de Pele e Escova e Hidratação).

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT
    nome,
    telefone
FROM cliente
WHERE id_cliente IN (
    SELECT a.id_cliente
    FROM agendamento AS a
    WHERE a.status <> 'Cancelado'
      AND a.id_servico IN (
          SELECT s.id_servico
          FROM servico AS s
          WHERE s.preco > 100.00
      )
);
```

**Alteração realizada:**

> Trocar temporariamente `s.preco > 100.00` por `s.preco > 60.00`, sem salvar no arquivo.

**Mudança observada:**

> Ao trocar `s.preco > 100.00` por `s.preco > 60.00`, o resultado passou de **2 clientes** (Camila Oliveira e Fernanda Lima) para **4 clientes** (Mariana Souza, Beatriz Santos, Camila Oliveira e Fernanda Lima). Isso ocorre porque a subconsulta mais interna passou a incluir também os serviços de R$ 65,00 (Manicure e Pedicure) e R$ 80,00 (Corte Feminino), e a Mariana e a Beatriz têm agendamentos não cancelados desses serviços. A Juliana continua de fora, porque o serviço dela (Corte Masculino) custa R$ 50,00. O teste foi feito em uma aba separada, sem alterar o arquivo `SPRINT2-5.sql`.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| `DISTINCT` necessário no `JOIN` do Problema 1 | A Mariana tem 2 atendimentos concluídos, e o `JOIN` repetiria o nome dela | `SELECT DISTINCT` no `JOIN`. Na versão com subconsulta (`IN`) isso não é necessário |
| Risco do `NOT IN` com valores `NULL` | Se a subconsulta devolvesse algum `NULL`, o `NOT IN` não retornaria nenhuma linha | `agendamento.id_servico` é `NOT NULL`, então o uso é seguro neste banco |
| Mariana fora do resultado da consulta 2 (`IN`) | O agendamento 10 dela (Maquiagem Social) está cancelado | O filtro `status <> 'Cancelado'` foi mantido de propósito e explicado na seção 5 |

Nenhuma consulta apresentou erro de execução no MySQL Workbench; os problemas acima são pontos observados durante a construção das consultas.

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
- [ ] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-03
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
