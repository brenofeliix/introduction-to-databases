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

> Escreva aqui.
Ylma Cristina Souza Lopes
**Banco utilizado:**

```text
Clinica_Ser
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

1. Quais exames possuem preço acima da média de todos os exames?
2. Quais médicos possuem agendamentos registrados no sistema?
3. Quais pacientes já realizaram pelo menos um exame?
4. Qual exame possui o maior valor cadastrado?
5. Quais convênios possuem pacientes com exames realizados?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Escreva aqui.
Quais exames possuem preço acima da média de preços dos exames cadastrados?
```sql
-- Cole aqui.
SELECT tipo_exame, preco
FROM Exame
WHERE preco > (
    SELECT AVG(preco)
    FROM Exame
);
```

**Explique primeiro a consulta interna:**

> Escreva aqui.
A subconsulta interna SELECT AVG(preco) FROM Exame calcula o preço médio de todos os exames cadastrados na clínica.

**Depois explique a consulta externa:**

> Escreva aqui.
A consulta externa compara o preço de cada exame com a média calculada pela subconsulta. Somente os exames com valor superior à média são exibidos no resultado.
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

> Escreva aqui.
Quais médicos possuem agendamentos registrados no sistema?
```sql
-- Cole aqui.
SELECT nome
FROM Medico
WHERE id_medico IN (
SELECT id_medico
FROM Agendamento
);

**Explique:**

> Escreva aqui.
A subconsulta retorna todos os identificadores dos médicos que aparecem na tabela Agendamento. O operador IN verifica quais médicos da tabela Medico possuem seu id_medico presente nessa lista. Como resultado, são exibidos apenas os médicos que possuem pelo menos um agendamento registrado.
---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Escreva aqui.
Quais pacientes ainda não possuem nenhum agendamento cadastrado?
```sql
-- Cole aqui.
SELECT nome
FROM Paciente
WHERE id_paciente NOT IN (
    SELECT id_paciente
    FROM Agendamento
);
```

**Que registros você está procurando?**

> Escreva aqui.
Estou procurando os pacientes que estão cadastrados no sistema, mas que ainda não realizaram nenhum agendamento de exame. Esses pacientes não aparecem na tabela Agendamento.
---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.
Quais convênios possuem pelo menos um paciente cadastrado?
```sql
-- Cole aqui.
SELECT nome_convenio
FROM Convenio c
WHERE EXISTS (
    SELECT 1
    FROM Paciente p
    WHERE p.id_convenio = c.id_convenio
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Escreva aqui.
Quais exames ainda não possuem resultado emitido?
```sql
-- Cole aqui.
SELECT tipo_exame
FROM Exame e
WHERE NOT EXISTS (
    SELECT 1
    FROM Resultado r
    WHERE r.id_exame = e.id_exame
);
```

**Explique a diferença em relação a `EXISTS`:**

> Escreva aqui.
Enquanto o EXISTS retorna registros quando a subconsulta encontra pelo menos uma correspondência, o NOT EXISTS retorna registros apenas quando nenhuma correspondência é encontrada. Neste caso, são exibidos os exames que ainda não possuem laudos cadastrados na tabela Resultado.
---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Escreva aqui.
Qual é o paciente mais velho cadastrado na clínica?
```sql
-- Cole aqui.
SELECT nome, data_nascimento
FROM Paciente
WHERE data_nascimento = (
    SELECT MIN(data_nascimento)
    FROM Paciente
);
```

**Explique:**

> Escreva aqui.
A subconsulta utiliza a função MIN() para localizar a menor data de nascimento cadastrada. Como datas mais antigas representam pessoas mais velhas, a consulta externa retorna o paciente ou os pacientes que possuem essa data de nascimento, identificando assim os mais velhos da clínica.
---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Escreva aqui.
Quantos agendamentos cada paciente possui cadastrados no sistema?
```sql
-- Cole aqui.
SELECT p.nome,
       (SELECT COUNT(*)
        FROM Agendamento a
        WHERE a.id_paciente = p.id_paciente) AS Total_Agendamentos
FROM Paciente p;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> Escreva aqui.
A coluna utilizada é p.id_paciente. A subconsulta depende desse valor da consulta externa para contar apenas os agendamentos pertencentes a cada paciente. Por isso ela é chamada de subconsulta correlacionada, pois seu resultado varia para cada linha retornada pela consulta principal.
---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Escreva aqui.
Qual convênio está associado a cada paciente?
### JOIN

```sql
-- Cole aqui.
SELECT p.nome, c.nome_convenio
FROM Paciente p
INNER JOIN Convenio c
ON p.id_convenio = c.id_convenio;
```

### SUBQUERY

```sql
-- Cole aqui.
SELECT nome,
       (SELECT nome_convenio
        FROM Convenio c
        WHERE c.id_convenio = p.id_convenio) AS Convenio
FROM Paciente p;
```

### Qual abordagem ficou mais compreensível?

> Escreva aqui e justifique.
A abordagem com JOIN ficou mais compreensível porque mostra explicitamente o relacionamento entre as tabelas e costuma apresentar melhor desempenho quando há grande quantidade de registros.
---

## Pergunta 2

> Escreva aqui.
Quantos agendamentos cada paciente possui?
### JOIN

```sql
-- Cole aqui.
SELECT p.nome, COUNT(a.id_agendamento) AS Total_Agendamentos
FROM Paciente p
LEFT JOIN Agendamento a
ON p.id_paciente = a.id_paciente
GROUP BY p.nome;
```

### SUBQUERY

```sql
-- Cole aqui.
SELECT p.nome,
       (SELECT COUNT(*)
        FROM Agendamento a
        WHERE a.id_paciente = p.id_paciente) AS Total_Agendamentos
FROM Paciente p;
```

### Comparação

> Escreva aqui.
As duas consultas produzem o mesmo resultado. A solução com JOIN é geralmente mais eficiente para análise de grandes volumes de dados, pois utiliza agrupamento em uma única consulta. Já a solução com subconsulta correlacionada é mais intuitiva para entender a lógica de contagem individual por paciente, mas pode ter desempenho inferior em tabelas muito grandes.
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
-- Cole aqui.
SELECT tipo_exame, preco
FROM Exame
WHERE preco > (
    SELECT AVG(preco)
    FROM Exame
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> Escreva aqui.
1. Qual consulta é executada primeiro?

A consulta interna é executada primeiro:

SQL
SELECT AVG(preco)
FROM Exame;

Ela calcula o preço médio de todos os exames cadastrados.

2. Qual valor ou conjunto de valores ela retorna?

Ela retorna um único valor numérico correspondente à média dos preços dos exames. Por exemplo:

Plain Text
250,00

3. Como esse resultado é utilizado pela consulta externa?

O valor retornado pela subconsulta é utilizado como critério de comparação na cláusula WHERE. A consulta externa exibe apenas os exames cujo preço seja maior que a média calculada.
---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
-- Cole aqui.
SELECT tipo_exame, preco
FROM Exame
WHERE preco > (
    SELECT AVG(preco)
    FROM Exame
);
```

**Alteração realizada:**

> Escreva aqui.
Foi alterado o operador de comparação de > para .
**Mudança observada:**

> Escreva aqui.
Na consulta original foram exibidos os exames com preço acima da média. Após a alteração, passaram a ser exibidos os exames com preço abaixo da média. Isso demonstra como uma pequena mudança no filtro altera completamente o conjunto de resultados.
---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|Subconsulta retornando resultado vazio|Não existiam registros que atendessem ao filtro|Inserir mais dados ou revisar a condição utilizada|
|Erro de relacionamento em consultas|Uso incorreto de PK e FK|Verificar os campos de ligação entre as tabelas|
|Resultado inesperado em agregações|Agrupamento inadequado ou ausência de GROUP BY|Revisar a lógica da consulta e os campos agrupados|

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

- [V] utilizei o banco do projeto;
- [V] criei subconsulta com comparação;
- [V] utilizei `IN`;
- [V] utilizei `NOT IN`;
- [V] utilizei `EXISTS`;
- [V] utilizei `NOT EXISTS`;
- [V] utilizei `MAX` ou `MIN`;
- [V] criei subconsulta correlacionada;
- [V] resolvi duas perguntas usando JOIN e SUBQUERY;
- [V] expliquei o raciocínio;
- [V] testei no MySQL Workbench;
- [V] consigo explicar as consultas presencialmente;
- [V] salvei `SPRINT2-5.md`;
- [V] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-XX
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
