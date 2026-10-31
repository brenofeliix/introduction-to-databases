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

> Talita de Oliveira Leite Sete

**Banco utilizado:**

```text
secretaria_saude
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Atendimentos com paciente, profissional e unidade (Sprint 1) | Evita repetir 3 JOINs toda vez que alguém precisa ver “quem atendeu quem, onde e quando” | Sim — vw_atendimentos_detalhados |
| Resumo do estoque por unidade (Sprint 1) | Dá à gestão o total e a validade mais próxima de cada unidade sem refazer o GROUP BY | Sim — vw_resumo_estoque_unidade |
| Agenda dos atendimentos agendados (Sprint 4 do Módulo 1 e Sprint 1) | A recepção confirma presenças com nome e telefone do paciente	 | Sim — vw_agenda_agendada |
| Itens com estoque baixo (Sprints 4 e 5 do Módulo 1) | Mostra o que precisa ser reposto	 | Sim — vw_estoque_baixo |

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
vw_atendimentos_detalhados
```

**Pergunta que ela representa:**

> Quem atendeu quem, onde e quando?

**SQL:**

```sql
-- ============================================================
-- VIEW 1 — relacionamento entre tabelas
-- Atendimentos com nome do paciente, profissional e unidade
-- ============================================================
DROP VIEW IF EXISTS vw_atendimentos_detalhados;
CREATE VIEW vw_atendimentos_detalhados AS
SELECT a.id_atendimento, p.nome AS paciente, pf.nome AS profissional, pf.setor,
       u.nome AS unidade, a.data_hora, a.tipo_atendimento, a.status
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade;
```

**Tabelas utilizadas:**

> atendimento, paciente, profissional e unidade_saude.

**Como consultar essa VIEW?**

```sql
SELECT * FROM vw_atendimentos_detalhados;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Quantos itens e quantas unidades em estoque cada unidade possui, e qual a validade mais próxima?

```sql
-- ============================================================
-- VIEW 2 — agregação / resumo
-- Resumo do estoque por unidade
-- ============================================================
DROP VIEW IF EXISTS vw_resumo_estoque_unidade;
CREATE VIEW vw_resumo_estoque_unidade AS
SELECT u.id_unidade, u.nome AS unidade,
       COUNT(*)          AS itens_cadastrados,
       SUM(e.quantidade) AS total_unidades_em_estoque,
       MIN(e.validade)   AS validade_mais_proxima
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome;
```

**Explique:**

> Junta unidade_saude e estoque_item e agrupa por unidade. COUNT(*) conta os itens, SUM(quantidade) soma as unidades e MIN(validade) mostra a data mais próxima. Resultado: 6 linhas, e a UBS Centro lidera com 920.

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
vw_agenda_agendada
```

```sql
-- ============================================================
-- VIEW 3 — consulta operacional
-- Agenda de atendimentos agendados (consultas futuras)
-- ============================================================
DROP VIEW IF EXISTS vw_agenda_agendada;
CREATE VIEW vw_agenda_agendada AS
SELECT a.id_atendimento, a.data_hora, p.nome AS paciente, p.telefone,
       pf.nome AS profissional, u.nome AS unidade, a.tipo_atendimento
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
WHERE a.status = 'AGENDADO';
```

**Por que essa VIEW é útil?**

> Mostra paciente, telefone, profissional e unidade de cada atendimento agendado. A recepção confirma presenças sem conhecer o banco, e a view não tem filtro de data, então continua válida com o tempo; o filtro é feito na hora da consulta.

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
-- ============================================================
-- CONSULTAS SOBRE AS VIEWS
-- ============================================================
SELECT * FROM vw_atendimentos_detalhados;

SELECT * FROM vw_atendimentos_detalhados
WHERE status = 'REALIZADO' AND unidade = 'UBS Vila Nova'
ORDER BY data_hora;

SELECT * FROM vw_resumo_estoque_unidade;

SELECT * FROM vw_agenda_agendada ORDER BY data_hora;

SELECT * FROM vw_agenda_agendada
WHERE data_hora < '2026-11-01'
ORDER BY data_hora;

SELECT * FROM vw_estoque_baixo;

```

**Resultado observado:**

> SELECT * em vw_atendimentos_detalhados retorna os 15 atendimentos. O filtro por status REALIZADO e unidade UBS Vila Nova retorna 3: Pedro Henrique, Rita de Cássia e Thiago. A vw_agenda_agendada retorna 4 agendamentos e, filtrada até 31/10, retorna 2 (Pedro Henrique e Thiago).

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
-- ============================================================
-- VIEW 4 — estoque baixo (usada no CREATE OR REPLACE)
-- ============================================================
DROP VIEW IF EXISTS vw_estoque_baixo;
CREATE VIEW vw_estoque_baixo AS
SELECT u.nome AS unidade, e.nome AS item, e.quantidade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.quantidade < 50;

```

**Nova versão:**

```sql
-- ============================================================
-- CREATE OR REPLACE VIEW
-- Nova versão da vw_estoque_baixo: tipo, validade e quanto falta para o mínimo
-- ============================================================
CREATE OR REPLACE VIEW vw_estoque_baixo AS
SELECT u.nome AS unidade, e.nome AS item, e.tipo, e.quantidade,
       (50 - e.quantidade) AS faltam_para_minimo, e.validade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.quantidade < 50;

SELECT * FROM vw_estoque_baixo ORDER BY faltam_para_minimo DESC;
```

**O que mudou?**

> Acrescentei tipo, validade e a coluna calculada faltam_para_minimo (50 − quantidade). A condição quantidade < 50 continuou a mesma, então os mesmos 3 itens aparecem: Influenza do Posto Rural (faltam 42), Insulina (10) e Hepatite B (5). A view foi substituída sem precisar de DROP.

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
-- ============================================================
-- VIEW TEMPORÁRIA + DROP VIEW
-- ============================================================
DROP VIEW IF EXISTS vw_teste;
CREATE VIEW vw_teste AS
SELECT id_paciente, nome FROM paciente;

SELECT COUNT(*) AS linhas_vw_teste FROM vw_teste;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> DROP VIEW apaga só a consulta armazenada; os dados continuam nas tabelas base. DROP TABLE apaga a estrutura e todos os dados da tabela. Depois do DROP VIEW vw_teste, a tabela paciente continua com os 10 registros.
---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_agenda_agendada
2. vw_atendimentos_detalhados
3. vw_estoque_baixo
4. vw_resumo_estoque_unidade

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_resumo_estoque_unidade
```

**Alteração realizada:**

```sql
UPDATE estoque_item SET quantidade = quantidade + 100 WHERE id_item = 1;
```

**Resultado observado:**

> Antes, a UBS Centro mostrava 920 unidades em estoque. Após o UPDATE (Vacina Influenza de 120 para 220), a mesma consulta passou a mostrar 1020, sem recriar a view, porque ela guarda a consulta e não os dados. Depois desfiz o teste com quantidade - 100, e o total voltou a 920.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
-- ============================================================
-- VIEW 2 — agregação / resumo
-- Resumo do estoque por unidade
-- ============================================================
DROP VIEW IF EXISTS vw_resumo_estoque_unidade;
CREATE VIEW vw_resumo_estoque_unidade AS
SELECT u.id_unidade, u.nome AS unidade,
       COUNT(*)          AS itens_cadastrados,
       SUM(e.quantidade) AS total_unidades_em_estoque,
       MIN(e.validade)   AS validade_mais_proxima
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome;

```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1. Depende de unidade_saude e estoque_item.
> 2.Relaciona unidade_saude.id_unidade (PK) com estoque_item.id_unidade (FK).
> 3.Mostra id_unidade, unidade, itens_cadastrados, total_unidades_em_estoque e validade_mais_proxima.
> 4.Resolve a necessidade de ver o estoque consolidado por unidade sem reescrever o JOIN e o GROUP BY.
> 5.Se os dados das tabelas mudarem, a view reflete a mudança na próxima consulta; ela não guarda cópia. Se uma tabela base for removida ou uma coluna usada for renomeada, a view deixa de funcionar.

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
|  |  |  |
|  |  |  |
|  |  |  |

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

- [ ] utilizei o banco do projeto;
- [ ] criei pelo menos 3 Views;
- [ ] pelo menos uma View usa JOIN;
- [ ] pelo menos uma View usa agregação ou resumo;
- [ ] consultei as Views;
- [ ] utilizei `CREATE OR REPLACE VIEW`;
- [ ] pratiquei `DROP VIEW`;
- [ ] validei as Views;
- [ ] testei mudança em tabela base;
- [ ] compreendo de onde vêm os dados de cada View;
- [ ] salvei `SPRINT3-5.md`;
- [ ] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Continue utilizando:

```text
team-XX
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
