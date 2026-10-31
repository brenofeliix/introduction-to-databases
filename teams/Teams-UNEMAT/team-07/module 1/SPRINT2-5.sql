-- ============================================================
-- SPRINT 2/5
-- BANCO DE DADOS: SECRETARIA DE SAÚDE
-- Aluna: Talita de Oliveira Leite Sete
-- ============================================================

CREATE DATABASE secretaria_saude;
USE secretaria_saude;

-- ------------------------------------------------------------
-- TABELA 1 — PACIENTE (independente)
-- ------------------------------------------------------------
CREATE TABLE paciente (
    id_paciente     INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(120) NOT NULL,
    cpf             CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    sexo            CHAR(1),
    telefone        VARCHAR(20),
    endereco        VARCHAR(200) NOT NULL
);

-- ------------------------------------------------------------
-- TABELA 2 — PROFISSIONAL (independente)
-- ------------------------------------------------------------
CREATE TABLE profissional (
    id_profissional   INT PRIMARY KEY AUTO_INCREMENT,
    nome              VARCHAR(120) NOT NULL,
    registro_conselho VARCHAR(20) UNIQUE,
    cargo             VARCHAR(60) NOT NULL,
    setor             VARCHAR(60) NOT NULL
);

-- ------------------------------------------------------------
-- TABELA 3 — UNIDADE_SAUDE (independente)
-- ------------------------------------------------------------
CREATE TABLE unidade_saude (
    id_unidade  INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(120) NOT NULL,
    endereco    VARCHAR(200) NOT NULL,
    tipo        VARCHAR(30)
);

-- ------------------------------------------------------------
-- TABELA 4 — ATENDIMENTO (relacionada a paciente, profissional, unidade)
-- ------------------------------------------------------------
CREATE TABLE atendimento (
    id_atendimento   INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente      INT NOT NULL,
    id_profissional  INT NOT NULL,
    id_unidade       INT NOT NULL,
    data_hora        DATETIME NOT NULL,
    tipo_atendimento VARCHAR(60) NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'AGENDADO',
    CONSTRAINT fk_atendimento_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_atendimento_profissional
        FOREIGN KEY (id_profissional)
        REFERENCES profissional(id_profissional),
    CONSTRAINT fk_atendimento_unidade
        FOREIGN KEY (id_unidade)
        REFERENCES unidade_saude(id_unidade)
);

-- ------------------------------------------------------------
-- TABELA 5 — PRONTUARIO (relacionada a paciente e atendimento)
-- ------------------------------------------------------------
CREATE TABLE prontuario (
    id_prontuario  INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente    INT NOT NULL,
    id_atendimento INT NOT NULL UNIQUE,
    diagnostico    TEXT,
    observacoes    TEXT,
    data_registro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prontuario_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_prontuario_atendimento
        FOREIGN KEY (id_atendimento)
        REFERENCES atendimento(id_atendimento)
);

-- ------------------------------------------------------------
-- TABELA 6 — ESTOQUE_ITEM (relacionada a unidade_saude)
-- ------------------------------------------------------------
CREATE TABLE estoque_item (
    id_item     INT PRIMARY KEY AUTO_INCREMENT,
    id_unidade  INT NOT NULL,
    nome        VARCHAR(120) NOT NULL,
    tipo        VARCHAR(20) NOT NULL,
    quantidade  INT NOT NULL DEFAULT 0,
    validade    DATE,
    CONSTRAINT fk_estoque_unidade
        FOREIGN KEY (id_unidade)
        REFERENCES unidade_saude(id_unidade)
);

-- ------------------------------------------------------------
-- TABELA 7 — OBITO (relacionada a paciente)
-- ------------------------------------------------------------
CREATE TABLE obito (
    id_obito             INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente          INT NOT NULL UNIQUE,
    data_obito           DATE NOT NULL,
    causa                VARCHAR(200),
    unidade_responsavel  INT,
    CONSTRAINT fk_obito_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),
    CONSTRAINT fk_obito_unidade
        FOREIGN KEY (unidade_responsavel)
        REFERENCES unidade_saude(id_unidade)
);

-- ------------------------------------------------------------
-- ALTER TABLE — exercício exigido pela Sprint 2/5
-- ------------------------------------------------------------
ALTER TABLE profissional
ADD COLUMN telefone VARCHAR(20);

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
DESCRIBE paciente;
DESCRIBE profissional;
DESCRIBE unidade_saude;
DESCRIBE atendimento;
DESCRIBE prontuario;
DESCRIBE estoque_item;
DESCRIBE obito;

SHOW CREATE TABLE atendimento;