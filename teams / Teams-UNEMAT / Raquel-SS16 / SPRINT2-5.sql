-- ============================================================
-- IDENTIFICAÇÃO
-- Aluna      : Raquel Silva dos Santos
-- ============================================================

-- ============================================================
DROP DATABASE IF EXISTS series_watchlist_db;
CREATE DATABASE series_watchlist_db;

USE series_watchlist_db;

SELECT DATABASE();

-- ============================================================
-- TABELAS INDEPENDENTES
-- ============================================================

CREATE TABLE plataforma (
    id_plataforma   INT AUTO_INCREMENT,
    nome_plataforma VARCHAR(50) NOT NULL,

    CONSTRAINT pk_plataforma 
        PRIMARY KEY (id_plataforma),
    CONSTRAINT uq_plataforma_nome 
        UNIQUE (nome_plataforma)
);

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

-- ============================================================
-- TABELAS RELACIONADAS
-- ============================================================

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

-- ============================================================
-- TABELAS ASSOCIATIVAS (N:N)
-- ============================================================

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

-- ============================================================
-- ALTER TABLE
-- ============================================================
ALTER TABLE serie
ADD COLUMN pais_origem VARCHAR(50) NULL DEFAULT 'EUA';

-- ============================================================
-- EXERCÍCIO DE DROP TABLE
-- ============================================================
CREATE TABLE tabela_teste (
    id_teste  INT AUTO_INCREMENT,
    descricao VARCHAR(50),

    CONSTRAINT pk_tabela_teste 
        PRIMARY KEY (id_teste)
);

SHOW TABLES LIKE 'tabela_teste';

DROP TABLE tabela_teste;

SHOW TABLES LIKE 'tabela_teste';

-- ============================================================
-- COMANDOS DE VALIDAÇÃO
-- ============================================================
SHOW TABLES;

DESCRIBE plataforma;
DESCRIBE usuario;
DESCRIBE serie;
DESCRIBE item_watchlist;

SHOW CREATE TABLE serie;
SHOW CREATE TABLE item_watchlist;
