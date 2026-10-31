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

> Escreva aqui.
Ylma Cristina Souza Lopes
**Banco utilizado:**

```text
Clinica_Ser
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
|Pacientes com exames agendados, médico responsável e tipo de exame|Permite visualizar rapidamente todas as informações dos atendimentos agendados em uma única consulta.|Sim|
|Exames e seus respectivos resultados (laudos)|Facilita a consulta de exames já realizados e os laudos emitidos pela clínica.|Sim|
|Total arrecadado por convênio (SUM(preco) agrupado por convênio)|Auxilia no controle financeiro e na análise dos convênios que geram maior receita.|Sim|
|Quantidade de agendamentos por médico (COUNT)|Permite acompanhar a demanda de cada médico e analisar a distribuição dos atendimentos.|Sim|

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
vw_agendamentos_detalhados
```

**Pergunta que ela representa:**

> Escreva aqui.
Quais são os detalhes dos agendamentos, incluindo data/hora, nome do paciente, nome do médico e tipo de exame?
**SQL:**

```sql
-- Cole aqui.
CREATE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

```

**Tabelas utilizadas:**

> Escreva aqui.
Agendamento, Paciente, Medico, Exame
**Como consultar essa VIEW?**

```sql
-- Cole aqui.
SELECT * FROM vw_agendamentos_detalhados;

```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Escreva aqui.
Qual é o faturamento total e a quantidade de exames realizados por tipo de exame?
```sql
-- Cole aqui.
CREATE VIEW vw_faturamento_por_exame AS
SELECT e.tipo_exame, COUNT(a.id_agendamento) AS qtd_realizada, SUM(e.preco) AS faturamento_total
FROM Exame e
LEFT JOIN Agendamento a ON e.id_exame = a.id_exame
GROUP BY e.tipo_exame;
```

**Explique:**

> Escreva aqui.
Esta view sumariza o número de exames realizados e o faturamento gerado para cada tipo de exame, agrupando os dados pelo tipo de exame. Isso ajuda a analisar o desempenho financeiro e a demanda por exames específicos.
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
vw_laudos_pendentes
```

```sql
-- Cole aqui.
CREATE VIEW vw_laudos_pendentes AS
SELECT a.data_hora, p.nome, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Exame e ON a.id_exame = e.id_exame
LEFT JOIN Resultado r ON a.id_exame = r.id_exame
WHERE r.id_resultado IS NULL AND a.data_hora < NOW();

```

**Por que essa VIEW é útil?**

> Escreva aqui.
Ela exibe os agendamentos passados que ainda não possuem resultados (laudos) registrados, o que é fundamental para acompanhar exames pendentes de análise e garantir que os laudos sejam gerados em tempo hábil.
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
-- Cole aqui.
SELECT * FROM vw_agendamentos_detalhados;
SELECT * FROM vw_agendamentos_detalhados
WHERE medico = 'Dr. João Silva';

```

**Resultado observado:**

> Escreva aqui.
Foi retornada a lista completa dos agendamentos com detalhes, incluindo data, paciente, médico, especialidade e tipo de exame. Com o filtro pelo médico, foram mostrados apenas os agendamentos relacionados a esse profissional específico.


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
-- Cole aqui.
CREATE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW ...
CREATE OR REPLACE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, m.especialidade, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

```

**O que mudou?**

> Escreva aqui.
Foi adicionada a coluna m.especialidade à view, para mostrar também a especialidade do médico em cada agendamento, enriquecendo a informação disponível.
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
-- Cole aqui.
-- Criação da view temporária
CREATE VIEW vw_teste AS
SELECT * FROM Convenio;
-- Remoção da view
DROP VIEW vw_teste;

```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> Escreva aqui.
DROP VIEW remove apenas a definição da view, sem afetar os dados das tabelas subjacentes. Já DROP TABLE remove completamente a tabela e todos os seus dados do banco de dados.
---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_agendamentos_detalhados
2. vw_faturamento_por_exame
3. vw_laudos_pendentes

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_agendamento_detalhados
```

**Alteração realizada:**

```sql
-- Cole aqui.
-- Inserir um novo agendamento (exemplo)
INSERT INTO Agendamento (id_agendamento, data_hora, id_paciente, id_medico, id_exame)
VALUES (101, '2026-11-01 14:00:00', 10, 5, 3);

```

**Resultado observado:**

> Escreva aqui.
Ao consultar a view vw_agendamentos_detalhados antes da inserção, o novo agendamento não aparece. Após a inserção do novo registro na tabela base Agendamento, ao consultar novamente a view, o novo agendamento com detalhes do paciente, médico e exame já é exibido, evidenciando que a view reflete dados atualizados diretamente das tabelas base.
---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
-- Cole aqui a definição.
CREATE OR REPLACE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, m.especialidade, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> Escreva aqui.
1. De quais tabelas ela depende: Depende das tabelas Agendamento, Paciente, Medico e Exame.

2. Qual relacionamento utiliza: Utiliza relacionamentos do tipo INNER JOIN entre Agendamento e as outras três tabelas, através dos campos id_paciente, id_medico e id_exame.

3. Quais campos apresenta: Apresenta id_agendamento, data_hora do agendamento, nome do paciente, nome do médico, especialidade do médico e tipo do exame.

4. Qual problema resolve: Consolida informações distribuídas em várias tabelas em uma visão única, facilitando consultas rápidas e detalhadas sobre os agendamentos sem precisar fazer vários joins repetidamente.

5. O que muda se os dados das tabelas originais forem alterados: Como a view é baseada diretamente nas tabelas, quaisquer inserções, exclusões ou atualizações nessas tabelas serão refletidas automaticamente na view na próxima consulta, mantendo os dados sempre atualizados.


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
|View não atualiza com dados novos|A view foi criada com dados estáticos (materialized view) ou erro na consulta|Usar views baseadas em tabelas (views normais) ou atualizar a view materializada|
|Erro ao criar view por falta de permissão|Usuário não tem permissão para acessar tabelas envolvidas|Conceder permissões necessárias para o usuário no banco|
|Dados inconsistentes na view|Dados inconsistentes nas tabelas base ou joins incorretos|Verificar integridade dos dados e corrigir as condições dos joins|

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

- [V] utilizei o banco do projeto;
- [V] criei pelo menos 3 Views;
- [V] pelo menos uma View usa JOIN;
- [V] pelo menos uma View usa agregação ou resumo;
- [V] consultei as Views;
- [V] utilizei `CREATE OR REPLACE VIEW`;
- [V] pratiquei `DROP VIEW`;
- [V] validei as Views;
- [V] testei mudança em tabela base;
- [V] compreendo de onde vêm os dados de cada View;
- [V] salvei `SPRINT3-5.md`;
- [V] salvei `SPRINT3-5.sql`.

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
