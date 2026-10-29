-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluna: Raquel Silva dos Santos
-- Banco: series_watchlist_db

USE series_watchlist_db;

-- SUBQUERY COM COMPARAÇÃO
-- Pergunta: Quais são as séries cuja avaliação individual na watchlist foi superior à média aritmética de todas as notas registradas na plataforma?
SELECT 
    id_serie, 
    id_usuario, 
    nota, 
    comentario
FROM item_watchlist
WHERE nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);

-- IN
-- Pergunta: Quais usuários possuem pelo menos uma série registrada na sua lista de acompanhamento (item_watchlist)?
SELECT 
    id_usuario, 
    nome, 
    email
FROM usuario
WHERE id_usuario IN (
    SELECT DISTINCT id_usuario
    FROM item_watchlist
);

-- NOT IN
-- Pergunta: Quais plataformas de streaming registradas no sistema não possuem nenhuma série associada no catálogo?
SELECT 
    id_plataforma, 
    nome_plataforma
FROM plataforma
WHERE id_plataforma NOT IN (
    SELECT DISTINCT id_plataforma
    FROM serie
    WHERE id_plataforma IS NOT NULL
);

-- EXISTS
-- Pergunta: Quais usuários atribuíram nota máxima (10.0) a pelo menos uma série?
SELECT 
    u.id_usuario, 
    u.nome
FROM usuario AS u
WHERE EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
      AND w.nota = 10
);

-- NOT EXISTS
-- Pergunta: Quais usuários cadastrados no sistema ainda não têm nenhuma série adicionada à sua watchlist?
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
);

-- MAX / MIN
-- Pergunta: Quais são as séries mais antigas cadastradas no catálogo (que possuem o menor ano de lançamento)?
SELECT 
    id_serie, 
    titulo, 
    genero, 
    ano_lancamento
FROM serie
WHERE ano_lancamento = (
    SELECT MIN(ano_lancamento)
    FROM serie
);

-- SUBQUERY CORRELACIONADA
-- Pergunta: Quais séries em watchlist receberam nota individual superior à média de notas calculada especificamente para essa mesma série?
SELECT 
    w1.id_usuario, 
    w1.id_serie, 
    w1.nota, 
    w1.comentario
FROM item_watchlist AS w1
WHERE w1.nota > (
    SELECT AVG(w2.nota)
    FROM item_watchlist AS w2
    WHERE w2.id_serie = w1.id_serie
      AND w2.nota IS NOT NULL
);

-- PROBLEMA 1 - JOIN
-- Pergunta: Quais plataformas possuem séries cadastradas no catálogo?
SELECT DISTINCT 
    p.id_plataforma, 
    p.nome_plataforma
FROM plataforma AS p
INNER JOIN serie AS s
    ON p.id_plataforma = s.id_plataforma;

-- PROBLEMA 1 - SUBQUERY
-- Pergunta: Quais plataformas possuem séries cadastradas no catálogo?
SELECT 
    p.id_plataforma, 
    p.nome_plataforma
FROM plataforma AS p
WHERE p.id_plataforma IN (
    SELECT s.id_plataforma
    FROM serie AS s
);

-- PROBLEMA 2 - JOIN
-- Pergunta: Quais usuários nunca adicionaram nenhuma série à watchlist?
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
LEFT JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
WHERE w.id_usuario IS NULL;

-- PROBLEMA 2 - SUBQUERY
-- Pergunta: Quais usuários nunca adicionaram nenhuma série à watchlist?
SELECT 
    u.id_usuario, 
    u.nome, 
    u.email
FROM usuario AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM item_watchlist AS w
    WHERE w.id_usuario = u.id_usuario
);
