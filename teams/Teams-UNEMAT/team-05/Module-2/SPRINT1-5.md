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

> Escreva aqui.
Ylma Cristina Souza Lopes
**Branch:**

```text
team-05
```

**Nome do banco:**

```text
Clinica_Ser
```

**Tema do projeto:**

> Escreva aqui.
Clinica_Ser
---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 |Paciente|id_paciente|id_convenio|
| 2 |Medico|id_medico|----|
| 3 |Exame|id_exame|----|
| 4 |Agendamentado|id_agendamento|id_paciente, id_medico, id_exame|
| 5 |Resultado|id_resultado|id_exame|

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|Convênio|1-N|Paciente|Paciente.id_convenio|
|Paciente|1-N|Agendamento|Agendamento.id_paciente|
|Médico|1-N|Agendamento|Agendamento.id_medico|
|Exame|1-N|Agendamento|Agendamento.id_exame|
|Exame|1-N|Resultado|Resultado.id_exame|

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
Paciente
Agendamento
Médico
Exame
```

**PK/FK utilizadas:**

```text
Paciente.id_paciente (PK)
Agendamento.id_paciente (FK)

Médico.id_medico (PK)
Agendamento.id_medico (FK)

Exame.id_exame (PK)
Agendamento.id_exame (FK)
```

**SQL:**

```sql
-- Cole aqui.
SELECT p.nome AS Paciente, c.nome_convenio AS Convenio
FROM Paciente p
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio;

```

**Explique o resultado:**

> Escreva aqui.
Paciente       | Tipo_Exame | Médico            | Data_Hora
------------------------------------------------------------
Maria Silva    | Raio-X     | Dr. João Pereira  | 20/09/2026
Carlos Souza   | Tomografia | Dra. Ana Martins  | 21/09/2026

## Consulta INNER JOIN 2

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```
SELECT e.tipo_exame, r.laudo_texto
FROM Exame e
INNER JOIN Resultado r ON e.id_exame = r.id_exame;
**Explique:**

> Escreva aqui.
Esta consulta utiliza o comando INNER JOIN para relacionar as tabelas Exame e Resultado por meio da chave:

Plain Text
Exame.id_exame (PK)
Resultado.id_exame (FK)
---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
SELECT c.nome_convenio, p.nome
FROM Convenio c
LEFT JOIN Paciente p ON c.id_convenio = p.id_convenio;

```


**O que o LEFT JOIN permite visualizar neste caso?**

> Escreva aqui.
O LEFT JOIN exibe todos os convênios cadastrados na tabela Convenio, mesmo que não possuam pacientes vinculados. Quando um convênio não possui pacientes associados, o campo nome da tabela Paciente aparece como NULL. Isso permite identificar convênios sem utilização.
---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
SELECT e.tipo_exame, r.laudo_texto
FROM Resultado r
RIGHT JOIN Exame e
ON r.id_exame = e.id_exame;
```

**Explique o resultado:**

> Escreva aqui.
O RIGHT JOIN exibe todos os exames cadastrados na tabela Exame, mesmo que ainda não possuam um resultado associado. Caso um exame não tenha laudo registrado, o campo laudo_texto será exibido como NULL. Essa consulta ajuda a identificar exames pendentes de resultado.
---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Escreva aqui.
Quais pacientes possuem exames agendados, qual médico realizará o atendimento e qual o tipo de exame solicitado?

```sql
-- Cole aqui.
SELECT a.data_hora, p.nome AS Paciente, m.nome AS Medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;
```

## Consulta 2

**Pergunta:**

> Escreva aqui.
Quais pacientes realizaram exames e quais foram os resultados obtidos?
```sql
-- Cole aqui.
SELECT p.nome AS Paciente, e.tipo_exame, r.laudo_texto
FROM Resultado r
INNER JOIN Exame e ON r.id_exame = e.id_exame
INNER JOIN Agendamento a ON e.id_exame = a.id_exame
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Escreva aqui.
Quais exames estão agendados para o médico Dr. João Pereira?
```sql
-- Cole aqui.
SELECT a.data_hora, p.nome AS Paciente, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame
WHERE m.nome = 'Dr. João Pereira';
```

**Explique o filtro:**

> Escreva aqui.
A consulta utiliza INNER JOIN para relacionar agendamentos, pacientes, médicos e exames. A cláusula WHERE filtra os resultados para exibir apenas os exames vinculados ao médico "Dr. João Pereira", facilitando a consulta da agenda desse profissional.
---

# 10. JOIN + ORDER BY

**Pergunta:**

> Escreva aqui.
Quais são os pacientes que possuem exames agendados, ordenados da data mais recente para a mais antiga?
```sql
-- Cole aqui.
SELECT p.nome, a.data_hora
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
ORDER BY a.data_hora DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Escreva aqui.
Qual é o valor total arrecadado por cada convênio considerando os exames realizados pelos pacientes?
```sql
-- Cole aqui.
SELECT c.nome_convenio, SUM(e.preco) AS Total_Arrecadado
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio
INNER JOIN Exame e ON a.id_exame = e.id_exame
GROUP BY c.nome_convenio;
```

**Explique o agrupamento:**

> Escreva aqui.
A consulta relaciona as tabelas Agendamento, Paciente, Convenio e Exame. O comando GROUP BY c.nome_convenio agrupa os registros por convênio. Em seguida, a função de agregação SUM(e.preco) calcula o valor total dos exames realizados pelos pacientes de cada convênio. Isso permite analisar qual convênio gera maior receita para a clínica.
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
Qual é o valor total arrecadado por cada convênio com os exames realizados pelos pacientes da clínica?
```sql
-- Cole aqui.
SELECT c.nome_convenio, SUM(e.preco) AS Total_Arrecadado
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio
INNER JOIN Exame e ON a.id_exame = e.id_exame
GROUP BY c.nome_convenio;
```

**Por que ela é útil?**

> Escreva aqui.
Essa consulta permite analisar quanto cada convênio gera de receita para a clínica. Com essas informações, a administração pode identificar os convênios mais importantes, avaliar a rentabilidade dos atendimentos e tomar decisões estratégicas para melhorar a gestão financeira.
---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
-- Cole aqui.
SELECT a.data_hora, p.nome AS Paciente, m.nome AS Medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Escreva aqui.
1. Quais tabelas participam?
Agendamento
Paciente
Medico
Exame

2. Qual PK está sendo utilizada?
Paciente.id_paciente
Medico.id_medico
Exame.id_exame

Essas chaves primárias identificam unicamente os registros de cada tabela.

3. Qual FK está sendo utilizada?
Agendamento.id_paciente
Agendamento.id_medico
Agendamento.id_exame

Essas chaves estrangeiras conectam a tabela Agendamento às demais tabelas.

4. O que a cláusula ON faz?

A cláusula ON define a condição de relacionamento entre as tabelas, informando quais campos devem ser comparados para que os registros corretos sejam associados.
Essa condição relaciona cada agendamento ao paciente correspondente.

5. O que ocorreria se a condição de relacionamento estivesse errada?

Se a condição do ON estivesse incorreta, os dados retornados seriam inconsistentes ou incorretos. Poderiam aparecer pacientes associados a exames errados, médicos vinculados a agendamentos de outros pacientes ou até uma quantidade excessiva de registros devido a combinações indevidas entre as tabelas. Isso comprometeria a confiabilidade dos resultados da consulta.
---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- Cole aqui.
SELECT c.nome_convenio, SUM(e.preco) AS Total_Arrecadado
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio
INNER JOIN Exame e ON a.id_exame = e.id_exame
GROUP BY c.nome_convenio;
```

**Resultado esperado:**

> Escreva aqui.
Exibir o nome de cada convênio e o valor total arrecadado com os exames realizados pelos pacientes vinculados a esse convênio.

**Resultado obtido:**

> Escreva aqui.
A consulta retornou corretamente os convênios cadastrados e o valor total arrecadado para cada um deles, comprovando que os relacionamentos entre as tabelas Agendamento, Paciente, Convenio e Exame estão funcionando corretamente.
---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|Nenhum relacionamento retornado em uma consulta|Falta de registros relacionados entre as tabelas|Inserir registros consistentes respeitando as chaves estrangeiras|
|Erro de chave estrangeira ao inserir dados|Tentativa de utilizar um identificador inexistente|Inserir primeiro o registro na tabela pai e depois na tabela filha|
|Resultado vazio em consultas JOIN|Dados de teste insuficientes|Cadastrar mais pacientes, exames e agendamentos para validar as consultas|

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

- [V] utilizei o mesmo banco do Module-1;
- [V] identifiquei PKs e FKs;
- [V] produzi 2 `INNER JOIN`;
- [V] produzi 1 `LEFT JOIN`;
- [V] produzi 1 `RIGHT JOIN`;
- [V] produzi consultas com 3 ou mais tabelas;
- [V] utilizei `WHERE`;
- [V] utilizei `ORDER BY`;
- [V] utilizei agregação e `GROUP BY`;
- [V] as consultas respondem perguntas reais;
- [V] testei tudo no MySQL Workbench;
- [V] consigo explicar as consultas;
- [V] salvei `SPRINT1-5.md`;
- [V] salvei `SPRINT1-5.sql`.

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
