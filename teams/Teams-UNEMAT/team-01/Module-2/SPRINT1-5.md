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

> Raquel Silva dos Santos

**Branch:**

```text
team-01

```

**Nome do banco:**

```text

series_watchlist_db

```

**Tema do projeto:**

> Catálogo e lista pessoal de séries com notas e status de exibição (estilo Watchlist / Letterboxd de séries).

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | plataforma | id_plataforma | Nenhuma |
| 2 | usuario | id_usuario | Nenhuma |
| 3 | serie | id_serie | id_plataforma (referencia plataforma.id_plataforma) |
| 4 | item_watchlist | (id_usuario, id_serie) | id_usuario (referencia usuario.id_usuario), id_serie (referencia serie.id_serie) |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| plataforma | 1:N | serie | serie.id_plataforma |
| usuario | N:N | serie | Implementada por meio da associativa item_watchlist |

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

> Quais séries estão cadastradas e qual é o nome da plataforma de streaming onde cada uma é exibida?

**Tabelas utilizadas:**

```text
serie, plataforma

```

**PK/FK utilizadas:**

```text

PK: plataforma.id_plataforma
FK: serie.id_plataforma

```

**SQL:**

```sql
SELECT 
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    p.nome_plataforma AS servico_streaming
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

**Explique o resultado:**

> Retorna apenas os registros de séries que possuem correspondência direta com uma plataforma cadastrada. Traz o título, o gênero e o ano da série acompanhados do nome legível da plataforma de streaming (como Netflix, HBO Max), substituindo a chave numérica estrangeira.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais usuários já adicionaram séries em sua lista e qual é o título e status de cada item?

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    w.status_assistindo,
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie;
```

**Explique:**

> Realiza a junção entre o usuário, o registro de watchlist e a série correspondente. Apenas os usuários que possuem ao menos uma série em sua lista e cujas séries existem no catálogo são exibidos, correlacionando o nome da pessoa ao título assistido e à nota dada.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais são todos os usuários cadastrados no banco e quais séries eles têm na watchlist (incluindo aqueles que não adicionaram nenhuma série)?

```sql

SELECT 
    u.nome AS usuario,
    u.email,
    s.titulo AS serie,
    w.status_assistindo,
    w.nota
FROM usuario AS u
LEFT JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
LEFT JOIN serie AS s
    ON w.id_serie = s.id_serie;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite visualizar todos os usuários cadastrados na base, inclusive aqueles que ainda não adicionaram nenhuma série à lista, trazendo para estes os campos `serie`, `status_assistindo` e `nota` preenchidos com `NULL`.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais são todas as plataformas cadastradas e quais séries pertencem a cada uma, incluindo plataformas que não têm nenhuma série associada?

```sql
SELECT 
    s.titulo AS serie,
    p.nome_plataforma
FROM serie AS s
RIGHT JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

**Explique o resultado:**

> O RIGHT JOIN garante que todas as plataformas (tabela à direita) apareçam no resultado final. Plataformas que não possuem séries associadas no momento (como a Paramount+, cuja única série de teste foi removida no Módulo 1) continuam sendo listadas com o campo serie como NULL.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Qual é a listagem completa dos comentários e notas dos usuários, exibindo o nome do usuário, o título da série e a plataforma onde ela está disponível?

SQL:

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    p.nome_plataforma,
    w.nota,
    w.comentario
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

## Consulta 2

**Pergunta:**

> Quais séries em andamento ou concluídas cada usuário assiste, trazendo detalhes de país de origem da produção e nome do serviço de streaming?

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    s.pais_origem,
    p.nome_plataforma,
    w.status_assistindo
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE w.status_assistindo IN ('Assistindo', 'Finalizado');
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais séries da plataforma "HBO Max" foram adicionadas às listas dos usuários com o status "Concluído"?

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    p.nome_plataforma,
    w.status_assistindo,
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE p.nome_plataforma = 'HBO Max' 
  AND w.status_assistindo = 'Finalizado';
```

**Explique o filtro:**

> O WHERE filtra os dados após a junção das quatro tabelas, restringindo o resultado a registros onde o nome da plataforma é exatamente 'HBO Max' e o usuário já finalizou a exibição (status_assistindo = 'Concluído').

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Como listar todas as avaliações com nota atribuída, ordenadas da maior nota para a menor e, em caso de empate, pelo nome do usuário?

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    w.nota,
    w.status_assistindo
FROM item_watchlist AS w
INNER JOIN usuario AS u
    ON w.id_usuario = u.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
WHERE w.nota IS NOT NULL
ORDER BY w.nota DESC, u.nome ASC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Qual é a quantidade de séries cadastradas em cada plataforma de streaming?

```sql
SELECT 
    p.nome_plataforma,
    COUNT(s.id_serie) AS total_series_disponiveis
FROM plataforma AS p
LEFT JOIN serie AS s
    ON p.id_plataforma = s.id_plataforma
GROUP BY p.id_plataforma, p.nome_plataforma
ORDER BY total_series_disponiveis DESC;
```

**Explique o agrupamento:**

> A cláusula GROUP BY p.id_plataforma, p.nome_plataforma agrupa os registros por cada serviço de streaming. O uso da função de agregação COUNT(s.id_serie) combinada ao LEFT JOIN permite contar quantas séries cada plataforma possui no catálogo, exibindo 0 caso não haja títulos associados.

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

> Qual é o relatório consolidado de desempenho de cada série, contendo o título, plataforma de exibição, quantidade de usuários que a adicionaram e a nota média recebida?

```sql
SELECT 
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_interessados,
    ROUND(AVG(w.nota), 2) AS media_avaliacao
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma
ORDER BY media_avaliacao DESC;
```

**Por que ela é útil?**

>Essa consulta é um painel gerencial da aplicação. Ela une o catálogo de produções com os serviços de streaming e calcula indicadores cruciais (engajamento de audiência e aprovação dos usuários), auxiliando na tomada de decisões sobre curadoria e recomendações de conteúdo.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT 
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    p.nome_plataforma AS servico_streaming
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

**1. Quais tabelas participam?**
>Participam as tabelas `serie` (s) e `plataforma` (p).

**2. Qual PK está sendo utilizada?**
> A chave primária `p.id_plataforma`, da tabela `plataforma`.

**3. Qual FK está sendo utilizada?**
> A chave estrangeira `s.id_plataforma`, da tabela `serie`.

**4. O que a cláusula ON faz?**
> Estabelece a condição lógica de correspondência (`ON s.id_plataforma = p.id_plataforma`), unindo a série apenas à sua plataforma correta.

**5. O que ocorreria se a condição de relacionamento estivesse errada?**
> Ocorreria um produto cartesiano ou vinculação incorreta, duplicando dados e mostrando séries associadas a streamings dos quais não fazem parte.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    w.status_assistindo,
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie;
```

**Resultado esperado:**

> Relação das entradas ativas na watchlist, vinculando o nome do usuário com o título da série correspondente, seu status de visualização e nota.

**Resultado obtido:**

> 9 linhas retornadas com sucesso, listando:
<img width="352" height="193" alt="image" src="https://github.com/user-attachments/assets/b16c4da4-279d-4335-83ad-b25a6503aaaa" />

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| A média de notas ficava com muitas casas decimais ou vazia | Algumas séries na lista não tinham nota preenchida | Usei ROUND(AVG(...), 2) para limitar em 2 casas e filtrei notas em branco |
| Uma plataforma sumiu da lista final | Como ela ainda não tinha nenhuma série cadastrada, o INNER JOIN ignorou a linha | Troquei para RIGHT JOIN para mostrar a plataforma mesmo sem série |
| Usuários que não adicionaram nenhuma série não apareciam | O INNER JOIN só mostrava quem já tinha adicionado algo na lista | Troquei para LEFT JOIN a partir da tabela de usuários para listar todo mundo |

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

