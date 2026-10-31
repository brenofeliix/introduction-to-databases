-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno: Geeovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes

USE gerenciamento_incidentes;

-- ============================================================
-- INNER JOIN 1
-- Pergunta: quais incidentes estão sob responsabilidade de cada
-- analista, e qual o status atual de cada um?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
ORDER BY a.nome;


-- ============================================================
-- INNER JOIN 2
-- Pergunta: quais dispositivos estiveram envolvidos em quais
-- incidentes, e qual a severidade registrada em cada caso?
-- ============================================================
SELECT d.nome_dispositivo AS dispositivo,
       i.titulo AS incidente,
       i.severidade
FROM dispositivos d
INNER JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
ORDER BY d.nome_dispositivo;


-- ============================================================
-- LEFT JOIN
-- Pergunta: quais tipos de ameaça existem cadastrados no sistema,
-- incluindo os que ainda não tiveram nenhum incidente registrado?
-- ============================================================
SELECT t.nome_ameaca AS tipo_ameaca,
       i.titulo AS incidente
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
ORDER BY t.nome_ameaca;


-- ============================================================
-- RIGHT JOIN
-- Pergunta: quais analistas existem cadastrados no sistema,
-- incluindo aqueles que não têm nenhum incidente atribuído?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM incidentes i
RIGHT JOIN analistas a ON i.id_analista = a.id_analista
ORDER BY a.nome;


-- ============================================================
-- JOIN COM 3+ TABELAS 1
-- Pergunta: quais incidentes cada analista está tratando, e em
-- qual dispositivo cada incidente ocorreu?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente,
       d.nome_dispositivo AS dispositivo
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
INNER JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
ORDER BY a.nome;


-- ============================================================
-- JOIN COM 3+ TABELAS 2
-- Pergunta: quais analistas estão tratando incidentes de qual
-- tipo de ameaça, e qual a severidade de cada um?
-- ============================================================
SELECT a.nome AS analista,
       t.nome_ameaca AS tipo_ameaca,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
INNER JOIN tipos_ameacas t ON i.id_ameaca = t.id_ameaca
ORDER BY a.nome;


-- ============================================================
-- JOIN + WHERE
-- Pergunta: quais incidentes de severidade crítica estão sob
-- responsabilidade de qual analista?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.severidade = 'CRITICA';


-- ============================================================
-- JOIN + ORDER BY
-- Pergunta: quais incidentes ocorreram em quais dispositivos,
-- ordenados da data de identificação mais recente para a mais
-- antiga?
-- ============================================================
SELECT d.nome_dispositivo AS dispositivo,
       i.titulo AS incidente,
       i.data_identificacao
FROM dispositivos d
INNER JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
ORDER BY i.data_identificacao DESC;


-- ============================================================
-- JOIN + GROUP BY + AGREGAÇÃO
-- Pergunta: quantos incidentes já encerrados cada analista
-- resolveu?
-- ============================================================
SELECT a.nome AS analista,
       COUNT(i.id_incidente) AS incidentes_encerrados
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.status = 'ENCERRADO'
GROUP BY a.id_analista, a.nome
ORDER BY incidentes_encerrados DESC;

