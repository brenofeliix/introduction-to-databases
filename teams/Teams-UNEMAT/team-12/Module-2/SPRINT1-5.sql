-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- ============================================================
-- INNER JOIN 1
-- Pergunta: Quais imóveis estão cadastrados e qual é o corretor
-- responsável por cada um?
-- ============================================================

SELECT
    i.titulo,
    i.valor,
    i.cidade,
    c.nome AS corretor_responsavel
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;


-- ============================================================
-- INNER JOIN 2
-- Pergunta: Quais agendamentos existem e qual cliente marcou cada um?
-- ============================================================

SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente;


-- ============================================================
-- LEFT JOIN
-- Pergunta: Quais imóveis existem, incluindo os que nunca
-- receberam nenhum agendamento de visita?
-- ============================================================

SELECT
    i.titulo,
    i.cidade,
    a.data_visita,
    a.status
FROM imovel AS i
LEFT JOIN agendamento AS a
    ON i.id_imovel = a.id_imovel;


-- ============================================================
-- RIGHT JOIN
-- Pergunta: Quais corretores existem, incluindo os que
-- atualmente não possuem nenhum imóvel cadastrado?
-- ============================================================

SELECT
    c.nome AS corretor,
    i.titulo AS imovel
FROM imovel AS i
RIGHT JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;


-- ============================================================
-- JOIN COM 3+ TABELAS 1
-- Pergunta: Quais clientes agendaram visita, em qual imóvel e
-- em qual cidade?
-- ============================================================

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


-- ============================================================
-- JOIN COM 3+ TABELAS 2
-- Pergunta: Quais clientes agendaram visita, em qual imóvel, e
-- quem é o corretor responsável por esse imóvel?
-- ============================================================

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


-- ============================================================
-- JOIN + WHERE
-- Pergunta: Quais agendamentos já estão com status "Confirmado"
-- e quem são os clientes e imóveis envolvidos?
-- ============================================================

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


-- ============================================================
-- JOIN + ORDER BY
-- Pergunta: Quais imóveis estão anunciados por quais corretores,
-- ordenados do mais caro para o mais barato?
-- ============================================================

SELECT
    i.titulo,
    i.valor,
    c.nome AS corretor
FROM imovel AS i
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor
ORDER BY i.valor DESC;


-- ============================================================
-- JOIN + GROUP BY + AGREGAÇÃO
-- Pergunta: Quantos imóveis cada corretor tem anunciado atualmente?
-- ============================================================

SELECT
    c.nome AS corretor,
    COUNT(*) AS total_imoveis
FROM corretor AS c
INNER JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.nome;
