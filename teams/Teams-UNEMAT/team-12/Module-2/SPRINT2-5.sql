-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- ============================================================
-- SUBQUERY COM COMPARAÇÃO
-- Pergunta: Quais imóveis têm valor acima da média de valor de
-- todos os imóveis cadastrados?
-- ============================================================

SELECT titulo, valor
FROM imovel
WHERE valor > (
    SELECT AVG(valor)
    FROM imovel
);


-- ============================================================
-- IN
-- Pergunta: Quais clientes já realizaram algum agendamento de visita?
-- ============================================================

SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);


-- ============================================================
-- NOT IN
-- Pergunta: Quais clientes nunca agendaram nenhuma visita?
-- ============================================================

SELECT nome
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM agendamento
);


-- ============================================================
-- EXISTS
-- Pergunta: Quais imóveis possuem pelo menos um agendamento registrado?
-- ============================================================

SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);


-- ============================================================
-- NOT EXISTS
-- Pergunta: Quais imóveis nunca receberam nenhum agendamento de visita?
-- ============================================================

SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);


-- ============================================================
-- MAX / MIN
-- Pergunta: Qual é o imóvel mais caro cadastrado no sistema?
-- ============================================================

SELECT titulo, valor
FROM imovel
WHERE valor = (
    SELECT MAX(valor)
    FROM imovel
);


-- ============================================================
-- SUBQUERY CORRELACIONADA
-- Pergunta: Quais imóveis têm valor acima da média de valor dos
-- imóveis do mesmo corretor?
-- ============================================================

SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);


-- ============================================================
-- PROBLEMA 1 - JOIN
-- Pergunta: Quais clientes já realizaram algum agendamento de visita?
-- ============================================================

SELECT DISTINCT cl.nome
FROM cliente AS cl
INNER JOIN agendamento AS a
    ON cl.id_cliente = a.id_cliente;


-- ============================================================
-- PROBLEMA 1 - SUBQUERY
-- Mesma pergunta resolvida com subconsulta
-- ============================================================

SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
);


-- ============================================================
-- PROBLEMA 2 - JOIN
-- Pergunta: Quais imóveis possuem pelo menos um agendamento registrado?
-- ============================================================

SELECT DISTINCT i.titulo
FROM imovel AS i
INNER JOIN agendamento AS a
    ON i.id_imovel = a.id_imovel;


-- ============================================================
-- PROBLEMA 2 - SUBQUERY
-- Mesma pergunta resolvida com subconsulta
-- ============================================================

SELECT titulo
FROM imovel AS i
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
