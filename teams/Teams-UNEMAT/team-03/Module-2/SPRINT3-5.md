# SPRINT 3/5 — Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá criar **Views** para representar consultas relevantes e reutilizáveis do seu banco.

Serão trabalhados:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT
DROP VIEW
SHOW FULL TABLES
```

O aluno deverá compreender que uma `VIEW` representa uma consulta armazenada que pode ser utilizada como uma tabela virtual.

---

# 1. Identificação

**Nome completo:**

> Célia Hiromi Watanabe

**Banco utilizado:**

```text
db_salao_beleza
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Agenda completa com cliente, profissional, serviço e valor (Sprint 1, consulta 5) | É a tela principal da recepção; junta 4 tabelas e seria repetida o tempo todo | Sim — `vw_agenda_completa` |
| Atendimentos e faturamento por profissional (Sprint 1, consulta 9) | Mostra a produtividade e o faturamento previsto de cada profissional | Sim — `vw_resumo_profissional` |
| Agendamentos com status 'Agendado' (Sprint 1, consulta 7) | Lista o que ainda falta atender, para a recepção confirmar horários | Sim — `vw_agendamentos_pendentes` |
| Clientes sem nenhum agendamento (Sprint 2, consulta 5) | Ajuda a fazer contato com clientes cadastrados que nunca agendaram | Não — é uma consulta pontual, usada só de vez em quando |

---

# 3. Criando uma VIEW

Estrutura geral:

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

Exemplo:

```sql
CREATE VIEW vw_clientes_pedidos AS
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido
FROM cliente AS c
INNER JOIN pedido AS p
    ON c.id_cliente = p.id_cliente;
```

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```text
vw_agenda_completa
```

**Pergunta que ela representa:**

> Qual é a agenda completa do salão, com os nomes de cliente, profissional e serviço, o preço, o status e a forma de pagamento de cada agendamento?

**SQL:**

```sql
CREATE VIEW vw_agenda_completa AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome          AS cliente,
    p.nome          AS profissional,
    p.especialidade,
    s.nome_servico  AS servico,
    s.preco,
    a.status,
    a.forma_pagamento
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico;
```

**Tabelas utilizadas:**

> `agendamento`, `cliente`, `profissional` e `servico`, ligadas pelas FKs `agendamento.id_cliente`, `agendamento.id_profissional` e `agendamento.id_servico` às PKs das tabelas de origem.

**Como consultar essa VIEW?**

```sql
SELECT * FROM vw_agenda_completa ORDER BY data_hora;
```

> Resultado esperado: 9 linhas, uma por agendamento, já com os nomes no lugar dos códigos.

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Quantos atendimentos (não cancelados) cada profissional tem, qual é o faturamento previsto e o ticket médio — incluindo quem ainda não tem nenhum atendimento?

```sql
CREATE VIEW vw_resumo_profissional AS
SELECT
    p.id_profissional,
    p.nome                              AS profissional,
    p.especialidade,
    COUNT(a.id_agendamento)             AS total_atendimentos,
    COALESCE(SUM(s.preco), 0)           AS faturamento_previsto,
    COALESCE(ROUND(AVG(s.preco), 2), 0) AS ticket_medio
FROM profissional AS p
LEFT JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
   AND a.status <> 'Cancelado'
LEFT JOIN servico AS s
    ON a.id_servico = s.id_servico
GROUP BY p.id_profissional, p.nome, p.especialidade;
```

**Explique:**

> O `LEFT JOIN` mantém **todos** os profissionais, mesmo quem não tem agendamento. O filtro `a.status <> 'Cancelado'` está no `ON`, e não no `WHERE`, de propósito: a Gabriela não tem agendamento, então as colunas de `agendamento` vêm `NULL` para ela; um `WHERE` compararia esse `NULL` e eliminaria a Gabriela do resultado. No `ON`, o filtro só escolhe quais agendamentos entram na junção. O `GROUP BY` reúne as linhas de cada profissional; `COUNT` conta os atendimentos, `SUM` soma os preços e `AVG` calcula o ticket médio. O `COALESCE` troca `NULL` por 0, para a Gabriela aparecer com R$ 0,00 e não com `NULL`.
>
> Resultado esperado: Fabiana Silveira (2 atendimentos, R$ 240,00), Ana Paula Nogueira (2, R$ 160,00), Daniela Rocha (1, R$ 150,00), Carla Mendes (2, R$ 130,00), Eduardo Martins (1, R$ 50,00) e Gabriela Torres (0, R$ 0,00).

---

# 6. VIEW 3 — consulta operacional do sistema

Crie uma VIEW que represente uma informação útil para um usuário real.

Exemplos:

```text
estoque baixo
empréstimos em aberto
pedidos pendentes
alunos matriculados
consultas futuras
reservas ativas
pagamentos pendentes
```

**Nome da VIEW:**

```text
vw_agendamentos_pendentes
```

```sql
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome         AS cliente,
    p.nome         AS profissional,
    s.nome_servico AS servico,
    s.preco
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
WHERE a.status = 'Agendado';
```

**Por que essa VIEW é útil?**

> É a lista de trabalho da recepção: mostra apenas os atendimentos que ainda vão acontecer (status 'Agendado'), com cliente, profissional, serviço e valor. Em vez de reescrever o `JOIN` e o filtro toda vez, basta `SELECT * FROM vw_agendamentos_pendentes`. Resultado esperado: 5 linhas (agendamentos 2, 3, 4, 5 e 9).

---

# 7. Consultando uma VIEW

Execute:

```sql
SELECT *
FROM nome_view;
```

Depois faça um filtro:

```sql
SELECT *
FROM nome_view
WHERE ...;
```

**SQL executado:**

```sql
SELECT * FROM vw_agenda_completa ORDER BY data_hora;

SELECT * FROM vw_agenda_completa WHERE cliente = 'Mariana Souza';

SELECT profissional, total_atendimentos, faturamento_previsto
FROM vw_resumo_profissional
WHERE total_atendimentos >= 2;
```

**Resultado observado:**

> Executado no MySQL Workbench em 27/10/2026, sem erros. A agenda completa (`vw_agenda_completa`) retornou **9 linhas**, uma por agendamento. O filtro por cliente (`WHERE cliente = 'Mariana Souza'`) retornou **3 linhas** (agendamentos 1, 7 e 10). O filtro `WHERE total_atendimentos >= 2` na `vw_resumo_profissional` retornou **3 linhas** (Fabiana Silveira, Ana Paula Nogueira e Carla Mendes). Isso mostra que a view pode ser usada como uma tabela, inclusive com `WHERE` e `ORDER BY`.

---

# 8. CREATE OR REPLACE VIEW

Escolha uma VIEW e faça uma alteração coerente.

Pode ser:

- adicionar coluna;
- alterar filtro;
- incluir um `JOIN`;
- adicionar cálculo;
- alterar uma agregação.

**VIEW original:**

```sql
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome         AS cliente,
    p.nome         AS profissional,
    s.nome_servico AS servico,
    s.preco
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
WHERE a.status = 'Agendado';
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome            AS cliente,
    c.telefone        AS telefone_cliente,
    p.nome            AS profissional,
    s.nome_servico    AS servico,
    s.duracao_minutos,
    s.preco
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
WHERE a.status = 'Agendado';
```

**O que mudou?**

> Foram adicionadas duas colunas: `telefone_cliente`, para a recepção ligar e confirmar o horário, e `duracao_minutos`, para saber quanto tempo reservar na agenda da profissional. O `CREATE OR REPLACE VIEW` substitui a definição antiga sem precisar apagar a view antes; se ela não existisse, seria criada.

---

# 9. DROP VIEW — exercício controlado

Crie uma VIEW temporária:

```sql
CREATE VIEW vw_teste AS
SELECT ...;
```

Depois remova:

```sql
DROP VIEW vw_teste;
```

**Código utilizado:**

```sql
CREATE VIEW vw_teste AS
SELECT nome_servico, preco
FROM servico
WHERE preco < 70.00;

SELECT * FROM vw_teste;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> O `DROP VIEW` apaga apenas a consulta armazenada; os dados continuam intactos na tabela `servico`. O `DROP TABLE` apaga a tabela inteira **junto com todos os seus dados**, e não há como recuperá-los sem backup. Por isso o `DROP VIEW` é uma operação segura para os dados, e o `DROP TABLE` não.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. `vw_agenda_completa`
2. `vw_agendamentos_pendentes`
3. `vw_resumo_profissional`

> O comando retornou **3 linhas** no MySQL Workbench, correspondentes às views acima. A `vw_teste` não aparece, porque foi removida com `DROP VIEW`.

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_agendamentos_pendentes
```

**Alteração realizada:**

```sql
-- Conclui o agendamento 9 na tabela base
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix'
WHERE id_agendamento = 9;

-- Depois do teste, desfaz a alteração
UPDATE agendamento
SET status = 'Agendado',
    forma_pagamento = NULL
WHERE id_agendamento = 9;
```

**Resultado observado:**

> Antes do `UPDATE`, a `vw_agendamentos_pendentes` retornou **5 linhas**. Depois de concluir o agendamento 9 na tabela `agendamento`, a mesma view passou a retornar **4 linhas**: o agendamento 9 (Camila com a Fabiana, Limpeza de Pele) saiu da lista, sem que a view fosse alterada. Depois de desfazer a alteração, voltou a retornar **5 linhas**. Isso comprova que a view não guarda dados: ela executa a consulta nas tabelas base a cada uso, e por isso sempre reflete o estado atual delas.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
CREATE VIEW vw_resumo_profissional AS
SELECT
    p.id_profissional,
    p.nome                              AS profissional,
    p.especialidade,
    COUNT(a.id_agendamento)             AS total_atendimentos,
    COALESCE(SUM(s.preco), 0)           AS faturamento_previsto,
    COALESCE(ROUND(AVG(s.preco), 2), 0) AS ticket_medio
FROM profissional AS p
LEFT JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
   AND a.status <> 'Cancelado'
LEFT JOIN servico AS s
    ON a.id_servico = s.id_servico
GROUP BY p.id_profissional, p.nome, p.especialidade;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1. Depende de `profissional`, `agendamento` e `servico`.
> 2. Usa `profissional.id_profissional` (PK) = `agendamento.id_profissional` (FK) e `agendamento.id_servico` (FK) = `servico.id_servico` (PK), com `LEFT JOIN` para manter todos os profissionais.
> 3. Apresenta o código, o nome e a especialidade do profissional, o total de atendimentos não cancelados, o faturamento previsto e o ticket médio.
> 4. Resolve a necessidade de acompanhar a produtividade e o faturamento de cada profissional sem reescrever um `SELECT` com dois `JOIN`s, `GROUP BY` e três agregações toda vez.
> 5. Como a view não guarda dados, qualquer alteração nas tabelas aparece na próxima consulta. Por exemplo, se um novo agendamento for criado para a Gabriela, ela deixa de aparecer com 0 e passa a mostrar 1 atendimento e o valor do serviço; se um agendamento for cancelado, ele sai da contagem e do faturamento.

---

# 13. Quantidade mínima exigida

O projeto deverá possuir no mínimo:

```text
3 VIEWs úteis
1 VIEW com relacionamento
1 VIEW com agregação ou resumo
1 CREATE OR REPLACE VIEW
1 teste com DROP VIEW
```

---

# 14. Estrutura recomendada do SPRINT3-5.sql

```sql
-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- VIEW 1

-- VIEW 2

-- VIEW 3

-- CONSULTAS SOBRE AS VIEWS

-- CREATE OR REPLACE VIEW

-- VIEW TEMPORÁRIA

-- DROP VIEW

-- VALIDAÇÃO
```

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| A Gabriela (sem agendamento) sumiria da `vw_resumo_profissional` | Um filtro `WHERE a.status <> 'Cancelado'` compara `NULL` e elimina quem não tem agendamento | O filtro foi colocado no `ON` do `LEFT JOIN`, e não no `WHERE` |
| Faturamento e ticket médio da Gabriela apareceriam como `NULL` | `SUM` e `AVG` sobre nenhuma linha retornam `NULL` | `COALESCE(..., 0)` troca o `NULL` por 0 |
| Erro "view already exists" ao executar o script uma segunda vez | `CREATE VIEW` não substitui uma view existente | `DROP VIEW IF EXISTS` no início do script, para ele poder ser executado várias vezes |

Nenhuma consulta apresentou erro de execução no MySQL Workbench; os problemas acima são pontos observados durante a construção das views.

---

# 16. Uso de LLMs

O uso de LLMs pode ocorrer como apoio, mas o aluno deverá compreender e validar todo o código.

Fluxo obrigatório:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei pelo menos 3 Views;
- [x] pelo menos uma View usa JOIN;
- [x] pelo menos uma View usa agregação ou resumo;
- [x] consultei as Views;
- [x] utilizei `CREATE OR REPLACE VIEW`;
- [x] pratiquei `DROP VIEW`;
- [x] validei as Views;
- [x] testei mudança em tabela base;
- [ ] compreendo de onde vêm os dados de cada View;
- [x] salvei `SPRINT3-5.md`;
- [x] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Continue utilizando:

```text
team-03
```

Arquivos:

```text
Module-2/SPRINT3-5.md
Module-2/SPRINT3-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 3 de 5 - views
```

**Ainda não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 4/5 serão trabalhados:

```sql
CREATE PROCEDURE
CALL
IN
OUT
CREATE FUNCTION
RETURN
IF
ELSE
```
