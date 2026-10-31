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

> Geovanna Gaspar Ribeiro

**Branch:**

```text
team-02
```

**Nome do banco:**

```text
gerenciamento_incidentes
```

**Tema do projeto:**

> Sistema de gerenciamento de incidentes de segurança da informação, no qual analistas acompanham incidentes registrados, cada um associado a um tipo de ameaça e a um dispositivo afetado.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 |analistas  | id_analista | -- |
| 2 |tipos_ameacas | id_ameaca | -- |
| 3 |dispositivos | id_dispositivo | -- |
| 4 | incidentes | id_incidente | 	id_analista → analistas, id_ameaca → tipos_ameacas, id_dispositivo → dispositivos |


---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| analistas | 1:N | incidentes | incidentes.id_analista |
| tipos_ameacas | 1:N | incidentes | incidentes.id_ameaca |
| dispositivos | 1:N | incidentes | incidentes.id_dispositivo |


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

> Quais incidentes estão sob responsabilidade de cada analista, e qual o status atual de cada um?

**Tabelas utilizadas:**

```text
analistas, incidentes
```

**PK/FK utilizadas:**

```text
analistas.id_analista (PK) ligado a incidentes.id_analista (FK)
```

**SQL:**

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
ORDER BY a.nome;
```

**Explique o resultado:**

> Cada linha do resultado combina um analista com um incidente sob sua responsabilidade. Como é INNER JOIN, analistas que não têm nenhum incidente atribuído não aparecem no resultado só entram combinações que existem nas duas tabelas

## Consulta INNER JOIN 2

**Pergunta:**

> Quais dispositivos estiveram envolvidos em quais incidentes, e qual a severidade registrada em cada caso?

```sql
SELECT d.nome_dispositivo AS dispositivo,
       i.titulo AS incidente,
       i.severidade
FROM dispositivos d
INNER JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
ORDER BY d.nome_dispositivo;
```

**Explique:**

> Junta cada dispositivo aos incidentes registrados nele, através do id_dispositivo. Dispositivos sem nenhum incidente vinculado não aparecem, pois o INNER JOIN só retorna linhas que possuem correspondência nas duas tabelas.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais tipos de ameaça existem cadastrados no sistema, incluindo os que ainda não tiveram nenhum incidente registrado?

```sql
SELECT t.nome_ameaca AS tipo_ameaca,
       i.titulo AS incidente
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
ORDER BY t.nome_ameaca;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite ver todos os tipos de ameaça cadastrados, mesmo os que nunca geraram nenhum incidente. Para esses casos, a coluna incidente aparece como NULL, indicando ausência de correspondência na tabela da direita (incidentes). Com INNER JOIN esses tipos de ameaça simplesmente não apareceriam no resultado.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais analistas existem cadastrados no sistema, incluindo aqueles que não têm nenhum incidente atribuído no momento?

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM incidentes i
RIGHT JOIN analistas a ON i.id_analista = a.id_analista
ORDER BY a.nome;
```

**Explique o resultado:**

> Como o RIGHT JOIN mantém todos os registros da tabela à direita (analistas), todo analista cadastrado aparece no resultado, mesmo que não tenha nenhum incidente sob sua responsabilidade nesse caso, as colunas incidente e status aparecem como NULL. É o mesmo efeito de um LEFT JOIN com as tabelas invertidas na cláusula FROM.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Quais incidentes cada analista está tratando, e em qual dispositivo cada incidente ocorreu?

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       d.nome_dispositivo AS dispositivo
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
INNER JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
ORDER BY a.nome;
```

## Consulta 2

**Pergunta:**

> Quais analistas estão tratando incidentes de qual tipo de ameaça, e qual a severidade de cada um?

```sql
SELECT a.nome AS analista,
       t.nome_ameaca AS tipo_ameaca,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
INNER JOIN tipos_ameacas t ON i.id_ameaca = t.id_ameaca
ORDER BY a.nome;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais incidentes de severidade crítica estão sob responsabilidade de qual analista?

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.severidade = 'CRITICA';
```

**Explique o filtro:**

> O JOIN primeiro combina analistas com seus incidentes; depois o WHERE i.severidade = 'CRITICA' remove do resultado qualquer linha em que a severidade não seja 'CRITICA', mantendo apenas os incidentes mais graves.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais incidentes ocorreram em quais dispositivos, ordenados da data de identificação mais recente para a mais antiga?

```sql
SELECT d.nome_dispositivo AS dispositivo,
       i.titulo AS incidente,
       i.data_identificacao
FROM dispositivos d
INNER JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
ORDER BY i.data_identificacao DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Quantos incidentes já encerrados cada analista resolveu?

```sql
SELECT a.nome AS analista,
       COUNT(i.id_incidente) AS incidentes_encerrados
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.status = 'ENCERRADO'
GROUP BY a.id_analista, a.nome
ORDER BY incidentes_encerrados DESC;
```

**Explique o agrupamento:**

> O JOIN liga cada incidente ao seu analista; o WHERE filtra apenas incidentes com status 'ENCERRADO'; e o GROUP BY a.id_analista, a.nome faz com que o COUNT(i.id_incidente) seja calculado separadamente para cada analista, gerando o total de incidentes que cada um já resolveu.

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

> Quais incidentes de severidade crítica estão sob responsabilidade de qual analista?
```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.severidade = 'CRITICA';
```

**Por que ela é útil?**

> Porque permite identificar rapidamente quem está tratando os incidentes de maior risco no momento, ajudando a priorizar acompanhamento e possíveis realocações de carga de trabalho entre analistas.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT a.nome AS analista,
       COUNT(i.id_incidente) AS incidentes_encerrados
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.status = 'ENCERRADO'
GROUP BY a.id_analista, a.nome
ORDER BY incidentes_encerrados DESC;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

>
  1. Tabelas que participam: analistas e incidentes.
  2. PK utilizada: analistas.id_analista.
  3. FK utilizada: incidentes.id_analista.
  4. O que a cláusula ON faz: define a condição de correspondência entre as tabelas — só combina uma linha de analistas com uma linha de incidentes quando incidentes.id_analista for igual a analistas.id_analista.
  5. O que ocorreria se a condição de relacionamento estivesse errada: se o ON comparasse colunas erradas (por exemplo, id_ameaca no lugar de id_analista), o JOIN combinaria analistas com incidentes que não são realmente deles, gerando um resultado tecnicamente executável, porém logicamente incorreto — cada analista apareceria associado a incidentes aleatórios, e o COUNT não refletiria a realidade.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT a.nome AS analista,
       COUNT(i.id_incidente) AS incidentes_encerrados
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.status = 'ENCERRADO'
GROUP BY a.id_analista, a.nome
ORDER BY incidentes_encerrados DESC;
```

**Resultado esperado:**

> Uma linha por analista que possui pelo menos um incidente encerrado, com o nome do analista e a contagem de incidentes que ele já resolveu, ordenado do analista com mais incidentes encerrados para o com menos.

**Resultado obtido:**

> Dos 5 incidentes cadastrados, apenas 1 está com status = 'ENCERRADO' (o incidente do servidor de banco de dados), e ele está sob responsabilidade da analista Beatriz Lima. Os demais analistas não aparecem no resultado porque, com INNER JOIN, só entram combinações onde existe correspondência e nenhum deles tem incidente com esse status específico. Isso confirma que o WHERE i.status = 'ENCERRADO' está funcionando corretamente e que o GROUP BY está calculando a contagem por analista, não pela tabela inteira.

A consulta retornou uma única linha:

| analista | incidentes_encerrados |
| --- | --- | 
| Beatriz Lima |	1 |

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
- [x] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.

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
