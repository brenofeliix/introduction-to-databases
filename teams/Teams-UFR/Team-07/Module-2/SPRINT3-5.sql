CREATE VIEW vw_escolas_com_atletas AS
SELECT 
    e.id_escola,
    e.nome_escola,
    e.tipo_rede,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola, e.tipo_rede;


CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;
    
    
    SELECT 
    nome_atleta,
    nome_escola,
    nome_categoria
FROM vw_atletas_escolas_categorias
WHERE tipo_rede = 'Pública';

CREATE VIEW vw_resumo_atletas_por_categoria AS
SELECT 
    c.id_categoria,
    c.nome_categoria,
    c.faixa_etaria,
    COUNT(a.id_atleta) AS total_atletas
FROM categoria AS c
LEFT JOIN atleta AS a 
    ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria;

CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;

-- Consulta geral à view de resumo por categoria
SELECT *
FROM vw_resumo_atletas_por_categoria;

-- Consulta com filtro aplicado para listar apenas categorias com atletas ativos
SELECT 
    nome_categoria,
    faixa_etaria,
    total_atletas
FROM vw_resumo_atletas_por_categoria
WHERE total_atletas > 0
ORDER BY total_atletas DESC;

CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;

CREATE OR REPLACE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email,
    UPPER(cargo) AS cargo_formatado
FROM colaborador
WHERE cargo IS NOT NULL
  AND status_ativo = 1;
  
  -- Criação de uma VIEW temporária para teste operacional
CREATE VIEW vw_teste AS
SELECT 
    id_atleta,
    nome_atleta,
    genero
FROM atleta;

-- Consulta rápida para validar o funcionamento da VIEW criada
SELECT * 
FROM vw_teste;

-- Remoção controlada da VIEW temporária do banco de dados
DROP VIEW vw_teste;

-- 1. Consulta inicial à VIEW antes da alteração
SELECT * 
FROM vw_resumo_atletas_por_categoria
WHERE nome_categoria = 'Arremesso de Peso Sub-18';

-- 2. Inserção de um novo atleta na tabela base (afetando a categoria correspondente)
INSERT INTO atleta (nome_atleta, genero, data_nascimento, id_escola, id_categoria) 
VALUES ('Lucas Gabriel Silva', 'M', '2010-05-14', 1, 3);

-- 3. Consulta posterior à VIEW para verificar a atualização dinâmica
SELECT * 
FROM vw_resumo_atletas_por_categoria
WHERE nome_categoria = 'Arremesso de Peso Sub-18';


CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;
    
    
    
    -- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. VIEW 1 — Relacionamento entre tabelas (Atletas, Escolas e Categorias)
-- =====================================================================
CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;

-- =====================================================================
-- 2. VIEW 2 — Agregação ou resumo (Panorama de atletas por categoria)
-- =====================================================================
CREATE VIEW vw_resumo_atletas_por_categoria AS
SELECT 
    c.id_categoria,
    c.nome_categoria,
    c.faixa_etaria,
    COUNT(a.id_atleta) AS total_atletas
FROM categoria AS c
LEFT JOIN atleta AS a 
    ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria;

-- =====================================================================
-- 3. VIEW 3 — Consulta operacional do sistema (Colaboradores ativos)
-- =====================================================================
CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;

-- =====================================================================
-- 4. CONSULTAS SOBRE AS VIEWS
-- =====================================================================
-- Consulta geral à visão relacional filtrando por rede pública
SELECT 
    nome_atleta,
    nome_escola,
    nome_categoria
FROM vw_atletas_escolas_categorias
WHERE tipo_rede = 'Pública';

-- Consulta gerencial ordenada por volume de atletas
SELECT 
    nome_categoria,
    faixa_etaria,
    total_atletas
FROM vw_resumo_atletas_por_categoria
WHERE total_atletas > 0
ORDER BY total_atletas DESC;

-- =====================================================================
-- 5. CREATE OR REPLACE VIEW (Atualização da view de colaboradores)
-- =====================================================================
CREATE OR REPLACE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email,
    UPPER(cargo) AS cargo_formatado
FROM colaborador
WHERE cargo IS NOT NULL
  AND status_ativo = 1;

-- =====================================================================
-- 6. VIEW TEMPORÁRIA E TESTE COM DROP VIEW
-- =====================================================================
-- Criação de uma VIEW temporária para teste operacional
CREATE VIEW vw_teste AS
SELECT 
    id_atleta,
    nome_atleta,
    genero
FROM atleta;

-- Consulta rápida para validar a view temporária
SELECT * 
FROM vw_teste;

-- Remoção controlada da VIEW temporária
DROP VIEW vw_teste;

-- =====================================================================
-- 7. VALIDAÇÃO (Exibição de todas as Views ativas no banco)
-- =====================================================================
SHOW FULL TABLES
WHERE Table_type = 'VIEW';


