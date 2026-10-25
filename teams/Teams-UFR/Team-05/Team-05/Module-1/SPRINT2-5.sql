-- ============================================================
-- SPRINT 2/5 — BANCO DE DADOS: GESTÃO DE IMOBILIÁRIA
-- ALUNO: NICOLAS LINO OLIVEIRA
-- ============================================================


CREATE DATABASE IF NOT EXISTS banco_imobiliaria;
USE banco_imobiliaria;



CREATE TABLE corretores (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    creci VARCHAR(20) NOT NULL UNIQUE,
    comissao_percentual DECIMAL(5, 2) NOT NULL
);


CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    contato VARCHAR(100) NOT NULL,
    tipo_interesse VARCHAR(50),
    orcamento DECIMAL(12, 2)
);


CREATE TABLE imoveis (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,
    endereco VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco DECIMAL(12, 2) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'disponível'
);


CREATE TABLE gestoes (
    id_gestao INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT NOT NULL,
    id_corretor INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE DEFAULT NULL,
    CONSTRAINT fk_gestoes_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_gestoes_corretores
        FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
);


CREATE TABLE visitas (
    id_visita INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    data_visita DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'confirmada',
    CONSTRAINT fk_visitas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_visitas_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel)
);


CREATE TABLE propostas (
    id_proposta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    valor_proposto DECIMAL(12, 2) NOT NULL,
    data_proposta DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'em análise',
    CONSTRAINT fk_propostas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_propostas_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel)
);


CREATE TABLE contratos (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT NOT NULL,
    id_cliente INT NOT NULL,
    id_corretor INT NOT NULL,
    valor_final DECIMAL(12, 2) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    data_fechamento DATE NOT NULL,
    CONSTRAINT fk_contratos_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_contratos_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_contratos_corretores
        FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
);


ALTER TABLE imoveis
ADD COLUMN observacoes TEXT;


CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100)
);

DROP TABLE tabela_teste;


DESCRIBE corretores;
DESCRIBE clientes;
DESCRIBE imoveis;
DESCRIBE gestoes;
DESCRIBE visitas;
DESCRIBE propostas;
DESCRIBE contratos;