
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

> Raquel Silva dos Santos

**Banco utilizado:**

```text
series_watchlist_db

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

1. Quais séries obtiveram nota média superior à média geral de todas as avaliações registadas na base de dados?
2. Quais utilizadores têm pelo menos uma série adicionada à sua watchlist?
3. Quais plataformas de streaming cadastradas não possuem qualquer série vinculada no catálogo?
4. Quais são as séries mais antigas do catálogo (lançadas no menor ano registado)?
5. Para cada utilizador, quais são as séries cuja nota atribuída foi estritamente superior à sua própria média pessoal de avaliações?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais são as séries cuja avaliação individual na watchlist foi superior à média aritmética de todas as notas registadas na plataforma?

SQL

```sql
SELECT 
    id_serie, 
    id_usuario, 
    nota, 
    comentario
FROM item_watchlist
WHERE nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);
```

**Explique primeiro a consulta interna:**

> A subconsulta (SELECT AVG(nota) FROM item_watchlist WHERE nota IS NOT NULL) é executada e calcula a média geral de todas as notas válidas do sistema, retornando um único valor escalar (por exemplo, 9.21).

**Depois explique a consulta externa:**

> A consulta externa examina linha a linha da tabela item_watchlist e seleciona apenas os registos cujo valor na coluna nota é estritamente maior do que o valor escalar retornado pela consulta interna.

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

> Quais utilizadores possuem pelo menos uma série registada na sua lista de acompanhamento (item_watchlist)?

```sql
SELECT 
    id_usuario, 
    nome, 
    email
FROM usuario
WHERE id_usuario IN (
    SELECT DISTINCT id_usuario
    FROM item_watchlist
);
```

**Explique:**

> A subconsulta gera uma lista vertical com todos os identificadores de utilizadores (id_usuario) presentes na tabela associativa item_watchlist. O operador IN compara o identificador da tabela usuario com esse conjunto, trazendo apenas os utilizadores ativos que já adicionaram itens.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais plataformas de streaming registadas no sistema não possuem nenhuma série associada no catálogo?

SQL

```sql
SELECT 
    id_plataforma, 
    nome_plataforma
FROM plataforma
WHERE id_plataforma NOT IN (
    SELECT DISTINCT id_plataforma
    FROM serie
    WHERE id_plataforma IS NOT NULL
);
```

**Que registros você está procurando?**

> Estamos à procura das plataformas que estão ociosas no catálogo (como a Paramount+, cujo ID não se encontra na tabela serie). O filtro explícito WHERE id_plataforma IS NOT NULL na subconsulta é uma boa prática para evitar que valores nulos invalidem a lógica booleana do NOT IN.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

>  Quais usuários atribuíram nota máxima (10) a pelo menos uma série?

```sql
-- EXISTS
SELECT 
    u.id_usuario, 
    u.nome
FROM usuario AS u
WHERE EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
      AND w.nota = 10
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais usuários cadastrados no sistema ainda não têm nenhuma série adicionada à sua watchlist?

```sql
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
);
```

**Explique a diferença em relação a `EXISTS`:**

> Enquanto o EXISTS retorna verdadeiro quando a subconsulta encontra ao menos uma linha correspondente, o NOT EXISTS inverte essa lógica: ele apenas seleciona o utilizador se a subconsulta retornar um conjunto vazio, identificando utilizadores inativos (como a utilizadora Fernanda Costa).

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Quais são as séries mais antigas cadastradas no catálogo (que possuem o menor ano de lançamento)?

```sql
SELECT 
    id_serie, 
    titulo, 
    genero, 
    ano_lancamento
FROM serie
WHERE ano_lancamento = (
    SELECT MIN(ano_lancamento)
    FROM serie
);
```

**Explique:**

> A subconsulta calcula o menor ano presente no catálogo (MIN(ano_lancamento) = 2016). Em seguida, a consulta principal busca todas as séries cujo ano_lancamento seja igual a esse valor mínimo (neste caso, Stranger Things), evitando fixar o ano de forma manual no código.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais séries em watchlist receberam nota individual superior à média de notas calculada especificamente para essa mesma série?
```sql
SELECT 
    w1.id_usuario, 
    w1.id_serie, 
    w1.nota, 
    w1.comentario
FROM item_watchlist AS w1
WHERE w1.nota > (
    SELECT AVG(w2.nota)
    FROM item_watchlist AS w2
    WHERE w2.id_serie = w1.id_serie
      AND w2.nota IS NOT NULL
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna w1.id_serie. Para cada linha avaliada na consulta externa, a subconsulta interna recalcula dinamicamente a média aritmética restrita àquela série (w2.id_serie = w1.id_serie), comparando a avaliação do utilizador com a média da própria obra.

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais plataformas possuem séries cadastradas no catálogo?

### JOIN

```sql
SELECT DISTINCT 
    p.id_plataforma, 
    p.nome_plataforma
FROM plataforma AS p
INNER JOIN serie AS s
    ON p.id_plataforma = s.id_plataforma;
```

### SUBQUERY

```sql
SELECT 
    p.id_plataforma, 
    p.nome_plataforma
FROM plataforma AS p
WHERE p.id_plataforma IN (
    SELECT s.id_plataforma
    FROM serie AS s
);
```

### Qual abordagem ficou mais compreensível?

> A abordagem com SUBQUERY (IN) ficou mais declarativa e compreensível, pois expressa diretamente a intenção da pergunta ("traga as plataformas cujo ID esteja no conjunto de plataformas com séries"), além de dispensar o uso de DISTINCT, necessário na solução com INNER JOIN para eliminar duplicados causados pela relação 1:N.

---

## Pergunta 2

> Quais utilizadores nunca adicionaram nenhuma série à watchlist?

### JOIN

```sql
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
LEFT JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
WHERE w.id_usuario IS NULL;
```

### SUBQUERY

```sql
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
);
```

### Comparação

> A técnica de LEFT JOIN ... WHERE chave IS NULL é tradicional em modelagem relacional, mas exige raciocinar sobre junções externas e valores nulos gerados. A abordagem com NOT EXISTS possui leitura semântica mais direta ("selecione o utilizador onde não exista registo na watchlist") e costuma ter desempenho superior no motor do MySQL, pois encerra a pesquisa no primeiro registo encontrado.

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
SELECT 
    id_serie, 
    titulo, 
    ano_lancamento
FROM serie
WHERE ano_lancamento = (
    SELECT MIN(ano_lancamento)
    FROM serie
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> A consulta executada primeiro é a interna (SELECT MIN(ano_lancamento) FROM serie;), que calcula e retorna um único valor numérico escalar igual a 2016; em seguida, a consulta externa consome esse resultado direto no filtro relacional (WHERE ano_lancamento = 2016), selecionando todas as linhas da tabela serie cuja coluna ano_lancamento coincide com o valor mínimo obtido.
---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
SELECT 
    id_serie, 
    id_usuario, 
    nota
FROM item_watchlist
WHERE nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);
```

**Alteração realizada:**

> Modificou-se o operador relacional de maior (>) para menor ou igual (<=):

**Mudança observada:**

> A consulta original retornava apenas as notas de topo (acima de ~9.21, como as avaliações 9.5, 9.7, 9.8 e 10.0). Após a inversão para <=, o conjunto de resultados passou a exibir as notas inferiores ou medianas (como 8.0, 8.5 e 9.0), confirmando a partição exata do domínio pelo valor da média.
---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Linhas duplicadas na consulta de teste com INNER JOIN | A cardinalidade 1:N entre tabelas faz com que a tabela pai repita para cada filho encontrado | Uso da cláusula DISTINCT ou refatoração para subconsulta com IN |
| Risco de resultado vazio com NOT IN | Se a subconsulta retornar qualquer valor NULL, o operador NOT IN retorna UNKNOWN/falso para todas as linhas | Adição da cláusula WHERE coluna IS NOT NULL na subconsulta interna |
| Ambiguidade de tabelas em subconsultas correlacionadas | A tabela externa e interna pertenciam à mesma entidade (item_watchlist) | Definição clara de aliases distintos (w1 para externa e w2 para interna) |

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

- [X] utilizei o banco do projeto;
- [X] criei subconsulta com comparação;
- [X] utilizei `IN`;
- [X] utilizei `NOT IN`;
- [X] utilizei `EXISTS`;
- [X] utilizei `NOT EXISTS`;
- [X] utilizei `MAX` ou `MIN`;
- [X] criei subconsulta correlacionada;
- [X] resolvi duas perguntas usando JOIN e SUBQUERY;
- [X] expliquei o raciocínio;
- [X] testei no MySQL Workbench;
- [X] consigo explicar as consultas presencialmente;
- [X] salvei `SPRINT2-5.md`;
- [X] salvei `SPRINT2-5.sql`.

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
