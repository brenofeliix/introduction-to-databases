-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Ylma
-- Tema: Clínica de Exames Radiológicos
-- Banco: Clinica-Ser


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE Clinica_Ser;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE Clinica_Ser;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

CREATE TABLE Convenio (
    id_convenio INT PRIMARY KEY AUTO_INCREMENT,
    nome_convenio VARCHAR(100) NOT NULL,
    tipo_plano VARCHAR(50),
    cobertura TEXT
);

CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(150),
    id_convenio INT,
    FOREIGN KEY (id_convenio) REFERENCES Convenio(id_convenio)
);

CREATE TABLE Medico (
    id_medico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cro VARCHAR(20) UNIQUE NOT NULL,
    especialidade VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE Exame (
    id_exame INT PRIMARY KEY AUTO_INCREMENT,
    tipo_exame VARCHAR(50) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0)
);

CREATE TABLE Agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_exame INT NOT NULL,
    id_medico INT NOT NULL,
    data_hora DATETIME NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_exame) REFERENCES Exame(id_exame),
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);

CREATE TABLE Resultado (
    id_resultado INT PRIMARY KEY AUTO_INCREMENT,
    id_exame INT NOT NULL,
    laudo_texto TEXT NOT NULL,
    imagem_url VARCHAR(200),
    data_emissao DATE NOT NULL,
    FOREIGN KEY (id_exame) REFERENCES Exame(id_exame)
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================

-- PRIMARY KEY: id_paciente, id_medico, id_exame, id_agendamento, id_resultado, id_convenio
-- FOREIGN KEY: Paciente → Convenio, Agendamento → Paciente/Exame/Médico, Resultado → Exame
-- UNIQUE: cpf em Paciente, crm em Medico
-- NOT NULL: campos essenciais como nome, cpf, data_nascimento, preco, data_hora
-- AUTO_INCREMENT: todas as PKs


-- ============================================================
-- 5. INSERTS
-- ============================================================

INSERT INTO Convenio (nome_convenio, tipo_plano, cobertura)
VALUES ('Unimed', 'Ouro', 'Cobertura completa');

INSERT INTO Paciente (nome, cpf, data_nascimento, telefone, endereco, id_convenio)
VALUES ('Maria Silva', '12345678901', '1985-06-15', '66 99999-1111', 'Rua A, 123', 1);

INSERT INTO Medico (nome, crm, especialidade, telefone)
VALUES ('Dr. João Pereira', 'CRO12345', 'Radiologia', '66 98888-2222');

INSERT INTO Exame (tipo_exame, descricao, preco)
VALUES ('Raio-X', 'Raio-X panoramico', 130.00);

INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora)
VALUES (1, 1, 1, '2026-09-20 10:00:00');

INSERT INTO Resultado (id_exame, laudo_texto, imagem_url, data_emissao)
VALUES (1, 'Sem alterações significativas', 'imagem1.jpg', '2026-09-20');


-- ============================================================
-- 6. UPDATES
-- ============================================================

UPDATE Paciente
SET telefone = '66 99999-3333'
WHERE id_paciente = 1;


-- ============================================================
-- 7. DELETES
-- ============================================================

DELETE FROM Agendamento
WHERE id_agendamento = 1;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

SELECT * FROM Paciente;


-- ============================================================
-- 9. WHERE
-- ============================================================

SELECT * FROM Exame
WHERE preco > 200;


-- ============================================================
-- 10. ORDER BY
-- ============================================================

SELECT * FROM Agendamento
ORDER BY data_hora DESC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

SELECT AVG(preco) AS preco_medio
FROM Exame;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

SELECT c.nome_convenio, COUNT(p.id_paciente) AS total_pacientes
FROM Paciente p
JOIN Convenio c ON p.id_convenio = c.id_convenio
GROUP BY c.nome_convenio;


-- ============================================================
-- 13. HAVING
-- ============================================================

SELECT c.nome_convenio, COUNT(p.id_paciente) AS total_pacientes
FROM Paciente p
JOIN Convenio c ON p.id_convenio = c.id_convenio
GROUP BY c.nome_convenio
HAVING COUNT(p.id_paciente) > 10;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

SELECT nome, YEAR(CURDATE()) - YEAR(data_nascimento) AS idade
FROM Paciente;

