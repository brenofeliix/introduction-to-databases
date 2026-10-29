-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS E CONSULTAS AVANÇADAS

-- Aluno: Vinícius Eduardo Lima de Assis
-- Banco: pacote_viagens

USE pacote_viagens;

-- ============================================================
-- 1. SUBQUERY COM COMPARAÇÃO
-- ============================================================
-- Hospedagens com valor de diária superior à média geral
SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);

-- ============================================================
-- 2. IN
-- ============================================================
-- Clientes que possuem reservas efetuadas
SELECT 
    id_cliente,
    nome,
    email
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM reserva_pacote
);

-- ============================================================
-- 3. NOT IN
-- ============================================================
-- Clientes que não possuem reservas efetuadas
SELECT 
    id_cliente,
    nome,
    email
FROM cliente
WHERE id_cliente NOT IN (
    SELECT DISTINCT id_cliente
    FROM reserva_pacote
);

-- ============================================================
-- 4. EXISTS
-- ============================================================
-- Destinos que possuem pelo menos uma hospedagem associada
SELECT 
    d.id_destino,
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE EXISTS (
    SELECT 1
    FROM hospedagem AS h
    WHERE h.id_destino = d.id_destino
);

-- ============================================================
-- 5. NOT EXISTS
-- ============================================================
-- Destinos que não possuem nenhuma hospedagem associada
SELECT 
    d.id_destino,
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM hospedagem AS h
    WHERE h.id_destino = d.id_destino
);

-- ============================================================
-- 6. MAX / MIN
-- ============================================================
-- Hospedagem(ns) com o maior valor de diária
SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria = (
    SELECT MAX(valor_diaria)
    FROM hospedagem
);

-- ============================================================
-- 7. SUBQUERY CORRELACIONADA
-- ============================================================
-- Hospedagens com valor de diária superior à média da sua própria categoria/tipo
SELECT 
    h1.nome,
    h1.tipo,
    h1.valor_diaria
FROM hospedagem AS h1
WHERE h1.valor_diaria > (
    SELECT AVG(h2.valor_diaria)
    FROM hospedagem AS h2
    WHERE h2.tipo = h1.tipo
);

-- ============================================================
-- 8. PROBLEMA 1 — JOIN vs SUBQUERY
-- ============================================================
-- Pergunta: Quais clientes possuem reservas ativas cadastradas?

-- PROBLEMA 1 - JOIN
SELECT DISTINCT
    c.id_cliente,
    c.nome,
    c.email
FROM cliente AS c
INNER JOIN reserva_pacote AS r ON c.id_cliente = r.id_cliente;

-- PROBLEMA 1 - SUBQUERY
SELECT 
    c.id_cliente,
    c.nome,
    c.email
FROM cliente AS c
WHERE c.id_cliente IN (
    SELECT r.id_cliente 
    FROM reserva_pacote AS r
);

-- ============================================================
-- 9. PROBLEMA 2 — JOIN vs SUBQUERY
-- ============================================================
-- Pergunta: Quais são os nomes dos destinos onde há reservas efetuadas?

-- PROBLEMA 2 - JOIN
SELECT DISTINCT
    d.nome AS destino,
    d.pais
FROM destino AS d
INNER JOIN hospedagem AS h ON d.id_destino = h.id_destino
INNER JOIN reserva_pacote AS r ON h.id_hospedagem = r.id_hospedagem;

-- PROBLEMA 2 - SUBQUERY
SELECT 
    d.nome AS destino,
    d.pais
FROM destino AS d
WHERE d.id_destino IN (
    SELECT h.id_destino
    FROM hospedagem AS h
    WHERE h.id_hospedagem IN (
        SELECT r.id_hospedagem
        FROM reserva_pacote AS r
    )
);