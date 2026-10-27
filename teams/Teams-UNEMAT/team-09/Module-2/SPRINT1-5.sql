-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno: Vinícius Eduardo Lima de Assis
-- Banco: pacote_viagens

USE pacote_viagens;

-- INNER JOIN 1: Relacionar hospedagens e seus respectivos destinos
SELECT 
    h.nome AS hospedagem,
    h.tipo,
    h.valor_diaria,
    d.nome AS destino,
    d.estado
FROM hospedagem AS h
INNER JOIN destino AS d
    ON h.id_destino = d.id_destino;

-- INNER JOIN 2: Relacionar clientes e suas reservas
SELECT 
    c.nome AS cliente,
    c.email,
    r.id_reserva,
    r.data_reserva,
    r.quantidade_pessoas
FROM cliente AS c
INNER JOIN reserva_pacote AS r
    ON c.id_cliente = r.id_cliente;

-- LEFT JOIN: Listar todos os clientes, inclusive os sem reserva
SELECT 
    c.nome AS cliente,
    c.email,
    r.id_reserva,
    r.data_reserva
FROM cliente AS c
LEFT JOIN reserva_pacote AS r
    ON c.id_cliente = r.id_cliente;

-- RIGHT JOIN: Listar todas as hospedagens, inclusive as sem reserva
SELECT 
    r.id_reserva,
    r.data_reserva,
    h.nome AS hospedagem,
    h.valor_diaria
FROM reserva_pacote AS r
RIGHT JOIN hospedagem AS h
    ON r.id_hospedagem = h.id_hospedagem;

-- JOIN COM 3+ TABELAS 1: Cliente, Hospedagem e Destino
SELECT 
    c.nome AS cliente,
    h.nome AS hospedagem,
    d.nome AS destino,
    d.pais
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino;

-- JOIN COM 3+ TABELAS 2: Cliente, Hospedagem e Transporte (Detalhamento Completo)
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    h.nome AS hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;

-- JOIN + WHERE: Reservas em hospedagens de alto valor (diária > 1000)
SELECT 
    c.nome AS cliente,
    h.nome AS hospedagem,
    h.valor_diaria
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
WHERE h.valor_diaria > 1000.00;

-- JOIN + ORDER BY: Hospedagens e destinos ordenados pelo valor da diária (Decrescente)
SELECT 
    d.nome AS destino,
    h.nome AS hospedagem,
    h.valor_diaria
FROM hospedagem AS h
INNER JOIN destino AS d ON h.id_destino = d.id_destino
ORDER BY h.valor_diaria DESC;

-- JOIN + GROUP BY + AGREGAÇÃO: Total de viajantes por destino
SELECT 
    d.nome AS destino,
    SUM(r.quantidade_pessoas) AS total_pessoas
FROM reserva_pacote AS r
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino
GROUP BY d.nome;