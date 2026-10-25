-- ============================================================
-- SPRINT 2/5
-- BANCO: db_restaurante_sabor
-- Aluno: Gabriel Sakaizawa Campos
-- ============================================================

-- ------------------------------------------------------------
-- IDENTIFICAÇÃO / CRIAÇÃO DO BANCO
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS db_restaurante_sabor;

USE db_restaurante_sabor;

-- ------------------------------------------------------------
-- TABELA 1 — CLIENTE (independente)
-- ------------------------------------------------------------

CREATE TABLE cliente (
    id_cliente     INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cpf            VARCHAR(11) NOT NULL UNIQUE,
    telefone       VARCHAR(15),
    data_cadastro  DATE NOT NULL
);

-- ------------------------------------------------------------
-- TABELA 2 — FUNCIONARIO (independente)
-- ------------------------------------------------------------

CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cargo          VARCHAR(50) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    ativo          BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABELA 3 — MESA (independente)
-- ------------------------------------------------------------

CREATE TABLE mesa (
    id_mesa     INT PRIMARY KEY AUTO_INCREMENT,
    numero      INT NOT NULL,
    capacidade  INT NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'livre'
);

-- ------------------------------------------------------------
-- TABELA 4 — PRODUTO (independente)
-- ------------------------------------------------------------

CREATE TABLE produto (
    id_produto  INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    categoria   VARCHAR(50) NOT NULL,
    preco       DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

-- ------------------------------------------------------------
-- TABELA 5 — PEDIDO (depende de CLIENTE, MESA, FUNCIONARIO)
-- ------------------------------------------------------------

CREATE TABLE pedido (
    id_pedido       INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente      INT NOT NULL,
    id_mesa         INT NOT NULL,
    id_funcionario  INT NOT NULL,
    data_pedido     DATE NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'aberto',

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_pedido_mesa
        FOREIGN KEY (id_mesa)
        REFERENCES mesa(id_mesa),

    CONSTRAINT fk_pedido_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
);

-- ------------------------------------------------------------
-- TABELA 6 — ITEM_PEDIDO (depende de PEDIDO e PRODUTO)
-- ------------------------------------------------------------

CREATE TABLE item_pedido (
    id_item_pedido  INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido       INT NOT NULL,
    id_produto      INT NOT NULL,
    quantidade      INT NOT NULL,
    preco_unitario  DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido(id_pedido),

    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);

-- ------------------------------------------------------------
-- ALTER TABLE
-- Adiciona campo de observação ao pedido (ex: "sem cebola",
-- "aniversário"), útil para o atendimento e não previsto
-- originalmente na Sprint 1/5.
-- ------------------------------------------------------------

ALTER TABLE pedido
ADD COLUMN observacao VARCHAR(200);

-- ------------------------------------------------------------
-- TABELA TEMPORÁRIA PARA PRATICAR DROP TABLE
-- ------------------------------------------------------------

CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;

-- ------------------------------------------------------------
-- VALIDAÇÕES
-- ------------------------------------------------------------

DESCRIBE cliente;
DESCRIBE funcionario;
DESCRIBE mesa;
DESCRIBE produto;
DESCRIBE pedido;
DESCRIBE item_pedido;

SHOW CREATE TABLE pedido;
SHOW CREATE TABLE item_pedido;
