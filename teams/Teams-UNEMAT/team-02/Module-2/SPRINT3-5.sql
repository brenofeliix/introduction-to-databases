-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes

USE gerenciamento_incidentes;

-- ============================================================
-- VIEW 1 — relacionamento entre tabelas
-- Pergunta: para cada incidente, quem é o analista responsável,
-- em qual dispositivo ocorreu e qual o tipo de ameaça envolvido?
-- ============================================================
CREATE VIEW vw_incidentes_detalhados AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista,
    d.nome_dispositivo AS dispositivo,
    t.nome_ameaca AS tipo_ameaca
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
JOIN tipos_ameacas t ON i.id_ameaca = t.id_ameaca;


-- ============================================================
-- VIEW 2 — agregação/resumo
-- Pergunta: quantos incidentes cada analista está acompanhando?
-- ============================================================
CREATE VIEW vw_incidentes_por_analista AS
SELECT
    a.id_analista,
    a.nome AS analista,
    COUNT(i.id_incidente) AS total_incidentes
FROM analistas a
LEFT JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome;


-- ============================================================
-- VIEW 3 — consulta operacional
-- Pergunta: quais incidentes ainda estão em aberto ou em análise?
-- ============================================================
CREATE VIEW vw_incidentes_em_aberto AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
WHERE i.status IN ('ABERTO', 'EM_ANALISE');


-- ============================================================
-- CONSULTAS SOBRE AS VIEWS
-- ============================================================
SELECT * FROM vw_incidentes_detalhados;
SELECT * FROM vw_incidentes_por_analista;
SELECT * FROM vw_incidentes_em_aberto;

SELECT * FROM vw_incidentes_em_aberto
WHERE severidade = 'ALTA';


-- ============================================================
-- CREATE OR REPLACE VIEW
-- Adiciona dispositivo e data de identificação à VIEW operacional
-- ============================================================
CREATE OR REPLACE VIEW vw_incidentes_em_aberto AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista,
    d.nome_dispositivo AS dispositivo,
    i.data_identificacao
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
WHERE i.status IN ('ABERTO', 'EM_ANALISE');


-- ============================================================
-- VIEW TEMPORÁRIA (exercício DROP VIEW)
-- ============================================================
CREATE VIEW vw_teste AS
SELECT nome, cargo
FROM analistas;


-- ============================================================
-- DROP VIEW
-- ============================================================
DROP VIEW vw_teste;


-- ============================================================
-- VALIDAÇÃO — lista as Views existentes no banco
-- ============================================================
SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- TESTE DE ATUALIZAÇÃO DOS DADOS-BASE
-- ============================================================
 
SELECT * FROM vw_incidentes_por_analista;

UPDATE incidentes
SET status = 'ENCERRADO'
WHERE id_incidente = 4;

SELECT * FROM vw_incidentes_por_analista;

