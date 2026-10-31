-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE gerenciamento_incidentes;


-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- Consulta 01 — SELECT básico
-- Pergunta: quais dados existem, de forma geral, na tabela de incidentes?
SELECT *
FROM incidentes;

-- Consulta 02 — SELECT com colunas específicas
-- Pergunta: qual o título, a severidade e o status de cada incidente?
SELECT titulo, severidade, status
FROM incidentes;


-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta 03 — WHERE (uma condição)
-- Pergunta da Sprint 1/5: quais incidentes de segurança estão atualmente abertos?
SELECT titulo, severidade, status, data_identificacao
FROM incidentes
WHERE status = 'ABERTO';

-- Consulta 04 — WHERE com mais de uma condição
-- Pergunta da Sprint 1/5: quais incidentes possuem severidade alta ou crítica?
SELECT titulo, severidade, status
FROM incidentes
WHERE severidade IN ('ALTA', 'CRITICA')
  AND status <> 'ENCERRADO';


-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Consulta 05 — ORDER BY
-- Pergunta: quais foram os incidentes mais recentes?
SELECT titulo, severidade, data_identificacao
FROM incidentes
ORDER BY data_identificacao DESC;


-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- Consulta 06 — COUNT
-- Pergunta: quantos incidentes já foram registrados no total?
SELECT COUNT(*) AS total_incidentes
FROM incidentes;

-- Consulta 07 — SUM
-- Pergunta: quantos incidentes de severidade alta/crítica cada analista acompanha?
-- (o banco não possui um campo numérico "somável" naturalmente, como valores
-- monetários; por isso o SUM foi aplicado sobre uma expressão CASE, somando 1
-- para cada incidente crítico/alto de cada analista)
SELECT a.nome AS analista,
       SUM(CASE WHEN i.severidade IN ('ALTA', 'CRITICA') THEN 1 ELSE 0 END) AS incidentes_criticos
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome; 

-- Consulta 08 — AVG
-- Pergunta: em média, quantos incidentes cada analista está acompanhando?
SELECT AVG(quantidade) AS media_incidentes_por_analista
FROM (
    SELECT id_analista, COUNT(*) AS quantidade
    FROM incidentes
    WHERE id_analista IS NOT NULL
    GROUP BY id_analista
) AS incidentes_por_analista;

-- Consulta 09 — MIN e MAX
-- Pergunta: qual foi o incidente mais antigo e o mais recente registrado?
SELECT MIN(data_identificacao) AS incidente_mais_antigo,
       MAX(data_identificacao) AS incidente_mais_recente
FROM incidentes;


-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Consulta 10 — GROUP BY
-- Pergunta da Sprint 1/5: quantos incidentes foram registrados por tipo de ameaça?
SELECT t.nome_ameaca,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
GROUP BY t.id_ameaca, t.nome_ameaca
ORDER BY quantidade_incidentes DESC;


-- ============================================================
-- 6. HAVING
-- ============================================================

-- Consulta 11 — HAVING
-- Pergunta da Sprint 1/5: quais dispositivos estão relacionados ao maior
-- número de incidentes? (aqui, filtrando apenas os que têm mais de 1)
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;


-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- Consulta 12 — expressão calculada
-- Pergunta: quantos dias cada incidente já encerrado levou para ser resolvido?
SELECT titulo,
       data_identificacao,
       data_encerramento,
       TIMESTAMPDIFF(DAY, data_identificacao, data_encerramento) AS dias_para_resolucao
FROM incidentes
WHERE data_encerramento IS NOT NULL;


-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

-- Consulta 13 — JOIN simples
-- Pergunta da Sprint 1/5: quais incidentes estão sob responsabilidade de cada analista?
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
ORDER BY a.nome;