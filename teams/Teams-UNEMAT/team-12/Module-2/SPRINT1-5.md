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

> João Guilherme Barros de Lima

**Branch:**

```text
team-12
```

**Nome do banco:**

```text
real_estate_database
```

**Tema do projeto:**

> Site de anúncios imobiliários — cadastro de imóveis, corretores responsáveis, clientes e agendamento de visitas.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | corretor | id_corretor | — (não possui FK) |
| 2 | cliente | id_cliente | — (não possui FK) |
| 3 | imovel | id_imovel | id_corretor → corretor(id_corretor) |
| 4 | agendamento | id_agendamento | id_cliente → cliente(id_cliente); id_imovel → imovel(id_imovel) |
| 5 |  |  |  |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| corretor | 1:N | imovel | imovel.id_corretor → corretor.id_corretor |
| cliente | 1:N | agendamento | agendamento.id_cliente → cliente.id_cliente |
| imovel | 1:N | agendamento | agendamento.id_imovel → imovel.id_imovel |
|  |  |  |  |

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

> Quais imóveis estão cadastrados e qual é o corretor responsável por cada um?

**Tabelas utilizadas:**

```text
imovel, corretor
```

**PK/FK utilizadas:**

```text
PK: corretor.id_corretor
FK: imovel.id_corretor → corretor.id_corretor
```

**SQL:**

```sql
SELECT
    i.titulo,
    i.valor,
    i.cidade,
    c.nome AS corretor_responsavel
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Explique o resultado:**

> A consulta retorna apenas os imóveis que possuem um corretor correspondente na tabela corretor, trazendo junto o nome desse corretor. Como todo imóvel cadastrado possui um id_corretor válido (campo NOT NULL com FOREIGN KEY), todos os imóveis aparecem no resultado.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais agendamentos existem e qual cliente marcou cada um?

```sql
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente;
```

**Explique:**

> O INNER JOIN liga cada linha de agendamento ao cliente correspondente através da FK id_cliente. Como todo agendamento exige um cliente válido, nenhuma linha é descartada — o resultado mostra a data e o status de cada visita junto ao nome de quem a agendou.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais imóveis existem, incluindo os que nunca receberam nenhum agendamento de visita?

```sql
SELECT
    i.titulo,
    i.cidade,
    a.data_visita,
    a.status
FROM imovel AS i
LEFT JOIN agendamento AS a
    ON i.id_imovel = a.id_imovel;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> O LEFT JOIN mantém todas as linhas da tabela imovel (tabela à esquerda), mesmo quando não existe nenhum agendamento correspondente na tabela da direita. Com os dados atuais, o imóvel "Terreno amplo" não possui nenhuma visita agendada, então ele aparece no resultado com data_visita e status retornando NULL — algo que um INNER JOIN simplesmente omitiria.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais corretores existem, incluindo os que atualmente não possuem nenhum imóvel cadastrado?

```sql
SELECT
    c.nome AS corretor,
    i.titulo AS imovel
FROM imovel AS i
RIGHT JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Explique o resultado:**

> O RIGHT JOIN garante que todos os registros da tabela corretor (tabela à direita) apareçam no resultado, mesmo sem imóvel correspondente na tabela da esquerda. Como o imóvel "Cobertura Duplex" (do corretor Theus) foi removido na Sprint 3/5 do Module-1, o corretor Theus ficou sem nenhum imóvel vinculado — e por isso aparece no resultado com o campo imovel retornando NULL.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Quais clientes agendaram visita, em qual imóvel e em qual cidade?

```sql
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel;
```

## Consulta 2

**Pergunta:**

> Quais clientes agendaram visita, em qual imóvel, e quem é o corretor responsável por esse imóvel?

```sql
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais agendamentos já estão com status "Confirmado" e quem são os clientes e imóveis envolvidos?

```sql
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Confirmado';
```

**Explique o filtro:**

> O JOIN primeiro conecta as três tabelas (agendamento, cliente e imovel), formando uma linha completa para cada agendamento. Só depois disso o WHERE a.status = 'Confirmado' filtra, dentre essas linhas já combinadas, apenas aquelas em que o status é 'Confirmado'. Com os dados atuais, apenas o agendamento de id 1 atende a essa condição.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais imóveis estão anunciados por quais corretores, ordenados do mais caro para o mais barato?

```sql
SELECT
    i.titulo,
    i.valor,
    c.nome AS corretor
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor
ORDER BY i.valor DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Quantos imóveis cada corretor tem anunciado atualmente?

```sql
SELECT
    c.nome AS corretor,
    COUNT(*) AS total_imoveis
FROM corretor AS c
INNER JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.nome;
```

**Explique o agrupamento:**

> O INNER JOIN primeiro combina cada corretor com seus respectivos imóveis. Em seguida, o GROUP BY c.nome agrupa todas as linhas resultantes pelo nome do corretor, formando um bloco por corretor. O COUNT(*) conta quantas linhas (ou seja, quantos imóveis) existem dentro de cada bloco. Como o JOIN é INNER, o corretor Theus — que não possui nenhum imóvel — não aparece nesse resultado, diferente do que ocorreria com um LEFT JOIN.

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

> Quais clientes agendaram visita, em qual imóvel, e quem é o corretor responsável por esse imóvel?

```sql
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Por que ela é útil?**

> Porque reúne em uma única consulta todo o contexto operacional de uma visita: quem é o cliente, qual imóvel ele quer visitar, quem é o corretor responsável por aquele imóvel, e a data/status do agendamento. É exatamente a visão que a equipe da imobiliária usaria no dia a dia para organizar a agenda de visitas sem precisar consultar quatro telas separadas.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT
    i.titulo,
    i.valor,
    i.cidade,
    c.nome AS corretor_responsavel
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> 1. Participam as tabelas imovel (apelidada de "i") e corretor (apelidada de "c").
> 2. A PK utilizada é corretor.id_corretor, que identifica cada corretor de forma única.
> 3. A FK utilizada é imovel.id_corretor, que referencia corretor.id_corretor.
> 4. A cláusula ON define a condição de correspondência entre as duas tabelas: ela diz ao MySQL que uma linha de imovel só deve ser combinada com uma linha de corretor quando o id_corretor de ambas for igual. É o ON que transforma duas tabelas separadas em um único resultado relacionado, em vez de gerar todas as combinações possíveis entre elas.
> 5. Se a condição estivesse errada (por exemplo, ON i.id_corretor = c.id_cliente, comparando colunas que não têm relação alguma), o MySQL não geraria erro de sintaxe — ele apenas combinaria linhas que não deveriam estar relacionadas, produzindo um resultado incorreto e sem sentido (cada imóvel apareceria associado a um corretor aleatório, ou a nenhum, dependendo dos valores coincidirem ou não por acaso).

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT
    i.titulo,
    i.valor,
    i.cidade,
    c.nome AS corretor_responsavel
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Resultado esperado:**

> Uma linha para cada um dos 5 imóveis atualmente cadastrados, cada uma trazendo título, valor, cidade e o nome do corretor responsável, sem nenhum valor NULL (já que todo imóvel possui um corretor válido vinculado).

**Resultado obtido:**

> Resultado compatível com o esperado: 5 linhas retornadas, cada imóvel corretamente associado ao nome do seu corretor responsável.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro "Column 'id_imovel' in field list is ambiguous" ao consultar imovel e agendamento juntos | A coluna id_imovel existe em ambas as tabelas e foi referenciada no SELECT sem o alias da tabela de origem | Qualificar a coluna com o alias correspondente (ex: i.id_imovel ou a.id_imovel) |
| Resultado sem sentido ao testar uma condição de ON incorreta (comparando id_corretor com id_cliente) | Condição de relacionamento ligando colunas que não possuem relação de chave estrangeira entre si | Corrigida a cláusula ON para usar a FK real (i.id_corretor = c.id_corretor) |

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
