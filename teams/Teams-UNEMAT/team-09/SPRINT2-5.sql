-- ============================================================
-- 11. ESPAÇO PARA O SCRIPT FINAL DO ALUNO
-- ============================================================
--
-- SCRIPT COMPLETO E DEFINITIVO — SPRINT 2/5 (DDL)
-- ALUNO: Vinícius Eduardo Lima de Assis
-- TEMA DO BANCO: Viagens
-- NOME DO BANCO: pacote_viagens
--
-- ============================================================

-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS pacote_viagens;
USE pacote_viagens;


-- 2. TABELAS INDEPENDENTES
CREATE TABLE destino (
    id_destino INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(60) NOT NULL,
    estado VARCHAR(60),
    descricao TEXT
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE transporte (
    id_transporte INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL,
    empresa VARCHAR(100) NOT NULL,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL
);


-- 3. TABELA COM FOREIGN KEY (1:N)
CREATE TABLE hospedagem (
    id_hospedagem INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    id_destino INT NOT NULL,

    CONSTRAINT fk_hospedagem_destino
        FOREIGN KEY (id_destino)
        REFERENCES destino(id_destino)
);


-- 4. TABELA ASSOCIATIVA (N:N COM CHAVE PRIMÁRIA PRÓPRIA)
CREATE TABLE reserva_pacote (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_hospedagem INT NOT NULL,
    id_transporte INT NOT NULL,
    data_reserva DATE NOT NULL,
    quantidade_pessoas INT NOT NULL DEFAULT 1,

    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_reserva_hospedagem
        FOREIGN KEY (id_hospedagem)
        REFERENCES hospedagem(id_hospedagem),
        
    CONSTRAINT fk_reserva_transporte
        FOREIGN KEY (id_transporte)
        REFERENCES transporte(id_transporte)        
);


-- 5. VALIDAÇÃO DA ESTRUTURA DAS TABELAS
DESCRIBE cliente;
DESCRIBE destino;
DESCRIBE transporte;
DESCRIBE hospedagem;
DESCRIBE reserva_pacote;


-- 6. VERIFICAÇÃO DE CHAVES E RESTRIÇÕES GERADAS PELO MYSQL
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE destino;
SHOW CREATE TABLE transporte;
SHOW CREATE TABLE hospedagem;
SHOW CREATE TABLE reserva_pacote;

-- ============================================================
-- FIM DA SPRINT 2/5
-- ============================================================
