-- ============================================================
-- DISCIPLINA: Laboratório de Banco de Dados
-- SPRINT 2/5 — Implementação da Estrutura do Banco de Dados com DDL
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================

-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS db_salao_beleza;
USE db_salao_beleza;


-- ============================================================
-- 2. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- ============================================================

-- Tabela: cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

-- Tabela: profissional
CREATE TABLE profissional (
    id_profissional INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

-- Tabela: servico
CREATE TABLE servico (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    nome_servico VARCHAR(100) NOT NULL,
    duracao_minutos INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);


-- ============================================================
-- 3. CRIAÇÃO DA TABELA DEPENDENTE (COM CHAVES ESTRANGEIRAS)
-- ============================================================

-- Tabela: agendamento
CREATE TABLE agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_profissional INT NOT NULL,
    id_servico INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendado',
    forma_pagamento VARCHAR(20),

    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),

    CONSTRAINT fk_agendamento_profissional
        FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional),

    CONSTRAINT fk_agendamento_servico
        FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);


-- ============================================================
-- 4. EXERCÍCIO OBRIGATÓRIO: ALTER TABLE
-- ============================================================

-- Adiciona a coluna 'observacoes' para registrar detalhes sobre o atendimento
ALTER TABLE agendamento
ADD COLUMN observacoes VARCHAR(255);


-- ============================================================
-- 5. EXERCÍCIO CONTROLADO: DROP TABLE
-- ============================================================

-- Criação de tabela temporária para teste de exclusão segura
CREATE TABLE tabela_teste_exclusao (
    id_teste INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50)
);

-- Exclusão da tabela temporária
DROP TABLE tabela_teste_exclusao;


-- ============================================================
-- 6. COMANDOS DE VALIDAÇÃO DA ESTRUTURA
-- ============================================================

-- Validação com DESCRIBE (estrutura de colunas, tipos e chaves)
DESCRIBE cliente;
DESCRIBE profissional;
DESCRIBE servico;
DESCRIBE agendamento;

-- Validação com SHOW CREATE TABLE (verificação das constraints e FKs geradas)
SHOW CREATE TABLE agendamento;

