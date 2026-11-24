-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2
-- SPRINT 2/5 — Subconsultas
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
-- 1. SUBCONSULTA COM COMPARAÇÃO
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem avaliação acima da média dos filmes cadastrados?
--

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao > (
    SELECT AVG(avaliacao)
    FROM filme
);


-- ============================================================
-- 2. SUBCONSULTA COM IN
-- ============================================================
--
-- Pergunta:
-- Quais clientes já realizaram pelo menos uma locação?
--

SELECT
    id_cliente,
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM locacao
);


-- ============================================================
-- 3. SUBCONSULTA COM NOT IN
-- ============================================================
--
-- Pergunta:
-- Quais funcionários não registraram nenhuma locação?
--

SELECT
    id_funcionario,
    nome
FROM funcionario
WHERE id_funcionario NOT IN (
    SELECT id_funcionario
    FROM locacao
);


-- ============================================================
-- 4. EXISTS
-- ============================================================
--
-- Pergunta:
-- Quais clientes possuem pelo menos uma locação cadastrada?
--

SELECT
    c.id_cliente,
    c.nome
FROM cliente AS c
WHERE EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_cliente = c.id_cliente
);


-- ============================================================
-- 5. NOT EXISTS
-- ============================================================
--
-- Pergunta:
-- Quais funcionários não possuem nenhuma locação registrada?
--

SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
);


-- ============================================================
-- 6. SUBCONSULTA COM MAX
-- ============================================================
--
-- Pergunta:
-- Qual filme possui a maior avaliação cadastrada?
--

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao = (
    SELECT MAX(avaliacao)
    FROM filme
);


-- ============================================================
-- 7. SUBCONSULTA CORRELACIONADA
-- ============================================================
--
-- Pergunta:
-- Quais funcionários registraram mais de uma locação?
--

SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE (
    SELECT COUNT(*)
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
) > 1;


-- ============================================================
-- 8. Problema 1 - JOIN e SUBQUERY
-- ============================================================
--
-- Pergunta:
-- Quais clientes já realizaram locações?
--

--
-- Problema 1 - JOIN
--

SELECT DISTINCT
    c.id_cliente,
    c.nome
FROM cliente AS c
INNER JOIN locacao AS l
    ON c.id_cliente = l.id_cliente;

--
-- PROBLEMA 1 — SUBQUERY
--

SELECT
    id_cliente,
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM locacao
);


-- ============================================================
-- 9. Problema 2 - JOIN e SUBQUERY
-- ============================================================
--
-- Pergunta:
-- Quais funcionários não registraram nenhuma locação?
--

--
-- Problema 2 - JOIN
--

SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
WHERE l.id_locacao IS NULL;

--
-- PROBLEMA 2 — SUBQUERY
--

SELECT
    f.id_funcionario,
    f.nome
FROM funcionario AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM locacao AS l
    WHERE l.id_funcionario = f.id_funcionario
);

