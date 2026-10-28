-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluna : Raquel Silva dos Santos
-- Banco : series_watchlist_db

USE series_watchlist_db;

-- INNER JOIN 1
-- Exibe os dados da série associados ao nome da plataforma de streaming
SELECT 
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    p.nome_plataforma AS servico_streaming
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;

-- INNER JOIN 2
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    w.status_assistindo,
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie;

-- LEFT JOIN
SELECT 
    u.nome AS usuario,
    u.email,
    s.titulo AS serie,
    w.status_assistindo,
    w.nota
FROM usuario AS u
LEFT JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
LEFT JOIN serie AS s
    ON w.id_serie = s.id_serie;
    
-- RIGHT JOIN
SELECT 
    s.titulo AS serie,
    p.nome_plataforma
FROM serie AS s
RIGHT JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
    
-- JOIN COM 3+ TABELAS 1
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    p.nome_plataforma,
    w.nota,
    w.comentario
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;

-- JOIN COM 3+ TABELAS 2
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    s.pais_origem,
    p.nome_plataforma,
    w.status_assistindo
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE w.status_assistindo IN ('Assistindo', 'Concluído');

-- JOIN + WHERE
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    p.nome_plataforma,
    w.status_assistindo,
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE p.nome_plataforma = 'HBO Max' 
  AND w.status_assistindo = 'Concluído';
  
  
-- JOIN + ORDER BY
SELECT 
    u.nome AS usuario,
    s.titulo AS serie,
    w.nota,
    w.status_assistindo
FROM item_watchlist AS w
INNER JOIN usuario AS u
    ON w.id_usuario = u.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
WHERE w.nota IS NOT NULL
ORDER BY w.nota DESC, u.nome ASC;


-- JOIN + GROUP BY + AGREGAÇÃO
SELECT 
    p.nome_plataforma,
    COUNT(s.id_serie) AS total_series_disponiveis
FROM plataforma AS p
LEFT JOIN serie AS s
    ON p.id_plataforma = s.id_plataforma
GROUP BY p.id_plataforma, p.nome_plataforma
ORDER BY total_series_disponiveis DESC;


-- CONSULTA MAIS ÚTIL (RELATÓRIO DE DESEMPENHO)
SELECT 
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_interessados,
    ROUND(AVG(w.nota), 2) AS media_avaliacao
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma
ORDER BY media_avaliacao DESC;
