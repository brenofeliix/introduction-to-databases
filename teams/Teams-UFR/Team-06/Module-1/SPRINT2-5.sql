-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 2/5 — DDL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
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

CREATE DATABASE IF NOT EXISTS locacao_de_filmes;

USE locacao_de_filmes;


-- ============================================================
-- 2. TABELA 1 — ENTIDADE INDEPENDENTE
-- ============================================================
--
-- Substitua "tabela_a" pelo nome real da primeira entidade.
--

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),

    ativo BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- 3. TABELA 2 — OUTRA ENTIDADE INDEPENDENTE
-- ============================================================

CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE genero (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200),
    classificado VARCHAR(50),
    
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- 4. TABELA 3 — EXEMPLO COM FOREIGN KEY
-- ============================================================
--
-- Esta tabela depende da tabela_a.
-- Portanto, tabela_a precisa existir antes.
--

CREATE TABLE filme (
    id_filme INT PRIMARY KEY AUTO_INCREMENT,

    titulo VARCHAR(150) NOT NULL,
    ano_lancamento YEAR NOT NULL,
    avaliacao DECIMAL(3,1),
    diretor VARCHAR(100) NOT NULL,
    id_genero INT NOT NULL,

    CONSTRAINT fk_filme_genero
        FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero)
);


-- ============================================================
-- 5. TABELA 4 — EXEMPLO DE TABELA ASSOCIATIVA
-- ============================================================
--
-- Exemplo para relacionamento N:N.
-- Adapte ou substitua caso seu projeto não possua esse tipo
-- de relacionamento.
--

CREATE TABLE locacao (
    id_locacao INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_locacao DATE NOT NULL DEFAULT (CURRENT_DATE),
    data_devolucao DATE,

    CONSTRAINT fk_locacao_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_locacao_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
        
);

CREATE TABLE item_locacao (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_locacao INT NOT NULL,
    id_filme INT NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_locacao
        FOREIGN KEY (id_locacao)
        REFERENCES locacao(id_locacao),

    CONSTRAINT fk_item_filme
        FOREIGN KEY (id_filme)
        REFERENCES filme(id_filme),
        
    CONSTRAINT uq_item_locacao_filme
        UNIQUE (id_locacao, id_filme)
        
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

ALTER TABLE filme
MODIFY COLUMN titulo VARCHAR(150) NOT NULL;


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

DESCRIBE cliente;
DESCRIBE funcionario;
DESCRIBE genero;
DESCRIBE filme;
DESCRIBE locacao;
DESCRIBE item_locacao;


-- ============================================================
-- 10. VERIFICAR O CREATE TABLE GERADO PELO MYSQL
-- ============================================================
--
-- Estes comandos ajudam a verificar PK, FK, UNIQUE e outras
-- restrições.
--

SHOW CREATE TABLE cliente;
SHOW CREATE TABLE funcionario;
SHOW CREATE TABLE genero;
SHOW CREATE TABLE filme;
SHOW CREATE TABLE locacao;
SHOW CREATE TABLE item_locacao;


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
