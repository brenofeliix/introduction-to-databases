-- MODULE 2 — SPRINT 3/5
-- VIEWS E ABSTRAÇÃO DE CONSULTAS

-- Aluno: Vinícius Eduardo Lima de Assis
-- Banco: pacote_viagens

USE pacote_viagens;

-- ============================================================
-- VIEW 1: Relacionamento entre tabelas (Detalhes da Reserva)
-- ============================================================
CREATE VIEW vw_detalhes_reservas AS
SELECT 
    r.id_reserva,
    c.nome AS nome_cliente,
    c.email AS email_cliente,
    h.nome AS nome_hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;

-- ============================================================
-- VIEW 2: Agregação e Resumo (Resumo por Destino)
-- ============================================================
CREATE VIEW vw_resumo_por_destino AS
SELECT 
    d.nome AS destino,
    d.pais,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.quantidade_pessoas) AS total_passageiros
FROM destino AS d
INNER JOIN hospedagem AS h ON d.id_destino = h.id_destino
INNER JOIN reserva_pacote AS r ON h.id_hospedagem = r.id_hospedagem
GROUP BY d.id_destino, d.nome, d.pais;

-- VIEW 2.1 (Opcional): Agregação de Média por Categoria
CREATE VIEW vw_media_diarias_categoria AS
SELECT 
    tipo,
    AVG(valor_diaria) AS media_diaria,
    COUNT(*) AS total_hospedagens
FROM hospedagem
GROUP BY tipo;

-- ============================================================
-- VIEW 3: Consulta Operacional do Sistema (Reservas Ativas)
-- ============================================================
CREATE VIEW vw_reservas_ativas AS
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    c.telefone,
    h.nome AS hospedagem,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
WHERE c.ativo = TRUE;

-- ============================================================
-- CONSULTAS SOBRE AS VIEWS
-- ============================================================
-- Consulta geral
SELECT * FROM vw_detalhes_reservas;

-- Consulta com filtro
SELECT * 
FROM vw_detalhes_reservas 
WHERE quantidade_pessoas > 2;

-- Consulta no resumo de destinos
SELECT * FROM vw_resumo_por_destino;

-- ============================================================
-- CREATE OR REPLACE VIEW
-- ============================================================
-- Atualização da VIEW de reservas ativas para incluir destino e e-mail
CREATE OR REPLACE VIEW vw_reservas_ativas AS
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    c.telefone,
    c.email,
    h.nome AS hospedagem,
    d.nome AS destino,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino
WHERE c.ativo = TRUE;

-- ============================================================
-- VIEW TEMPORÁRIA E DROP VIEW
-- ============================================================
-- Criação de VIEW temporária
CREATE VIEW vw_teste AS
SELECT id_cliente, nome FROM cliente;

-- Remoção da VIEW
DROP VIEW vw_teste;

-- ============================================================
-- VALIDAÇÃO DAS VIEWS
-- ============================================================
-- Listar todas as Views criadas no banco de dados
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Teste de atualização de dados da tabela base
UPDATE cliente 
SET nome = 'Carlos Silva Marques' 
WHERE id_cliente = 1;

-- Verificar a atualização refletida na VIEW
SELECT * FROM vw_detalhes_reservas WHERE id_reserva = 1;