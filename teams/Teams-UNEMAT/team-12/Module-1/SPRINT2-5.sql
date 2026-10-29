-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 2/5 — DDL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO:João Guilherme Barros de Lima
-- TEMA DO BANCO: Anúncios de imóveis 
-- NOME DO BANCO: real_estate_database
--
-- INSTRUÇÕES:
-- 1. Este arquivo é um MODELO GENÉRICO.
-- 2. Substitua os nomes de banco, tabelas e campos.
-- 3. Adapte os tipos de dados ao seu projeto.
-- 4. Adicione/remova campos conforme a SPRINT1-5.md.
-- 5. Não entregue este arquivo sem adaptar.
-- 6. Teste todo o script no MySQL Workbench.
--
-- ============================================================


-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS real_estate_database;

USE real_estate_database;


-- ============================================================
-- 2. TABELA 1 — ENTIDADE INDEPENDENTE
-- ============================================================
--
-- Substitua "tabela_a" pelo nome real da primeira entidade.
--

CREATE TABLE corretor (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    creci VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);


-- ============================================================
-- 3. TABELA 2 — OUTRA ENTIDADE INDEPENDENTE
-- ============================================================

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);


-- ============================================================
-- 4. TABELA 3 — EXEMPLO COM FOREIGN KEY
-- ============================================================
--
-- Esta tabela depende da tabela_a.
-- Portanto, tabela_a precisa existir antes.
--

CREATE TABLE imovel (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,

    id_corretor INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade_comodos INT NOT NULL,
    cidade VARCHAR(100) NOT NULL,

    CONSTRAINT fk_imovel_corretor
        FOREIGN KEY (id_corretor)
        REFERENCES corretor(id_corretor)
);


-- ============================================================
-- 5. TABELA 4 — EXEMPLO DE TABELA ASSOCIATIVA
-- ============================================================
--
-- Exemplo para relacionamento N:N.
-- Adapte ou substitua caso seu projeto não possua esse tipo
-- de relacionamento.
--

CREATE TABLE agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,

    data_visita DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente',

    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_agendamento_imovel
        FOREIGN KEY (id_imovel)
        REFERENCES imovel(id_imovel)
);


-- ============================================================
-- 6. OUTRAS TABELAS DO PROJETO
-- ============================================================
--
-- Caso seu banco possua mais tabelas, continue seguindo
-- a mesma lógica.
--
-- Exemplo:
--
-- CREATE TABLE tabela_e (
--     id_e INT PRIMARY KEY AUTO_INCREMENT,
--     campo_e1 VARCHAR(100) NOT NULL
-- );
--


-- ============================================================
-- 7. ALTER TABLE
-- ============================================================
--
-- Faça pelo menos uma alteração estrutural controlada.
-- Substitua pelo comando adequado ao seu banco.
--

ALTER TABLE cliente
ADD COLUMN data_nascimento DATE;


-- ============================================================
-- 8. TESTE CONTROLADO DE DROP TABLE
-- ============================================================
--
-- Crie uma tabela apenas para testar DROP TABLE.
--

CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;


-- ============================================================
-- 9. VALIDAÇÃO DAS TABELAS
-- ============================================================
--
-- Execute DESCRIBE para cada tabela real do seu projeto.
--

DESCRIBE corretor;
DESCRIBE cliente;
DESCRIBE imovel;
DESCRIBE agendamento;


-- ============================================================
-- 10. VERIFICAR O CREATE TABLE GERADO PELO MYSQL
-- ============================================================
--
-- Estes comandos ajudam a verificar PK, FK, UNIQUE e outras
-- restrições.
--

SHOW CREATE TABLE corretor;
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE imovel;
SHOW CREATE TABLE agendamento;


-- ============================================================
-- 11. ESPAÇO PARA O SCRIPT FINAL DO ALUNO 
-- ============================================================
--
-- Depois de adaptar e testar as seções acima:
--
-- 1. remova exemplos que não façam parte do seu projeto;
-- 2. mantenha somente as tabelas reais do seu banco;
-- 3. organize as tabelas na ordem correta;
-- 4. confira todas as PRIMARY KEY;
-- 5. confira todas as FOREIGN KEY;
-- 6. confira tipos e restrições;
-- 7. execute novamente o arquivo inteiro no Workbench;
-- 8. salve com o nome SPRINT2-5.sql.
--
-- FIM DA SPRINT 2/5
-- ============================================================
