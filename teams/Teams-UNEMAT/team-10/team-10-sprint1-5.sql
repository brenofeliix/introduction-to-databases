-- ============================================================
-- SPRINT 2/5 — IMPLEMENTAÇÃO DDL DO BANCO BD_LOJA
-- Aluna: Leslie Bruna Pires dos Santos
-- ============================================================

-- 1. CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE IF NOT EXISTS bd_loja;
USE bd_loja;

-- 2. TABELAS INDEPENDENTES
CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS Produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0
);

-- 3. TABELAS DEPENDENTES (COM FOREIGN KEY)
CREATE TABLE IF NOT EXISTS Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento VARCHAR(30) NOT NULL,
    
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS Item_Pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    
    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido),
        
    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES Produto(id_produto)
);

-- 4. ALTERAÇÃO ESTRUTURAL
ALTER TABLE Cliente
ADD COLUMN telefone VARCHAR(20) AFTER cpf;

-- 5. DROP TABLE CONTROLADO
CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY AUTO_INCREMENT
);

DROP TABLE tabela_teste;

-- 6. COMANDOS DE VALIDAÇÃO
DESCRIBE Cliente;
DESCRIBE Produto;
DESCRIBE Pedido;
DESCRIBE Item_Pedido;

