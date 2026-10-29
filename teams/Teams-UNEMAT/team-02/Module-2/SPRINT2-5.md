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

> Geovanna Gaspar Ribeiro

**Banco utilizado:**

```text
gerenciamento_incidentes
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

1. Quais dispositivos têm mais alertas registrados do que a média de alertas por dispositivo?
2. Quais analistas já têm pelo menos um incidente atribuído?
3. Quais dispositivos nunca tiveram nenhum incidente registrado?
4. Quais tipos de ameaça possuem pelo menos um incidente vinculado?
5. Qual foi o incidente com a data de identificação mais antiga registrada no sistema?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais dispositivos têm mais alertas registrados do que a média de alertas por dispositivo?

```sql
SELECT d.nome_dispositivo,
       COUNT(al.id_alerta) AS total_alertas
FROM dispositivos d
JOIN alertas al ON al.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(al.id_alerta) > (
    SELECT AVG(qtd)
    FROM (
        SELECT COUNT(*) AS qtd
        FROM alertas
        GROUP BY id_dispositivo
    ) AS media_por_dispositivo
);
```

**Explique primeiro a consulta interna:**

> A subconsulta mais interna (SELECT COUNT(*) AS qtd FROM alertas GROUP BY id_dispositivo) conta quantos alertas cada dispositivo tem. A subconsulta em volta dela (SELECT AVG(qtd) FROM (...) AS media_por_dispositivo) calcula a média dessas contagens ou seja, a média de alertas por dispositivo, considerando só os dispositivos que têm ao menos um alerta.

**Depois explique a consulta externa:**

> A consulta externa junta dispositivos com alertas, agrupa por dispositivo e conta os alertas de cada um (COUNT(al.id_alerta)). O HAVING compara essa contagem por grupo com o valor único retornado pela subconsulta (a média geral), mantendo no resultado apenas os dispositivos cujo total de alertas seja maior que a média.
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

> Quais analistas já têm pelo menos um incidente atribuído?

```sql
SELECT nome
FROM analistas
WHERE id_analista IN (
    SELECT id_analista
    FROM incidentes
    WHERE id_analista IS NOT NULL
);
```

**Explique:**

> A subconsulta retorna a lista de todos os id_analista que aparecem na tabela incidentes (ignorando incidentes sem analista atribuído). A consulta externa então seleciona, em analistas, apenas os nomes cujo id_analista está presente nessa lista.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais dispositivos nunca tiveram nenhum incidente registrado?

```sql
SELECT nome_dispositivo
FROM dispositivos
WHERE id_dispositivo NOT IN (
    SELECT id_dispositivo
    FROM incidentes
    WHERE id_dispositivo IS NOT NULL
);
```

**Que registros você está procurando?**

> Dispositivos cujo id_dispositivo não aparece em nenhuma linha da tabela incidentes ou seja, dispositivos que, até o momento, nunca sofreram nenhum incidente registrado. (O filtro WHERE id_dispositivo IS NOT NULL na subconsulta é importante: se algum incidente tivesse id_dispositivo nulo, o NOT IN poderia deixar de retornar qualquer linha, por causa de como o SQL trata NULL em comparações.)

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais tipos de ameaça possuem pelo menos um incidente vinculado?

```sql
SELECT t.nome_ameaca
FROM tipos_ameacas t
WHERE EXISTS (
    SELECT 1
    FROM incidentes i
    WHERE i.id_ameaca = t.id_ameaca
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais alertas ainda não geraram nenhum incidente vinculado a eles?

```sql
SELECT al.titulo
FROM alertas al
WHERE NOT EXISTS (
    SELECT 1
    FROM incidentes i
    WHERE i.id_alerta = al.id_alerta
);
```

**Explique a diferença em relação a `EXISTS`:**

> EXISTS mantém as linhas em que a subconsulta encontra pelo menos uma correspondência; NOT EXISTS faz o oposto mantém apenas as linhas em que a subconsulta não encontra nenhuma correspondência. Aqui, isso identifica os alertas que foram registrados mas que ainda não resultaram em nenhum incidente formal.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual foi o incidente com a data de identificação mais antiga registrada no sistema?

```sql
SELECT titulo, data_identificacao
FROM incidentes
WHERE data_identificacao = (
    SELECT MIN(data_identificacao)
    FROM incidentes
);
```

**Explique:**

> A subconsulta calcula o menor valor de data_identificacao em toda a tabela incidentes. A consulta externa então busca a(s) linha(s) cujo data_identificacao seja exatamente igual a esse valor mínimo, retornando o(s) incidente(s) mais antigo(s) com título e data, não apenas a data isolada.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Para cada analista, qual foi o incidente mais recente atribuído a ele?

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente_mais_recente,
       i.data_identificacao
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.data_identificacao = (
    SELECT MAX(i2.data_identificacao)
    FROM incidentes i2
    WHERE i2.id_analista = a.id_analista
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> a.id_analista. A subconsulta não é calculada uma única vez para o banco inteiro ela é executada de novo para cada analista trazido pela consulta externa, filtrando incidentes apenas pelos incidentes daquele analista específico e retornando a maior data entre eles. É esse uso de a.id_analista dentro da subconsulta que caracteriza a correlação.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais analistas têm pelo menos um incidente atribuído?

### JOIN

```sql
SELECT DISTINCT a.nome
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista;
```

### SUBQUERY

```sql
SELECT nome
FROM analistas
WHERE id_analista IN (
    SELECT id_analista
    FROM incidentes
    WHERE id_analista IS NOT NULL
);
```

### Qual abordagem ficou mais compreensível?

> A versão com SUBQUERY (IN) é mais direta pra essa pergunta específica, porque já retorna cada analista uma única vez naturalmente. A versão com JOIN precisa do DISTINCT para não repetir o nome do analista uma vez para cada incidente que ele tiver sem o DISTINCT, um analista com 3 incidentes apareceria 3 vezes no resultado.

---

## Pergunta 2

> Quais dispositivos nunca tiveram nenhum alerta registrado?

### JOIN

```sql
SELECT d.nome_dispositivo
FROM dispositivos d
LEFT JOIN alertas al ON al.id_dispositivo = d.id_dispositivo
WHERE al.id_alerta IS NULL;
```

### SUBQUERY

```sql
SELECT nome_dispositivo
FROM dispositivos
WHERE id_dispositivo NOT IN (
    SELECT id_dispositivo
    FROM alertas
    WHERE id_dispositivo IS NOT NULL
);
```

### Comparação

> As duas resolvem o mesmo problema (um "anti-join": achar o que não tem correspondência). A versão com LEFT JOIN + IS NULL é o padrão mais tradicional em SQL para esse tipo de pergunta e costuma ter melhor desempenho em bancos grandes. Já a versão com NOT IN é mais legível para quem está começando, mas exige cuidado: se a subconsulta puder retornar algum valor NULL, o NOT IN deixa de funcionar corretamente por isso o filtro WHERE id_dispositivo IS NOT NULL foi incluído dentro da subconsulta.

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
SELECT a.nome AS analista,
       i.titulo AS incidente_mais_recente,
       i.data_identificacao
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.data_identificacao = (
    SELECT MAX(i2.data_identificacao)
    FROM incidentes i2
    WHERE i2.id_analista = a.id_analista
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1. Como essa subconsulta é correlacionada, ela não roda "de uma vez só" antes da consulta externa o MySQL executa a consulta externa linha a linha, e para cada linha (cada combinação analista + incidente) roda a subconsulta interna usando o id_analista daquela linha específica.
> 2. Um único valor por execução: a maior data_identificacao entre os incidentes daquele analista específico.
> 3. A consulta externa compara a data_identificacao do incidente da linha atual com esse valor máximo; se forem iguais, significa que aquele é o incidente mais recente daquele analista, e a linha é mantida no resultado.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT titulo, data_identificacao
FROM incidentes
WHERE data_identificacao = (
    SELECT MIN(data_identificacao)
    FROM incidentes
);
```

**Alteração realizada:**

> Troquei MIN por MAX na subconsulta, para buscar o incidente mais recente em vez do mais antigo:

**Mudança observada:**

> A consulta com MIN retorna o incidente cadastrado há mais tempo, e a com MAX retorna o incidente identificado mais recentemente.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

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
- [x] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.

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
