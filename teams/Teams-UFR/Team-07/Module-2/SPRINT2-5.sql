SELECT 
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
HAVING COUNT(a.id_atleta) > (
    SELECT AVG(atletas_por_escola.total)
    FROM (
        SELECT COUNT(at.id_atleta) AS total
        FROM escola AS esc
        LEFT JOIN atleta AS at 
            ON esc.id_escola = at.id_escola
        GROUP BY esc.id_escola
    ) AS atletas_por_escola
);


SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola NOT IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);

SELECT 
    a1.nome_atleta,
    a1.data_nascimento,
    e.nome_escola
FROM atleta AS a1
INNER JOIN escola AS e 
    ON a1.id_escola = e.id_escola
WHERE a1.data_nascimento < (
    SELECT AVG(a2.data_nascimento)
    FROM atleta AS a2
    WHERE a2.id_escola = a1.id_escola
);

SELECT DISTINCT
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
INNER JOIN atleta AS a
    ON e.id_escola = a.id_escola;
    
    SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

SELECT DISTINCT
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
INNER JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;
    
    SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);


SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);


-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. SUBQUERY COM COMPARAÇÃO: Escolas com atletas acima da média geral
-- =====================================================================
SELECT 
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
HAVING COUNT(a.id_atleta) > (
    SELECT AVG(atletas_por_escola.total)
    FROM (
        SELECT COUNT(at.id_atleta) AS total
        FROM escola AS esc
        LEFT JOIN atleta AS at 
            ON esc.id_escola = at.id_escola
        GROUP BY esc.id_escola
    ) AS atletas_por_escola
);

-- =====================================================================
-- 2. IN: Escolas parceiras que possuem pelo menos um atleta ativo
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 3. NOT IN: Escolas cadastradas que ainda não possuem atletas vinculados
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola NOT IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 4. EXISTS: Categorias esportivas que possuem pelo menos um atleta ativo
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

-- =====================================================================
-- 5. NOT EXISTS: Categorias esportivas ociosas ou sem praticantes
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

-- =====================================================================
-- 6. MAX / MIN: Dados completos do atleta mais jovem da associação
-- =====================================================================
SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);

-- =====================================================================
-- 7. SUBQUERY CORRELACIONADA: Atletas mais novos que a média de sua escola
-- =====================================================================
SELECT 
    a1.nome_atleta,
    a1.data_nascimento,
    e.nome_escola
FROM atleta AS a1
INNER JOIN escola AS e 
    ON a1.id_escola = e.id_escola
WHERE a1.data_nascimento < (
    SELECT AVG(a2.data_nascimento)
    FROM atleta AS a2
    WHERE a2.id_escola = a1.id_escola
);

-- =====================================================================
-- 8. PROBLEMA 1 - JOIN: Escolas com atletas matriculados
-- =====================================================================
SELECT DISTINCT
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
INNER JOIN atleta AS a
    ON e.id_escola = a.id_escola;

-- =====================================================================
-- 9. PROBLEMA 1 - SUBQUERY: Escolas com atletas matriculados
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 10. PROBLEMA 2 - JOIN: Categorias esportivas com atletas ativos
-- =====================================================================
SELECT DISTINCT
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
INNER JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;

-- =====================================================================
-- 11. PROBLEMA 2 - SUBQUERY: Categorias esportivas com atletas ativos
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);



