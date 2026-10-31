-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes

USE gerenciamento_incidentes;

-- ============================================================
-- SUBQUERY COM COMPARAÇÃO
-- Pergunta: quais dispositivos têm mais alertas registrados do
-- que a média de alertas por dispositivo?
-- ============================================================
SELECT d.nome_dispositivo,
       COUNT(al.id_alerta) AS total_alertas
FROM dispositivos d
JOIN alertas al ON al.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(al.id_alerta) > (
    SELECT AVG(qtd)
    FROM (
        SELECT COUNT(*) AS qtd
        FROM alertas
        GROUP BY id_dispositivo
    ) AS media_por_dispositivo
);


-- ============================================================
-- IN
-- Pergunta: quais analistas já têm pelo menos um incidente
-- atribuído?
-- ============================================================
SELECT nome
FROM analistas
WHERE id_analista IN (
    SELECT id_analista
    FROM incidentes
    WHERE id_analista IS NOT NULL
);


-- ============================================================
-- NOT IN
-- Pergunta: quais dispositivos nunca tiveram nenhum incidente
-- registrado?
-- ============================================================
SELECT nome_dispositivo
FROM dispositivos
WHERE id_dispositivo NOT IN (
    SELECT id_dispositivo
    FROM incidentes
    WHERE id_dispositivo IS NOT NULL
);


-- ============================================================
-- EXISTS
-- Pergunta: quais tipos de ameaça possuem pelo menos um
-- incidente vinculado?
-- ============================================================
SELECT t.nome_ameaca
FROM tipos_ameacas t
WHERE EXISTS (
    SELECT 1
    FROM incidentes i
    WHERE i.id_ameaca = t.id_ameaca
);


-- ============================================================
-- NOT EXISTS
-- Pergunta: quais alertas ainda não geraram nenhum incidente
-- vinculado a eles?
-- ============================================================
SELECT al.titulo
FROM alertas al
WHERE NOT EXISTS (
    SELECT 1
    FROM incidentes i
    WHERE i.id_alerta = al.id_alerta
);


-- ============================================================
-- MAX / MIN
-- Pergunta: qual foi o incidente com a data de identificação
-- mais antiga registrada no sistema?
-- ============================================================
SELECT titulo, data_identificacao
FROM incidentes
WHERE data_identificacao = (
    SELECT MIN(data_identificacao)
    FROM incidentes
);


-- ============================================================
-- SUBQUERY CORRELACIONADA
-- Pergunta: para cada analista, qual foi o incidente mais
-- recente atribuído a ele?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente_mais_recente,
       i.data_identificacao
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.data_identificacao = (
    SELECT MAX(i2.data_identificacao)
    FROM incidentes i2
    WHERE i2.id_analista = a.id_analista
);


-- ============================================================
-- PROBLEMA 1 - JOIN
-- Pergunta: quais analistas têm pelo menos um incidente
-- atribuído?
-- ============================================================
SELECT DISTINCT a.nome
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista;


-- ============================================================
-- PROBLEMA 1 - SUBQUERY
-- ============================================================
SELECT nome
FROM analistas
WHERE id_analista IN (
    SELECT id_analista
    FROM incidentes
    WHERE id_analista IS NOT NULL
);


-- ============================================================
-- PROBLEMA 2 - JOIN
-- Pergunta: quais dispositivos nunca tiveram nenhum alerta
-- registrado?
-- ============================================================
SELECT d.nome_dispositivo
FROM dispositivos d
LEFT JOIN alertas al ON al.id_dispositivo = d.id_dispositivo
WHERE al.id_alerta IS NULL;


-- ============================================================
-- PROBLEMA 2 - SUBQUERY
-- ============================================================
SELECT nome_dispositivo
FROM dispositivos
WHERE id_dispositivo NOT IN (
    SELECT id_dispositivo
    FROM alertas
    WHERE id_dispositivo IS NOT NULL
);

SELECT titulo, data_identificacao
FROM incidentes
WHERE data_identificacao = (
    SELECT MIN(data_identificacao)
    FROM incidentes
);

SELECT titulo, data_identificacao
FROM incidentes
WHERE data_identificacao = (
    SELECT MAX(data_identificacao)
    FROM incidentes
);
