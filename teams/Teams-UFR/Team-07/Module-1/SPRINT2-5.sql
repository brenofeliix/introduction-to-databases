-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS db_raaei
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- Selecionando o Banco de Dados
USE db_raaei;
INT para chaves primárias e idades.

VARCHAR(150) para nomes, cargos e redes de ensino.

CHAR(11) para CPFs (tamanho fixo e previsível).

DATE para datas de nascimento e cadastro.

-- ============================================================
-- SPRINT 2/5 — ESTRUTURA DDL DO BANCO DE DADOS
-- PROJETO: Gestão de Atletas e Colaboradores da RAAEI
-- AUTOR: Walter Anacleto Salido de Souza
-- ============================================================

-- 1. Criação e Seleção do Banco de Dados
CREATE DATABASE IF NOT EXISTS db_raaei
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE db_raaei;

-- ------------------------------------------------------------
-- 2. Tabelas Independentes (Pais)
-- ------------------------------------------------------------

-- Tabela de Escolas parceiras
CREATE TABLE escola (
    id_escola INT PRIMARY KEY AUTO_INCREMENT,
    nome_escola VARCHAR(150) NOT NULL,
    tipo_rede VARCHAR(50) NOT NULL,
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL DEFAULT 'Rondonópolis'
);

-- Tabela de Categorias do Atletismo
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL,
    idade_minima INT NOT NULL,
    idade_maxima INT NOT NULL,
    genero_categoria VARCHAR(50) NOT NULL
);

-- Tabela de Colaboradores e Diretoria
CREATE TABLE colaborador (
    id_colaborador INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    cargo_funcao VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_cadastro DATE NOT NULL
);

-- ------------------------------------------------------------
-- 3. Tabelas Relacionadas (Filhas com Chaves Estrangeiras)
-- ------------------------------------------------------------

-- Tabela de Atletas da Associação
CREATE TABLE atleta (
    id_atleta INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    nome_mae VARCHAR(150),
    nome_pai VARCHAR(150),
    endereco VARCHAR(200) NOT NULL,
    id_escola INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT fk_atleta_escola
        FOREIGN KEY (id_escola)
        REFERENCES escola(id_escola),

    CONSTRAINT fk_atleta_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);

-- ------------------------------------------------------------
-- 4. Modificações Estruturais (ALTER TABLE)
-- ------------------------------------------------------------

-- Adicionando campo para registro de observações médicas dos atletas
ALTER TABLE atleta ADD COLUMN observacoes_medicas TEXT;

-- ------------------------------------------------------------
-- 5. Exercício Controlado de DROP TABLE
-- ------------------------------------------------------------

-- Criação de tabela temporária de testes
CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

-- Remoção controlada da tabela temporária
DROP TABLE tabela_teste;

-- ------------------------------------------------------------
-- 6. Comandos de Validação da Estrutura
-- ------------------------------------------------------------

DESCRIBE escola;
DESCRIBE categoria;
DESCRIBE colaborador;
DESCRIBE atleta;

SHOW CREATE TABLE atleta;

x'