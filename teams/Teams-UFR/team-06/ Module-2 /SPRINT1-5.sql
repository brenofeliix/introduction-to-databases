-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2
-- SPRINT 1/5 — JOINs
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
--
-- ============================================================

USE locacao_de_filmes;


-- ============================================================
-- 1. INNER JOIN 1
-- ============================================================
--
-- Pergunta:
-- Quais filmes estão cadastrados e a qual gênero cada um pertence?
--

SELECT
    f.titulo AS filme,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;


-- ============================================================
-- 2. INNER JOIN 2
-- ============================================================
--
-- Pergunta:
-- Quais clientes realizaram locações e em quais datas elas ocorreram?
--

SELECT
    c.nome AS cliente,
    l.id_locacao,
    l.data_locacao,
    l.data_devolucao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente;


-- ============================================================
-- 3. LEFT JOIN
-- ============================================================
--
-- Pergunta:
-- Quais funcionários estão cadastrados e quantas locações cada um registrou, incluindo funcionários sem locações?
--

SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome;


-- ============================================================
-- 4. RIGHT JOIN
-- ============================================================
--
-- Pergunta:
-- Quais funcionários estão cadastrados e quais locações foram registradas por eles, 
-- incluindo funcionários que não registraram locações?
--

SELECT
    f.nome AS funcionario,
    l.id_locacao,
    l.data_locacao
FROM locacao AS l
RIGHT JOIN funcionario AS f
    ON l.id_funcionario = f.id_funcionario
ORDER BY f.nome;


-- ============================================================
-- 5. JOIN COM 3+ TABELAS 1
-- ============================================================
--
-- Pergunta:
-- Quais clientes alugaram quais filmes?
--

SELECT
    c.nome AS cliente,
    f.titulo AS filme,
    l.data_locacao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS f
    ON i.id_filme = f.id_filme;


-- ============================================================
-- 6. JOIN COM 3+ TABELAS 2
-- ============================================================
--
-- Pergunta:
-- Quais funcionários registraram as locações e para quais clientes?
--

SELECT
    l.id_locacao,
    f.nome AS funcionario,
    c.nome AS cliente,
    l.data_locacao
FROM locacao AS l
INNER JOIN funcionario AS f
    ON l.id_funcionario = f.id_funcionario
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente;


-- ============================================================
-- 7. JOIN + WHERE
-- ============================================================
--
-- Pergunta:
-- Quais clientes alugaram filmes com avaliação igual ou superior a 7,0?
--

SELECT
    c.nome AS cliente,
    f.titulo AS filme,
    f.avaliacao
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS f
    ON i.id_filme = f.id_filme
WHERE f.avaliacao >= 7.0;


-- ============================================================
-- 8. JOIN + ORDER BY
-- ============================================================
--
-- Pergunta:
-- Quais filmes foram alugados, apresentados da maior para a menor avaliação?
--

SELECT
    f.titulo AS filme,
    g.nome AS genero,
    f.avaliacao
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero
INNER JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
ORDER BY f.avaliacao DESC;


-- ============================================================
-- 9. JOIN + GROUP BY + AGREGAÇÃO
-- ============================================================
--
-- Pergunta:
-- Quantas locações cada funcionário registrou?
--

SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome
ORDER BY quantidade_locacoes DESC;


-- ============================================================
-- 10. CONSULTA MAIS ÚTIL
-- ============================================================
--
-- Pergunta:
-- Quais clientes alugaram quais filmes, em quais datas e qual funcionário registrou a locação?
--

SELECT
    l.id_locacao,
    c.nome AS cliente,
    fi.titulo AS filme,
    fun.nome AS funcionario,
    l.data_locacao,
    l.data_devolucao
FROM locacao AS l
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
INNER JOIN funcionario AS fun
    ON l.id_funcionario = fun.id_funcionario
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS fi
    ON i.id_filme = fi.id_filme
ORDER BY l.id_locacao;

