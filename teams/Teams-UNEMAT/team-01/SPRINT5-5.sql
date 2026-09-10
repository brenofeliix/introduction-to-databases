-- ============================================================
-- IDENTIFICAÇÃO
-- Aluna      : Raquel Silva dos Santos
-- Banco      : series_watchlist_db
-- ============================================================

-- ============================================================
-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
-- ============================================================
DROP DATABASE IF EXISTS series_watchlist_db;
CREATE DATABASE series_watchlist_db;
USE series_watchlist_db;

-- ============================================================
-- 2. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================

-- Tabela 1 (Independente): Plataformas de Streaming
CREATE TABLE plataforma (
    id_plataforma   INT AUTO_INCREMENT,
    nome_plataforma VARCHAR(50) NOT NULL,

    CONSTRAINT pk_plataforma 
        PRIMARY KEY (id_plataforma),
    CONSTRAINT uq_plataforma_nome 
        UNIQUE (nome_plataforma)
);

-- Tabela 2 (Independente): Usuários do Sistema
CREATE TABLE usuario (
    id_usuario    INT AUTO_INCREMENT,
    nome          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL,
    data_cadastro DATE NOT NULL,

    CONSTRAINT pk_usuario 
        PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email 
        UNIQUE (email)
);

-- Tabela 3 (Dependente 1:N): Catálogo de Séries
CREATE TABLE serie (
    id_serie       INT AUTO_INCREMENT,
    titulo         VARCHAR(100) NOT NULL,
    genero         VARCHAR(50) NOT NULL,
    ano_lancamento INT NOT NULL,
    id_plataforma  INT NOT NULL,

    CONSTRAINT pk_serie 
        PRIMARY KEY (id_serie),
    CONSTRAINT fk_serie_plataforma 
        FOREIGN KEY (id_plataforma) 
        REFERENCES plataforma (id_plataforma)
);

-- Tabela 4 (Associativa N:N): Watchlist / Avaliações dos Usuários
CREATE TABLE item_watchlist (
    id_usuario        INT NOT NULL,
    id_serie          INT NOT NULL,
    status_assistindo VARCHAR(20) NOT NULL DEFAULT 'Quero Ver',
    nota              DECIMAL(3,1) NULL,
    comentario        VARCHAR(255) NULL,

    CONSTRAINT pk_item_watchlist 
        PRIMARY KEY (id_usuario, id_serie),
    CONSTRAINT fk_watchlist_usuario 
        FOREIGN KEY (id_usuario) 
        REFERENCES usuario (id_usuario),
    CONSTRAINT fk_watchlist_serie 
        FOREIGN KEY (id_serie) 
        REFERENCES serie (id_serie),
    CONSTRAINT chk_watchlist_nota 
        CHECK (nota >= 0.0 AND nota <= 10.0)
);

-- Alteração estrutural planejada na Sprint 2
ALTER TABLE serie
ADD COLUMN pais_origem VARCHAR(50) NULL DEFAULT 'EUA';

-- ============================================================
-- 3. INSERÇÃO DOS DADOS (DML)
-- ============================================================

-- Inserções em PLATAFORMA
INSERT INTO plataforma (nome_plataforma)
VALUES 
    ('Netflix'),
    ('HBO Max'),
    ('Prime Video'),
    ('Disney+'),
    ('Apple TV+'),
    ('Paramount+');

-- Inserções em USUARIO
INSERT INTO usuario (nome, email, data_cadastro)
VALUES 
    ('Lucas Silveira', 'lucas.silveira@email.com', '2024-01-15'),
    ('Beatriz Lima', 'beatriz.lima@email.com', '2024-02-10'),
    ('Carlos Eduardo', 'carlos.edu@email.com', '2024-02-28'),
    ('Mariana Santos', 'mariana.santos@email.com', '2024-03-05'),
    ('Rafael Souza', 'rafael.souza@email.com', '2024-03-12'),
    ('Fernanda Costa', 'fernanda.costa@email.com', '2024-03-20');

-- Inserções em SERIE
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

-- Inserções em ITEM_WATCHLIST
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
-- 4. MANIPULAÇÃO DE DADOS (UPDATES E DELETES)
-- ============================================================

-- UPDATEs
UPDATE item_watchlist
SET status_assistindo = 'Finalizado'
WHERE id_usuario = 1 AND id_serie = 2;

UPDATE usuario
SET email = 'carlos.eduardo.dev@email.com'
WHERE id_usuario = 3;

UPDATE serie
SET genero = 'Drama / Ficção Científica'
WHERE id_serie = 2;

-- DELETEs (respeitando a integridade referencial)
DELETE FROM item_watchlist
WHERE id_usuario = 6 AND id_serie = 8;

DELETE FROM serie
WHERE id_serie = 8;

-- ============================================================
-- 5. CONSULTAS SQL (DQL)
-- ============================================================

-- 5.1 SELECT básico
SELECT * 
FROM plataforma;

-- 5.2 SELECT com colunas específicas 
SELECT 
    titulo AS nome_da_serie, 
    genero AS categoria, 
    ano_lancamento AS ano_estreia
FROM serie;

-- 5.3 WHERE simples 
-- Pergunta: Quais séries cadastradas pertencem à plataforma "Netflix"?
SELECT id_serie, titulo, genero, ano_lancamento
FROM serie
WHERE id_plataforma = 1;

-- 5.4 WHERE com múltiplas condições
-- Pergunta: Quais séries cadastradas são do gênero "Drama" e foram lançadas a partir de 2020?
SELECT titulo, genero, ano_lancamento, pais_origem
FROM serie
WHERE genero LIKE '%Drama%' 
  AND ano_lancamento >= 2020;

-- 5.5 ORDER BY
-- Pergunta: Como listar o catálogo ordenado da produção mais recente para a mais antiga e por título?
SELECT titulo, ano_lancamento, genero
FROM serie
ORDER BY ano_lancamento DESC, titulo ASC;

-- 5.6 Agregação COUNT com WHERE e GROUP BY 
-- Pergunta: Quantas séries cada usuário tem marcadas com o status "Concluído"?
SELECT 
    id_usuario, 
    COUNT(*) AS total_Finalizado
FROM item_watchlist
WHERE status_assistindo = 'Finalizado'
GROUP BY id_usuario;

-- 5.7 Agregação SUM
-- Pergunta: Qual é o somatório total de pontos atribuídos pelas notas registradas?
SELECT SUM(nota) AS somatorio_pontos_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL;

-- 5.8 Agregação AVG com GROUP BY 
-- Pergunta: Qual é a média das notas de cada série calculada a partir das avaliações dos usuários?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS volume_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie;

-- 5.9 Agregações MIN e MAX
-- Pergunta: Quais foram as notas extremas (menor e maior avaliação) registradas no banco?
SELECT 
    MIN(nota) AS menor_nota,
    MAX(nota) AS maior_nota
FROM item_watchlist;

-- 5.10 GROUP BY com HAVING
-- Pergunta: Entre as séries avaliadas, quais obtiveram média de aprovação excelente (>= 9.0)?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
HAVING AVG(nota) >= 9.0;

-- 5.11 Expressão SQL
-- Pergunta: Há quantos anos cada série foi lançada em relação ao ano atual (2026)?
SELECT 
    titulo,
    ano_lancamento,
    (2026 - ano_lancamento) AS anos_desde_lancamento
FROM serie
ORDER BY anos_desde_lancamento ASC;

-- 5.12 Consulta Integrada 
-- Pergunta: Qual é o top 3 de séries com as maiores notas médias entre os usuários?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_final,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
ORDER BY media_final DESC
LIMIT 3;

-- ============================================================
-- 6. COMANDOS DE VALIDAÇÃO FINAL
-- ============================================================
SHOW TABLES;
DESCRIBE plataforma;
DESCRIBE usuario;
DESCRIBE serie;
DESCRIBE item_watchlist;