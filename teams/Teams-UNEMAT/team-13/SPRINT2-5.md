-- ============================================================
-- SPRINT 2/5 - SISTEMA ESCOLAR
-- Pedro Gustavo Macena da Silva
-- ============================================================

CREATE DATABASE IF NOT EXISTS sistema_escolar;

USE sistema_escolar;

-- ============================================================
-- TABELA ALUNO
-- ============================================================

CREATE TABLE aluno (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL
);

-- ============================================================
-- TABELA PROFESSOR
-- ============================================================

CREATE TABLE professor (
    id_professor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL
);

-- ============================================================
-- TABELA DISCIPLINA
-- ============================================================

CREATE TABLE disciplina (
    id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL,
    descricao VARCHAR(255),
    id_professor INT NOT NULL,

    CONSTRAINT fk_disciplina_professor
        FOREIGN KEY (id_professor)
        REFERENCES professor(id_professor)
);

-- ============================================================
-- TABELA TURMA
-- ============================================================

CREATE TABLE turma (
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    sala VARCHAR(20) NOT NULL
);

-- ============================================================
-- TABELA MATRICULA
-- ============================================================

CREATE TABLE matricula (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    id_disciplina INT NOT NULL,

    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES aluno(id_aluno),

    CONSTRAINT fk_matricula_turma
        FOREIGN KEY (id_turma)
        REFERENCES turma(id_turma),

    CONSTRAINT fk_matricula_disciplina
        FOREIGN KEY (id_disciplina)
        REFERENCES disciplina(id_disciplina)
);

-- ============================================================
-- ALTER TABLE
-- Exercício exigido pela Sprint 2
-- ============================================================

ALTER TABLE aluno
ADD COLUMN email VARCHAR(100) UNIQUE;

-- ============================================================
-- DROP TABLE
-- Exercício controlado
-- ============================================================

CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;

-- ============================================================
-- VALIDAÇÃO DA ESTRUTURA
-- ============================================================

DESCRIBE aluno;
DESCRIBE professor;
DESCRIBE disciplina;
DESCRIBE turma;
DESCRIBE matricula;

SHOW CREATE TABLE aluno;
SHOW CREATE TABLE professor;
SHOW CREATE TABLE disciplina;
SHOW CREATE TABLE turma;
SHOW CREATE TABLE matricula;