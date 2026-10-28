-- ============================================================
-- IDENTIFICACAO
-- ============================================================
-- Aluno: Rafael Tokashiki Souza
-- Disciplina: Laboratorio de Banco de Dados
-- Sprint: 2/5 - Estrutura do banco com DDL
-- Banco: imobiliaria
-- ============================================================


-- ============================================================
-- CRIACAO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS imobiliaria;

USE imobiliaria;


-- ============================================================
-- TABELAS INDEPENDENTES
-- Nao possuem chave estrangeira e por isso sao criadas primeiro.
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 1 - proprietarios
-- Donos dos imoveis administrados pela imobiliaria.
-- ------------------------------------------------------------

CREATE TABLE proprietarios (
    id_proprietario INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    cpf_cnpj        VARCHAR(18)  NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    email           VARCHAR(100),
    cidade          VARCHAR(80)
);


-- ------------------------------------------------------------
-- TABELA 2 - clientes
-- Pessoas interessadas em comprar ou alugar um imovel.
-- ------------------------------------------------------------

CREATE TABLE clientes (
    id_cliente     INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cpf            VARCHAR(14)  NOT NULL UNIQUE,
    telefone       VARCHAR(20),
    email          VARCHAR(100),
    interesse      VARCHAR(20)  NOT NULL DEFAULT 'Compra',
    data_cadastro  DATE         NOT NULL
);


-- ------------------------------------------------------------
-- TABELA 3 - corretores
-- Profissionais responsaveis pelo atendimento.
-- ------------------------------------------------------------

CREATE TABLE corretores (
    id_corretor    INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    creci          VARCHAR(20)  NOT NULL UNIQUE,
    telefone       VARCHAR(20),
    email          VARCHAR(100),
    data_admissao  DATE
);


-- ============================================================
-- TABELAS RELACIONADAS
-- Dependem das tabelas criadas acima.
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 4 - imoveis
-- Cada imovel pertence a um unico proprietario.
-- ------------------------------------------------------------

CREATE TABLE imoveis (
    id_imovel        INT PRIMARY KEY AUTO_INCREMENT,
    titulo           VARCHAR(150)  NOT NULL,
    tipo             VARCHAR(30)   NOT NULL,
    finalidade       VARCHAR(20)   NOT NULL,
    bairro           VARCHAR(80),
    cidade           VARCHAR(80)   NOT NULL,
    quartos          INT           NOT NULL DEFAULT 0,
    banheiros        INT           NOT NULL DEFAULT 0,
    vagas            INT           NOT NULL DEFAULT 0,
    area_m2          DECIMAL(8,2),
    preco            DECIMAL(12,2) NOT NULL,
    disponivel       BOOLEAN       NOT NULL DEFAULT TRUE,
    data_cadastro    DATE          NOT NULL,
    id_proprietario  INT           NOT NULL,

    CONSTRAINT fk_imoveis_proprietarios
        FOREIGN KEY (id_proprietario)
        REFERENCES proprietarios(id_proprietario)
);


-- ============================================================
-- TABELAS ASSOCIATIVAS
-- Resolvem o relacionamento N:N entre clientes e imoveis.
-- Cada uma possui atributos proprios, por isso usam
-- chave primaria propria em vez de chave composta.
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 5 - visitas
-- Registra a visita de um cliente a um imovel,
-- acompanhado por um corretor.
-- ------------------------------------------------------------

CREATE TABLE visitas (
    id_visita    INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel    INT  NOT NULL,
    id_cliente   INT  NOT NULL,
    id_corretor  INT  NOT NULL,
    data_visita  DATE NOT NULL,
    observacao   TEXT,

    CONSTRAINT fk_visitas_imoveis
        FOREIGN KEY (id_imovel)
        REFERENCES imoveis(id_imovel),

    CONSTRAINT fk_visitas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_visitas_corretores
        FOREIGN KEY (id_corretor)
        REFERENCES corretores(id_corretor)
);


-- ------------------------------------------------------------
-- TABELA 6 - contratos
-- Registra um negocio fechado de venda ou locacao.
-- ------------------------------------------------------------

CREATE TABLE contratos (
    id_contrato    INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel      INT           NOT NULL,
    id_cliente     INT           NOT NULL,
    id_corretor    INT           NOT NULL,
    tipo_contrato  VARCHAR(20)   NOT NULL,
    valor          DECIMAL(12,2) NOT NULL,
    data_inicio    DATE          NOT NULL,
    data_fim       DATE,

    CONSTRAINT fk_contratos_imoveis
        FOREIGN KEY (id_imovel)
        REFERENCES imoveis(id_imovel),

    CONSTRAINT fk_contratos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_contratos_corretores
        FOREIGN KEY (id_corretor)
        REFERENCES corretores(id_corretor)
);


-- ============================================================
-- ALTER TABLE
-- Durante a implementacao percebi que a tabela imoveis
-- precisava registrar tambem o valor do condominio,
-- informacao relevante para apartamentos e salas comerciais.
-- ============================================================

ALTER TABLE imoveis
ADD COLUMN valor_condominio DECIMAL(10,2) DEFAULT 0.00;


-- ============================================================
-- EXERCICIO DE DROP TABLE
-- Tabela temporaria criada apenas para praticar o comando.
-- Nao faz parte da estrutura final do projeto.
-- ============================================================

CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;


-- ============================================================
-- COMANDOS DE VALIDACAO
-- ============================================================

SHOW TABLES;

DESCRIBE proprietarios;
DESCRIBE clientes;
DESCRIBE corretores;
DESCRIBE imoveis;
DESCRIBE visitas;
DESCRIBE contratos;

SHOW CREATE TABLE imoveis;
SHOW CREATE TABLE visitas;
SHOW CREATE TABLE contratos;
