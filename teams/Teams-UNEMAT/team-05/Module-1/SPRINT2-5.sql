-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 2/5 — DDL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Ylma Cristina Souza Lopes
-- TEMA DO BANCO: Clinica
-- NOME DO BANCO: Clinica_Ser
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


CREATE DATABASE IF NOT EXISTS Clinica_Ser;
USE Clinica_Ser;

-- Tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15),
    sexo ENUM('M','F') NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    imagem VARCHAR(255)
);

-- Tabela Médico
CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    cro VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50)
);

-- Tabela Convênio
CREATE TABLE Convenio  (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Paciente vinculado a Convênio (1:1)
ALTER TABLE Paciente
ADD COLUMN id_convenio INT UNIQUE,
ADD CONSTRAINT fk_paciente_convenio FOREIGN KEY (id_convenio) REFERENCES Convenio(id_convenio);

-- Tabela Exame
CREATE TABLE Exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0)
);

-- Tabela Agendamento
CREATE TABLE Agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    data_agendamento DATETIME NOT NULL,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_exame INT NOT NULL,
    CONSTRAINT fk_agendamento_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    CONSTRAINT fk_agendamento_medico FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    CONSTRAINT fk_agendamento_exame FOREIGN KEY (id_exame) REFERENCES Exame(id_exame)
);

-- Tabela Resultado
CREATE TABLE Resultado (
    id_resultado INT AUTO_INCREMENT PRIMARY KEY,
    laudo_pdf VARCHAR(255) NOT NULL,
    id_exame INT NOT NULL,
    CONSTRAINT fk_resultado_exame FOREIGN KEY (id_exame) REFERENCES Exame(id_exame)
);
