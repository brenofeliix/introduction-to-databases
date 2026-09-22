-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- 
-- Aluna      : Raquel Silva dos Santos
-- Banco      : series_watchlist_db

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================
USE series_watchlist_db;
-- ============================================================
-- INSERTS — TABELAS INDEPENDENTES
-- ============================================================

-- Tabela 1: PLATAFORMA (sem dependências)
INSERT INTO plataforma (nome_plataforma)
VALUES 
    ('Netflix'),
    ('HBO Max'),
    ('Prime Video'),
    ('Disney+'),
    ('Apple TV+'),
    ('Paramount+');

-- Tabela 2: USUARIO (sem dependências)
INSERT INTO usuario (nome, email, data_cadastro)
VALUES 
    ('Lucas Silveira', 'lucas.silveira@email.com', '2024-01-15'),
    ('Beatriz Lima', 'beatriz.lima@email.com', '2024-02-10'),
    ('Carlos Eduardo', 'carlos.edu@email.com', '2024-02-28'),
    ('Mariana Santos', 'mariana.santos@email.com', '2024-03-05'),
    ('Rafael Souza', 'rafael.souza@email.com', '2024-03-12'),
    ('Fernanda Costa', 'fernanda.costa@email.com', '2024-03-20');

-- ============================================================
-- INSERTS — TABELAS DEPENDENTES
-- ============================================================

-- Tabela 3: SERIE (depende de PLATAFORMA)
INSERT INTO serie (titulo, genero, ano_lancamento, id_plataforma, pais_origem)
VALUES 
    ('Stranger Things', 'Ficção Científica', 2016, 1, 'EUA'),
    ('The Last of Us', 'Drama / Pós-Apocalíptico', 2023, 2, 'EUA'),
    ('The Boys', 'Ação / Super-heróis', 2019, 3, 'EUA'),
    ('The Mandalorian', 'Ficção Científica / Aventura', 2019, 4, 'EUA'),
    ('Severance', 'Suspense / Ficção Científica', 2022, 5, 'EUA'),
    ('Dark', 'Ficção Científica / Mistério', 2017, 1, 'Alemanha'),
    ('Succession', 'Drama', 2018, 2, 'EUA'),
    ('Serie Cancelada Teste', 'Comédia', 2020, 6, 'EUA');

-- ============================================================
-- INSERTS — TABELA ASSOCIATIVA (N:N)
-- ============================================================

-- Tabela 4: ITEM_WATCHLIST (depende de USUARIO e SERIE)
INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo, nota, comentario)
VALUES 
    (1, 1, 'Finalizado', 9.5, 'Excelente primeira e quarta temporadas.'),
    (1, 2, 'Assistindo', 9.0, 'Adaptação muito fiel ao jogo.'),
    (1, 5, 'Quero Ver', NULL, NULL),
    (2, 2, 'Finalizado', 10.0, 'Uma obra-prima dramática.'),
    (2, 6, 'Finalizado', 9.8, 'Roteiro complexo e trilha fantástica.'),
    (3, 3, 'Assistindo', 8.5, 'Sátira ácida muito boa.'),
    (3, 4, 'Quero Ver', NULL, NULL),
    (4, 1, 'Assistindo', 8.0, 'Ritmo bom.'),
    (4, 7, 'Finalizado', 9.7, 'Atuações impecáveis.'),
    (5, 5, 'Quero Ver', NULL, NULL),
    (6, 8, 'Quero Ver', NULL, 'Adicionada para teste de remoção.');

-- ============================================================
-- VERIFICAÇÕES INTERMEDIÁRIAS
-- ============================================================
SELECT * FROM plataforma;
SELECT * FROM usuario;
SELECT * FROM serie;
SELECT * FROM item_watchlist;

-- ============================================================
-- OPERAÇÕES DE UPDATE (Mínimo de 3)
-- ============================================================

-- UPDATE 1: Atualização de status na watchlist de um usuário
UPDATE item_watchlist
SET status_assistindo = 'Finalizado'
WHERE id_usuario = 1 AND id_serie = 2;

-- UPDATE 2: Atualização de e-mail de um usuário
UPDATE usuario
SET email = 'carlos.eduardo.dev@email.com'
WHERE id_usuario = 3;

-- UPDATE 3: Ajuste de gênero em uma série
UPDATE serie
SET genero = 'Drama / Ficção Científica'
WHERE id_serie = 2;

-- ============================================================
-- OPERAÇÕES DE DELETE (Mínimo de 2)
-- ============================================================

-- DELETE 1: Remover o registro filho na tabela associativa
DELETE FROM item_watchlist
WHERE id_usuario = 6 AND id_serie = 8;

-- DELETE 2: Remover o registro pai na tabela serie (agora sem impedimento de FK)
DELETE FROM serie
WHERE id_serie = 8;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT * FROM plataforma;
SELECT * FROM usuario;
SELECT * FROM serie;
SELECT * FROM item_watchlist;
