SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
    
    SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
    
    SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
    
    SELECT 
    c.nome_categoria,
    c.faixa_etaria,
    a.nome_atleta
FROM categoria AS c
LEFT JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;
    
    SELECT 
    e.nome_escola,
    a.nome_atleta,
    a.genero
FROM escola AS e
RIGHT JOIN atleta AS a
    ON e.id_escola = a.id_escola;
    
    SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.nome_escola,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
    
    SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;

SELECT
    a.nome_atleta,
    e.nome_escola,
    c.nome_categoria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
WHERE e.tipo_rede = 'Estadual'
  AND c.nome_categoria LIKE '%Sub%';
  
  SELECT
    a.nome_atleta,
    a.data_nascimento,
    e.nome_escola,
    c.nome_categoria
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
ORDER BY a.nome_atleta ASC;

SELECT
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
LEFT JOIN atleta AS a
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
ORDER BY total_atletas DESC;

SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;

SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
    
    SELECT
    a.nome_atleta,
    c.nome_categoria,
    e.nome_escola
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
    
    -- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. INNER JOIN 1: Relacionamento entre Atleta e Escola
-- =====================================================================
SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 2. INNER JOIN 2: Cruzamento Triplo (Atleta, Categoria e Escola)
-- =====================================================================
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 3. LEFT JOIN: Categorias e Atletas (Garantindo categorias sem atletas)
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria,
    a.nome_atleta
FROM categoria AS c
LEFT JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;

-- =====================================================================
-- 4. RIGHT JOIN: Atletas e Escolas (Garantindo atletas sem escola)
-- =====================================================================
SELECT 
    e.nome_escola,
    a.nome_atleta,
    a.genero
FROM escola AS e
RIGHT JOIN atleta AS a
    ON e.id_escola = a.id_escola;

-- =====================================================================
-- 5. JOIN COM 3+ TABELAS 1: Relatório Completo Institucional
-- =====================================================================
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.nome_escola,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 6. JOIN COM 3+ TABELAS 2: Agregação por Escola e Categoria
-- =====================================================================
SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;

-- =====================================================================
-- 7. JOIN + WHERE: Filtrando por Rede Estadual e Categorias de Base
-- =====================================================================
SELECT
    a.nome_atleta,
    e.nome_escola,
    c.nome_categoria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
WHERE e.tipo_rede = 'Estadual'
  AND c.nome_categoria LIKE '%Sub%';

-- =====================================================================
-- 8. JOIN + ORDER BY: Listagem Geral Ordenada Alfabeticamente
-- =====================================================================
SELECT
    a.nome_atleta,
    a.data_nascimento,
    e.nome_escola,
    c.nome_categoria
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
ORDER BY a.nome_atleta ASC;

-- =====================================================================
-- 9. JOIN + GROUP BY + AGREGAÇÃO: Quantitativo Total por Escola
-- =====================================================================
SELECT
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
LEFT JOIN atleta AS add
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
ORDER BY total_atletas DESC;

