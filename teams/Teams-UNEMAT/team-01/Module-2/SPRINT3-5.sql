-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluna: Raquel Silva dos Santos
-- Banco: series_watchlist_db

USE series_watchlist_db;


-- VIEW 1: Relacionamento entre tabelas (Catálogo unificado com Plataforma)
CREATE OR REPLACE VIEW vw_catalogo_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    s.pais_origem,
    p.id_plataforma,
    p.nome_plataforma AS plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;


-- VIEW 2: Agregação e Resumo Estatístico de Avaliações
CREATE OR REPLACE VIEW vw_estatisticas_series AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_watchlist,
    COUNT(w.nota) AS total_avaliacoes,
    MIN(w.nota) AS menor_nota,
    MAX(w.nota) AS maior_nota,
    ROUND(AVG(w.nota), 2) AS media_nota
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY 
    s.id_serie, 
    s.titulo, 
    p.nome_plataforma;


-- VIEW 3: Consulta Operacional (Séries em Andamento / Consumo Ativo)
CREATE OR REPLACE VIEW vw_series_em_andamento AS
SELECT 
    u.id_usuario,
    u.nome AS usuario,
    u.email,
    s.id_serie,
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    w.status_assistindo,
    w.nota
FROM item_watchlist AS w
INNER JOIN usuario AS u
    ON w.id_usuario = u.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE w.status_assistindo = 'Assistindo';


-- CONSULTAS SOBRE AS VIEWS
-- Consulta 1: Listagem da VIEW 1 ordenada
SELECT 
    nome_serie, 
    genero, 
    plataforma
FROM vw_catalogo_series_plataforma
ORDER BY nome_serie ASC;

-- Consulta 2: Listagem completa da VIEW 2
SELECT * FROM vw_estatisticas_series;

-- Consulta 3: Filtro e ordenação analítica sobre a VIEW 2
SELECT 
    nome_serie, 
    plataforma, 
    media_nota, 
    total_avaliacoes
FROM vw_estatisticas_series
WHERE media_nota >= 9.0
ORDER BY media_nota DESC;

-- Consulta 4: Consulta sobre a VIEW operacional
SELECT * FROM vw_series_em_andamento;


-- CREATE OR REPLACE VIEW: Evolução da VIEW 1 com coluna calculada
CREATE OR REPLACE VIEW vw_catalogo_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    (2026 - s.ano_lancamento) AS anos_de_lancamento,
    s.pais_origem,
    p.id_plataforma,
    p.nome_plataforma AS plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;


-- VIEW TEMPORÁRIA E DROP VIEW: Exercício controlado
CREATE OR REPLACE VIEW vw_teste_temporaria AS
SELECT 
    id_usuario, 
    nome, 
    email
FROM usuario
WHERE data_cadastro >= '2024-03-01';

-- Remoção da view temporária (mantendo intactas as 3 views principais)
DROP VIEW IF EXISTS vw_teste_temporaria;

-- Validação da existência das 3 views ativas no schema
SHOW FULL TABLES 
WHERE Table_type = 'VIEW';

-- Teste de atualização dinâmica (exemplo documentado na seção 11)
SELECT nome_serie, media_nota, total_avaliacoes 
FROM vw_estatisticas_series 
WHERE id_serie = 1;
