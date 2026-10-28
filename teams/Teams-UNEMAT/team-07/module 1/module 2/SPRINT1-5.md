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

> Talita de Oliveira Leite Sete 

**Branch:**

```text
team-07
```

**Nome do banco:**

```text
secretaria_saude
```

**Tema do projeto:**

> Secretaria Municipal de Saúde (pacientes, atendimentos, prontuários, estoque e óbitos)
---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | paciente | id_paciente | -- |
| 2 | profissional | id_profissional | -- |
| 3 | unidade_saude | id_unidade | -- |
| 4 | atendimento | id_atendimento | id_paciente, id_profissional, id_unidade |
| 5 | prontuario | id_prontuario | id_paciente, id_atendimento |
| 6 | estoque_item | id_item | id_unidade |
| 7 | obito | id_obito | id_paciente, unidade_responsavel |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| paciente | 1:N | atendimento	 | atendimento.id_paciente |
| profissional | 1:N | atendimento | atendimento.id_profissional |
| unidade_saude | 1:N | atendimento | atendimento.id_unidade |
| atendimento | 1:1 | prontuario | prontuario.id_atendimento (UNIQUE) |
| paciente | 1:N | prontuario | prontuario.id_paciente | 
| unidade_saude | 1:N | estoque_item | estoque_item.id_unidade | 
| paciente | 1:1 | obito | obito.id_paciente (UNIQUE) | 
| unidade_saude | 1:N | obito | obito.unidade_responsavel | 

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

> Quais pacientes possuem prontuário e qual o diagnóstico registrado?

**Tabelas utilizadas:**

```text
paciente, prontuario
```

**PK/FK utilizadas:**

```text
paciente.id_paciente (PK) = prontuario.id_paciente (FK)
```

**SQL:**

```sql
-- ============================================================
-- INNER JOIN 1
-- Quais pacientes possuem prontuário e qual o diagnóstico registrado?
-- ============================================================
SELECT p.id_paciente, p.nome AS paciente, pr.diagnostico, pr.data_registro
FROM paciente AS p
INNER JOIN prontuario AS pr ON pr.id_paciente = p.id_paciente;
```

**Explique o resultado:**

> Retorna 11 linhas, uma por prontuário, com nome do paciente e diagnóstico. Maria Aparecida aparece duas vezes porque tem dois prontuários (hipertensão em setembro e avaliação cardiológica em outubro). Só entram pacientes que têm prontuário.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais itens existem em estoque em cada unidade de saúde?

```sql
-- ============================================================
-- INNER JOIN 2
-- Quais itens existem em estoque em cada unidade de saúde?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS item, e.tipo, e.quantidade, e.validade
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade;
```

**Explique:**

> Une unidade_saude e estoque_item por id_unidade. Retorna 10 itens com o nome da unidade, e não só o id. Se uma unidade não tivesse item, ela não apareceria.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quantos atendimentos cada unidade teve, incluindo unidades sem nenhum?

```sql
-- ============================================================
-- LEFT JOIN
-- Quantos atendimentos cada unidade teve, incluindo unidades sem nenhum?
-- ============================================================
SELECT u.id_unidade, u.nome AS unidade, u.tipo,
       COUNT(a.id_atendimento) AS total_atendimentos
FROM unidade_saude AS u
LEFT JOIN atendimento AS a ON a.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome, u.tipo
ORDER BY total_atendimentos DESC;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Mantém todas as 6 unidades, mesmo sem atendimento. O Posto de Saúde Rural Boa Vista aparece com 0, o que um INNER JOIN esconderia. Usei COUNT(a.id_atendimento) e não COUNT(*), porque COUNT(*) contaria 1 para a unidade sem atendimento.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais atendimentos ainda não possuem prontuário?

```sql
-- ============================================================
-- RIGHT JOIN
-- Quais atendimentos ainda não possuem prontuário?
-- ============================================================
SELECT a.id_atendimento, a.data_hora, a.tipo_atendimento, a.status, pr.id_prontuario
FROM prontuario AS pr
RIGHT JOIN atendimento AS a ON a.id_atendimento = pr.id_atendimento
WHERE pr.id_prontuario IS NULL;
```

**Explique o resultado:**

> O RIGHT JOIN mantém todos os atendimentos (tabela da direita). Onde não há prontuário, id_prontuario fica NULL, e o WHERE ... IS NULL filtra esses casos. Retorna 4 atendimentos (ids 13 a 16), todos AGENDADOS: o prontuário só é criado depois do atendimento, então o resultado é coerente.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Quem atendeu quem, onde e quando? (atendimento, paciente, profissional, unidade_saude)

```sql
-- ============================================================
-- JOIN COM 3+ TABELAS 1 (4 tabelas)
-- Quem atendeu quem, onde e quando?
-- ============================================================
SELECT a.id_atendimento, p.nome AS paciente, pf.nome AS profissional,
       u.nome AS unidade, a.data_hora, a.tipo_atendimento, a.status
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
ORDER BY a.data_hora;
```

## Consulta 2

**Pergunta:**

> Qual diagnóstico foi registrado, por qual profissional e em qual unidade? (5 tabelas: prontuario, atendimento, paciente, profissional, unidade_saude)

```sql
-- ============================================================
-- JOIN COM 3+ TABELAS 2 (5 tabelas)
-- Qual diagnóstico foi registrado, por qual profissional e em qual unidade?
-- ============================================================
SELECT p.nome AS paciente, pr.diagnostico, pf.nome AS profissional,
       pf.setor, u.nome AS unidade
FROM prontuario AS pr
INNER JOIN atendimento   AS a  ON a.id_atendimento   = pr.id_atendimento
INNER JOIN paciente      AS p  ON p.id_paciente      = pr.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais vacinas estão com estoque baixo (< 50) e em qual unidade?

```sql
-- ============================================================
-- JOIN + WHERE
-- Quais vacinas estão com estoque baixo (< 50) e em qual unidade?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS vacina, e.quantidade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.tipo = 'VACINA' AND e.quantidade < 50;
```

**Explique o filtro:**

> O JOIN traz o nome da unidade e o WHERE mantém só itens do tipo VACINA com menos de 50 unidades. Retorna Hepatite B na UBS Vila Nova (45) e Influenza no Posto Rural (8). O filtro roda depois da junção, sobre as linhas já combinadas.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais foram os registros clínicos mais recentes?

```sql
-- ============================================================
-- JOIN + ORDER BY
-- Quais foram os registros clínicos mais recentes?
-- ============================================================
SELECT pr.data_registro, p.nome AS paciente, pr.diagnostico
FROM prontuario AS pr
INNER JOIN paciente AS p ON p.id_paciente = pr.id_paciente
ORDER BY pr.data_registro DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Quantos itens e quantas unidades em estoque cada unidade possui?

```sql
-- ============================================================
-- JOIN + GROUP BY + AGREGAÇÃO
-- Quantos itens e quantas unidades em estoque cada unidade possui?
-- ============================================================
SELECT u.nome AS unidade,
       COUNT(*)          AS itens_cadastrados,
       SUM(e.quantidade) AS total_unidades_em_estoque,
       MIN(e.validade)   AS validade_mais_proxima
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome
ORDER BY total_unidades_em_estoque DESC;
```

**Explique o agrupamento:**

> Agrupa por unidade. COUNT(*) conta os itens cadastrados, SUM(quantidade) soma as unidades em estoque e MIN(validade) mostra a validade mais próxima. A UBS Centro lidera com 920 unidades; o Posto Rural tem 8.

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

> Quais atendimentos estão agendados nos próximos 15 dias, com paciente, telefone, profissional e unidade?

```sql
-- ============================================================
-- CONSULTA MAIS ÚTIL
-- Agenda dos próximos 15 dias para a recepção
-- (data fixa para o resultado ser reproduzível; em uso real, troque por CURDATE())
-- ============================================================
SET @data_ref = '2026-10-27';
SELECT a.data_hora, p.nome AS paciente, p.telefone,
       pf.nome AS profissional, pf.setor, u.nome AS unidade, a.tipo_atendimento
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
WHERE a.status = 'AGENDADO'
  AND a.data_hora >= @data_ref
  AND a.data_hora <  @data_ref + INTERVAL 15 DAY
ORDER BY a.data_hora;
```

**Por que ela é útil?**

> A recepção tem a agenda cronológica com o nome e o telefone do paciente, o profissional e o local, sem consultar várias tabelas. Retorna 4 agendamentos (28/10 a 10/11), e o telefone permite confirmar a presença.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
-- ============================================================
-- INNER JOIN 1
-- Quais pacientes possuem prontuário e qual o diagnóstico registrado?
-- ============================================================
SELECT p.id_paciente, p.nome AS paciente, pr.diagnostico, pr.data_registro
FROM paciente AS p
INNER JOIN prontuario AS pr ON pr.id_paciente = p.id_paciente;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Tabelas: paciente e prontuario.
PK: paciente.id_paciente.
FK: prontuario.id_paciente, que referencia paciente.id_paciente.
O ON define como as linhas se casam: cada prontuário é ligado ao paciente de mesmo id_paciente.
Se o ON estivesse errado ou ausente, o banco combinaria todos com todos. Testei: sem condição o resultado é de 110 linhas (10 pacientes × 11 prontuários), contra 11 com o ON correto. Um ON trocado (ex.: p.id_paciente = pr.id_prontuario) devolveria diagnósticos ligados ao paciente errado, sem dar erro.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- ============================================================
-- LEFT JOIN
-- Quantos atendimentos cada unidade teve, incluindo unidades sem nenhum?
-- ============================================================
SELECT u.id_unidade, u.nome AS unidade, u.tipo,
       COUNT(a.id_atendimento) AS total_atendimentos
FROM unidade_saude AS u
LEFT JOIN atendimento AS a ON a.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome, u.tipo
ORDER BY total_atendimentos DESC;
```

**Resultado esperado:**

>  6 linhas (uma por unidade); UBS Vila Nova 6, Hospital Municipal 4, UBS Centro 2, UPA 2, CAPS 1, Posto Rural 0. A soma é 15, igual ao total de atendimentos.

**Resultado obtido:**

> SELECT u.id_unidade, u.nome AS unidade, u.tipo,        COUNT(a.id_atendimento) AS total_atendimentos FROM unidade_saude AS u LEFT JOIN atendimento AS a ON a.id_unidade = u.id_unidade GROUP BY u.id_unidade, u.nome, u.tipo ORDER BY total_atendimentos DESC LIMIT 0, 1000	16 row(s) returned	0.016 sec / 0.000 sec


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
