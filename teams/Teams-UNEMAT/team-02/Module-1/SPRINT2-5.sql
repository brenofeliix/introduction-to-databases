-- ============================================================
-- SPRINT 2/5
-- Sistema de Gerenciamento de Incidentes de Segurança
-- Aluna: Geovanna Gaspar Ribeiro
-- ============================================================
 
-- ------------------------------------------------------------
-- BANCO DE DADOS
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS gerenciamento_incidentes;
USE gerenciamento_incidentes;

-- ------------------------------------------------------------
-- TABELA 1 — ANALISTAS (independente)
-- ------------------------------------------------------------

CREATE TABLE analistas (
id_analista INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
email VARCHAR(150) NOT NULL UNIQUE,
cargo VARCHAR(100)
);

-- ------------------------------------------------------------
-- TABELA 2 — DISPOSITIVOS (independente)
-- ------------------------------------------------------------
CREATE TABLE dispositivos (
id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
nome_dispositivo VARCHAR(100) NOT NULL,
tipo_dispositivo VARCHAR(50) NOT NULL,
ip_address VARCHAR(45) NOT NULL UNIQUE,
ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABELA 3 — TIPOS_AMEACAS (independente)
-- ------------------------------------------------------------  

CREATE TABLE tipos_ameacas (
id_ameaca INT PRIMARY KEY AUTO_INCREMENT,
nome_ameaca VARCHAR(200) NOT NULL UNIQUE,
descricao TEXT
);

-- ------------------------------------------------------------
-- TABELA 4 — ALERTAS (depende de DISPOSITIVOS)
-- ------------------------------------------------------------
CREATE TABLE alertas (
id_alerta INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(100) NOT NULL UNIQUE,
descricao TEXT,
data_alerta DATETIME NOT NULL,
status VARCHAR(30) NOT NULL DEFAULT 'Novo',
id_dispositivo INT NOT NULL,

CONSTRAINT fk_alertas_dispositivos
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)

);

-- ------------------------------------------------------------
-- TABELA 5 — INCIDENTES (depende de ANALISTAS, DISPOSITIVOS,
--            TIPOS_AMEACAS e ALERTAS)
-- ------------------------------------------------------------

CREATE TABLE incidentes (
    id_incidente        INT PRIMARY KEY AUTO_INCREMENT,
    titulo              VARCHAR(150) NOT NULL,
    descricao           TEXT NOT NULL,
    severidade          VARCHAR(30) NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'ABERTO',
    data_identificacao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_encerramento   DATETIME NULL,
    id_analista         INT NULL,
    id_dispositivo      INT NULL,
    id_ameaca           INT NULL,
    id_alerta           INT NULL,
 
    CONSTRAINT fk_incidentes_analistas
        FOREIGN KEY (id_analista)
        REFERENCES analistas(id_analista),
 
    CONSTRAINT fk_incidentes_dispositivos
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo),
 
    CONSTRAINT fk_incidentes_tipos_ameacas
        FOREIGN KEY (id_ameaca)
        REFERENCES tipos_ameacas(id_ameaca),
 
    CONSTRAINT fk_incidentes_alertas
        FOREIGN KEY (id_alerta)
        REFERENCES alertas(id_alerta)
);
 
-- ------------------------------------------------------------
-- TABELA 6 — ACOES_RESPOSTA (depende de INCIDENTES)
-- ------------------------------------------------------------
 
CREATE TABLE acoes_resposta (
    id_acao      INT PRIMARY KEY AUTO_INCREMENT,
    descricao    TEXT NOT NULL,
    data_acao    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_incidente INT NOT NULL,
 
    CONSTRAINT fk_acoes_incidentes
        FOREIGN KEY (id_incidente)
        REFERENCES incidentes(id_incidente)
);
 
-- ------------------------------------------------------------
-- ALTER TABLE — alteração estrutural 
-- ------------------------------------------------------------
 
ALTER TABLE incidentes
ADD COLUMN observacoes TEXT;
 
-- ------------------------------------------------------------
-- TABELA TEMPORÁRIA PARA PRATICAR DROP TABLE
-- ------------------------------------------------------------
 
CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);
 
DROP TABLE tabela_teste;
 
-- ------------------------------------------------------------
-- COMANDOS DE VALIDAÇÃO
-- ------------------------------------------------------------
 
DESCRIBE analistas;
DESCRIBE dispositivos;
DESCRIBE tipos_ameacas;
DESCRIBE alertas;
DESCRIBE incidentes;
DESCRIBE acoes_resposta;
 
SHOW CREATE TABLE incidentes;
