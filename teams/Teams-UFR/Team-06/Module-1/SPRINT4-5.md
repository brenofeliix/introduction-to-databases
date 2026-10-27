# SPRINT 4/5 — Consultas SQL e Expressões

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`

---

# Objetivo da Sprint 4/5

Nesta etapa, cada aluno deverá utilizar o banco de dados desenvolvido nas Sprints anteriores para consultar, filtrar, ordenar, agrupar e resumir os dados armazenados.

Nesta Sprint serão trabalhados principalmente:

```sql
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
COUNT
SUM
AVG
MIN
MAX
```

Ao final da atividade, o aluno deverá entregar:

```text
SPRINT4-5.md
SPRINT4-5.sql
```

O arquivo `.md` documentará as consultas e o raciocínio utilizado.  
O arquivo `.sql` conterá todas as consultas efetivamente executadas e testadas no MySQL Workbench.

> Utilize obrigatoriamente o mesmo banco criado nas Sprints anteriores.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão.
3. Confirme que o banco da Sprint 2/5 existe.
4. Confirme que os dados da Sprint 3/5 estão disponíveis.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira os dados:

```sql
SELECT * FROM nome_da_tabela;
```

---

# 2. Crie o arquivo SPRINT4-5.sql

No MySQL Workbench:

```text
File → New Query Tab
```

Depois:

```text
File → Save Script As...
```

Salve exatamente como:

```text
SPRINT4-5.sql
```

---

# 3. Retome as perguntas da Sprint 1/5

Recupere as perguntas que você definiu anteriormente para o banco.

1. Quais clientes estão cadastrados na locadora?
2. Quais filmes estão cadastrados e quais são seus respectivos gêneros?
3. Quantas locações cada cliente realizou?
4. Quais filmes foram mais alugados?
5. Quantos filmes existem cadastrados em cada gênero?
6. Quais funcionários registraram locações?
7. Qual foi o valor total de uma determinada locação?

Agora identifique quais delas exigem:

- consulta simples;
- filtro;
- ordenação;
- agregação;
- agrupamento;
- filtro sobre grupos.

---

# 4. SELECT

Consulta básica:

```sql
SELECT *
FROM nome_tabela;
```

Selecionando colunas específicas:

```sql
SELECT campo_1, campo_2
FROM nome_tabela;
```

## Consulta 1

### Pergunta respondida

> Quais clientes estão cadastrados na locadora?

### SQL

```sql
SELECT *
FROM cliente;

```

### Explique o resultado

> Com essa consulta, é possível identificar todos os clientes cadastrados na locadora, bem como as demais informações armazenadas para cada cliente.

---

# 5. WHERE

Utilize `WHERE` para filtrar registros.

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100;
```

Operadores comuns:

```text
=   igual
<>  diferente
>   maior que
<   menor que
>=  maior ou igual
<=  menor ou igual
```

Também podem ser utilizados:

```sql
AND
OR
LIKE
BETWEEN
IN
IS NULL
IS NOT NULL
```

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100
  AND estoque > 0;
```

## Consulta obrigatória com WHERE

### Pergunta respondida

> Quais filmes possuem avaliação igual ou superior a 7,0?

### SQL

```sql
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao >= 7.0;

```

### Explique o filtro

> A consulta utiliza a cláusula WHERE para selecionar apenas os filmes que possuem avaliação igual ou superior a 7,0. Dessa forma, filmes com avaliações inferiores a esse valor não são apresentados no resultado.

---

# 6. ORDER BY

Ordenação crescente:

```sql
SELECT *
FROM produto
ORDER BY preco ASC;
```

Ordenação decrescente:

```sql
SELECT *
FROM produto
ORDER BY preco DESC;
```

Por mais de uma coluna:

```sql
SELECT *
FROM produto
ORDER BY categoria ASC, preco DESC;
```

## Consulta obrigatória com ORDER BY

### Pergunta respondida

> Quais filmes possuem as maiores avaliações?

### SQL

```sql
SELECT
    titulo,
    avaliacao
FROM filme
ORDER BY avaliacao DESC;


```

---

# 7. Funções de agregação

Principais funções:

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

## COUNT

```sql
SELECT COUNT(*) AS total_registros
FROM nome_tabela;
```

## SUM

```sql
SELECT SUM(campo_numerico) AS total
FROM nome_tabela;
```

## AVG

```sql
SELECT AVG(campo_numerico) AS media
FROM nome_tabela;
```

## MIN e MAX

```sql
SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM nome_tabela;
```

---

# 8. Consultas obrigatórias com agregação

## COUNT

```sql
SELECT
    COUNT(*) AS total_locacoes
FROM locacao;

```

**Pergunta respondida:**

> Quantas locações foram realizadas na locadora?

## SUM

```sql
SELECT
    l.id_locacao,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
WHERE l.id_locacao = 1
GROUP BY l.id_locacao;

```

**Pergunta respondida:**

> Qual foi o valor total da locação 1?

Caso não seja aplicável ao domínio, justifique.

## AVG

```sql
SELECT
    ROUND(AVG(avaliacao), 2) AS media_avaliacoes
FROM filme;

```

**Pergunta respondida:**

> Qual é a avaliação média dos filmes cadastrados?

Caso não seja aplicável ao domínio, justifique.

## MIN ou MAX

```sql
SELECT
    MIN(avaliacao) AS menor_avaliacao,
    MAX(avaliacao) AS maior_avaliacao
FROM filme;

```

**Pergunta respondida:**

> Quais são a menor e a maior avaliação dos filmes cadastrados?

---

# 9. GROUP BY

`GROUP BY` permite agrupar registros.

Exemplo:

```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id;
```

Outro exemplo:

```sql
SELECT status,
       COUNT(*) AS quantidade
FROM pedido
GROUP BY status;
```

## Consulta obrigatória com GROUP BY

### Pergunta respondida

> Quantas locações cada cliente realizou?

### SQL

```sql
SELECT
    c.nome AS cliente,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM cliente AS c
LEFT JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
GROUP BY
    c.id_cliente,
    c.nome;

```

### Explique o agrupamento

> A consulta agrupa os registros de locação de acordo com cada cliente. A função COUNT() contabiliza quantas locações estão associadas a cada cliente, enquanto o GROUP BY separa os resultados por identificador e nome. O LEFT JOIN permite incluir também clientes que eventualmente não possuam locações.

---

# 10. HAVING

`WHERE` filtra registros antes do agrupamento.

`HAVING` filtra os grupos após o `GROUP BY`.

Exemplo:

```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id
HAVING COUNT(*) > 5;
```

## Consulta obrigatória com HAVING

### Pergunta respondida

> Quais funcionários registraram mais de uma locação?

### SQL

```sql
SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome
HAVING COUNT(l.id_locacao) > 1;

```

### Por que HAVING foi necessário?

> A cláusula HAVING foi utilizada porque a condição é aplicada após o agrupamento dos registros. Inicialmente, as locações são agrupadas por funcionário e contabilizadas com COUNT(). Em seguida, o HAVING mantém no resultado somente os funcionários cuja quantidade de locações registradas é superior a uma.

---

# 11. Expressões SQL

É possível realizar cálculos em consultas.

Exemplo:

```sql
SELECT nome,
       preco,
       preco * 0.90 AS preco_com_desconto
FROM produto;
```

Outro exemplo:

```sql
SELECT quantidade,
       valor_unitario,
       quantidade * valor_unitario AS subtotal
FROM item_pedido;
```

## Consulta com expressão

```sql
SELECT
    l.id_locacao,
    f.titulo,
    DATEDIFF(l.data_devolucao, l.data_locacao) AS quantidade_dias,
    i.valor_diaria,
    DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria AS valor_calculado
FROM item_locacao AS i
JOIN locacao AS l
    ON i.id_locacao = l.id_locacao
JOIN filme AS f
    ON i.id_filme = f.id_filme;

```

### Explique o cálculo

> A expressão utiliza a diferença entre a data de devolução e a data de locação para calcular a quantidade de dias. Em seguida, essa quantidade é multiplicada pelo valor da diária do filme, gerando o valor calculado para cada item da locação

Caso não seja aplicável ao domínio, justifique.

---

# 12. Consultas mínimas exigidas

O arquivo `SPRINT4-5.sql` deverá possuir, no mínimo:

```text
1 SELECT básico
1 SELECT com colunas específicas
1 consulta com WHERE
1 consulta com mais de uma condição
1 consulta com ORDER BY
1 consulta com COUNT
1 consulta com SUM, quando aplicável
1 consulta com AVG, quando aplicável
1 consulta com MIN ou MAX
1 consulta com GROUP BY
1 consulta com HAVING
1 consulta com expressão, quando aplicável
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Evite consultas sem significado

Evite:

```sql
SELECT *
FROM produto
WHERE id_produto > 0;
```

se isso não responde nenhuma necessidade real.

Prefira:

```sql
SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

Pergunta:

```text
Quais produtos estão com estoque baixo?
```

---

# 14. Modelo genérico para adaptar

**Não entregue este código sem adaptação.**

```sql
USE locacao_de_filmes;

-- SELECT básico
SELECT *
FROM cliente;

-- Colunas específicas
SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme;

-- WHERE
SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao >= 7.0;

-- Duas condições
SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme
WHERE ano_lancamento >= 2000
  AND avaliacao >= 7.0;

-- ORDER BY
SELECT
    titulo,
    avaliacao
FROM filme
ORDER BY avaliacao DESC;

-- COUNT
SELECT
    COUNT(*) AS total_locacoes
FROM locacao;

-- SUM
SELECT
    l.id_locacao,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
WHERE l.id_locacao = 1
GROUP BY l.id_locacao;

-- AVG
SELECT
    ROUND(AVG(avaliacao), 2) AS media_avaliacoes
FROM filme;

-- MIN / MAX
SELECT
    MIN(avaliacao) AS menor_avaliacao,
    MAX(avaliacao) AS maior_avaliacao
FROM filme;

-- GROUP BY
SELECT
    c.nome AS cliente,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM cliente AS c
LEFT JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
GROUP BY
    c.id_cliente,
    c.nome;

-- HAVING
SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome
HAVING COUNT(l.id_locacao) > 1;

-- Expressão
SELECT
    l.id_locacao,
    f.titulo,
    DATEDIFF(l.data_devolucao, l.data_locacao) AS quantidade_dias,
    i.valor_diaria,
    DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria AS valor_calculado
FROM item_locacao AS i
JOIN locacao AS l
    ON i.id_locacao = l.id_locacao
JOIN filme AS f
    ON i.id_filme = f.id_filme;
```

> Substitua `nome_do_banco`, `tabela_a`, `campo_a1`, `campo_numerico`, `campo_categoria` e demais nomes genéricos pelos nomes reais do seu projeto.

---

# 15. Estrutura recomendada do SPRINT4-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Banco:

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================


-- ============================================================
-- 2. WHERE
-- ============================================================


-- ============================================================
-- 3. ORDER BY
-- ============================================================


-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================


-- ============================================================
-- 5. GROUP BY
-- ============================================================


-- ============================================================
-- 6. HAVING
-- ============================================================


-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================


-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

```

---

# 16. Passo a passo no MySQL Workbench

## Etapa 1 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 2 — Confira as tabelas

```sql
SELECT * FROM nome_tabela;
```

## Etapa 3 — Escolha uma pergunta

Exemplo:

```text
Quais produtos possuem preço acima de R$ 100?
```

## Etapa 4 — Transforme em SQL

```sql
SELECT nome, preco
FROM produto
WHERE preco > 100;
```

## Etapa 5 — Execute

Execute uma consulta por vez e confira o resultado.

## Etapa 6 — Documente no próprio `.sql`

Exemplo:

```sql
-- Consulta 01
-- Pergunta:
-- Quais produtos possuem estoque abaixo de 5 unidades?

SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

## Etapa 7 — Salve

Salve frequentemente como:

```text
SPRINT4-5.sql
```

---

# 17. Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|---|
| 1 | Quais clientes estão cadastrados? | SELECT | Sim |
| 2 | Quais filmes estão cadastrados e quais são suas avaliações? | SELECT, colunas específicas | Sim |
| 3 | Quais filmes possuem avaliação igual ou superior a 7,0? | WHERE | Sim |
| 4	| Quais filmes lançados a partir de 2000 possuem avaliação ≥ 7,0? | WHERE, AND | Sim |
| 5	| Quais clientes possuem nome iniciado pela letra T? | LIKE | Sim |
| 6 | Quais filmes possuem avaliação entre 7,0 e 9,0? | BETWEEN | Sim |
| 7	| Quais filmes possuem as maiores avaliações? | ORDER BY | Sim |
| 8	| Quantas locações foram realizadas? | COUNT | Sim |
| 9	| Qual foi o valor total da locação 1? | SUM, JOIN, WHERE, expressão | Sim |
| 10 | Qual é a avaliação média dos filmes? | AVG, ROUND | Sim |
| 11 | Quais são a menor e a maior avaliação? | MIN, MAX | Sim |
| 12 | Quantas locações cada cliente realizou? | JOIN, COUNT, GROUP BY | Sim |
| 13 | Quais funcionários registraram mais de uma locação? | JOIN, COUNT, GROUP BY, HAVING | Sim |
| 14 | Qual foi o valor de cada item considerando os dias da locação? | JOIN, DATEDIFF, expressão | Sim |
| 15 | Quais filmes estão cadastrados e seus gêneros? | JOIN, ORDER BY | Sim |
| 16 | Quais filmes foram mais alugados? | JOIN, COUNT, GROUP BY, ORDER BY | Sim |
| 17 | Quais funcionários registraram locações? | DISTINCT, JOIN, ORDER BY | Sim |
| 18 | Quantos filmes existem em cada gênero? | LEFT JOIN, COUNT, GROUP BY | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Qual foi o valor total de cada locação?

### SQL

```sql
SELECT
    l.id_locacao,
    c.nome AS cliente,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
GROUP BY
    l.id_locacao,
    c.nome
ORDER BY l.id_locacao;

```

### Por que ela é útil?

> Essa consulta permite visualizar o valor total associado a cada locação juntamente com o nome do cliente responsável. A informação pode ser utilizada para conferência de cobranças e acompanhamento das operações realizadas pela locadora.

---

# 19. Consulta mais complexa

### Pergunta

> Quais filmes foram mais alugados?

### SQL

```sql
SELECT
    f.titulo,
    g.nome AS genero,
    COUNT(i.id_filme) AS quantidade_locacoes
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
GROUP BY
    f.id_filme,
    f.titulo,
    g.nome
ORDER BY quantidade_locacoes DESC;

```

### Qual foi a dificuldade?

> A principal dificuldade foi relacionar informações armazenadas em três tabelas diferentes. Foi necessário utilizar JOIN para relacionar filme, genero e item_locacao, além de utilizar COUNT() e GROUP BY para calcular a quantidade de locações de cada filme e ORDER BY para apresentar os mais alugados primeiro.

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Não foram encontrados erros durante a execução das consultas finais. | — | Todas as consultas foram executadas e validadas individualmente no MySQL Workbench. |
|  |  |  |
|  |  |  |

---

# 21. Uso de LLMs nesta Sprint

Caso utilize uma LLM, informe:

- tema do banco;
- nomes reais das tabelas;
- estrutura das tabelas;
- dados disponíveis;
- pergunta que deseja responder;
- SQL já tentado;
- mensagem de erro do MySQL, quando houver.

Exemplo de solicitação adequada:

```text
Tenho uma tabela produto com os campos id_produto, nome,
preco, estoque e id_categoria.

Quero responder: "Qual é o preço médio dos produtos de cada
categoria?"

Explique como construir essa consulta usando GROUP BY e AVG.
Depois apresente um exemplo compatível com MySQL.
```

Todo código sugerido por LLM deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

```text
Registro de uso de LLM:
Durante o desenvolvimento da Sprint 4/5, foi utilizada uma LLM como ferramenta de apoio para analisar as perguntas definidas na Sprint 1/5 e relacioná-las aos recursos SQL exigidos nesta etapa.

Foram informados o tema do banco de dados (locadora), as tabelas utilizadas (cliente, funcionario, genero, filme, locacao e item_locacao), seus relacionamentos e os dados previamente inseridos.

As consultas sugeridas foram analisadas e adaptadas à estrutura real do projeto. Posteriormente, cada consulta foi executada individualmente no MySQL Workbench, testada e validada antes de ser incluída nos arquivos finais da Sprint 4/5.
```

---

# 22. O que deve existir ao final da Sprint 4/5

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql

SPRINT4-5.md
SPRINT4-5.sql
```

Não exclua arquivos anteriores.

---

# 23. Checklist da Sprint 4/5

- [ ] utilizei o banco das Sprints anteriores;
- [ ] confirmei que existem dados suficientes;
- [ ] utilizei `SELECT`;
- [ ] selecionei colunas específicas;
- [ ] utilizei `WHERE`;
- [ ] utilizei mais de uma condição;
- [ ] utilizei `ORDER BY`;
- [ ] utilizei `COUNT`;
- [ ] utilizei `SUM`, quando aplicável;
- [ ] utilizei `AVG`, quando aplicável;
- [ ] utilizei `MIN` ou `MAX`;
- [ ] utilizei `GROUP BY`;
- [ ] utilizei `HAVING`;
- [ ] utilizei aliases com `AS`;
- [ ] utilizei expressão SQL quando aplicável;
- [ ] minhas consultas respondem perguntas reais;
- [ ] testei as consultas no MySQL Workbench;
- [ ] salvei o código em `SPRINT4-5.sql`;
- [ ] preenchi completamente o `SPRINT4-5.md`;
- [ ] revisei os arquivos antes do commit.

---

# 24. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch das Sprints anteriores.

Não crie uma nova branch.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT4-5.md
SPRINT4-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 4 de 5 - consultas SQL
```

---

# 25. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 26. Critério de conclusão da Sprint 4/5

A Sprint será considerada concluída quando o aluno:

1. utilizar os dados criados anteriormente;
2. elaborar consultas coerentes com o domínio;
3. utilizar corretamente `SELECT`;
4. utilizar `WHERE`;
5. utilizar `ORDER BY`;
6. utilizar funções de agregação;
7. utilizar `GROUP BY`;
8. utilizar `HAVING`;
9. conseguir explicar as perguntas respondidas;
10. executar e validar as consultas no MySQL Workbench;
11. documentar o trabalho no `SPRINT4-5.md`;
12. salvar o código em `SPRINT4-5.sql`;
13. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 5/5**, o projeto será revisado, integrado e preparado para a entrega final.

A Sprint final envolverá:

- revisão da estrutura;
- revisão das restrições;
- revisão dos dados;
- revisão das consultas;
- execução completa;
- correção de erros;
- organização dos arquivos;
- preparação do `SPRINT5-5.sql`;
- abertura do Pull Request final.

> **Não abra o Pull Request antes de concluir a Sprint 5/5.**
