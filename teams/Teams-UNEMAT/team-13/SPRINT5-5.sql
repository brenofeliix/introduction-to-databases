-- ============================================================
-- SPRINT 5/5 - SISTEMA ESCOLAR
-- Pedro Gustavo Macena da Silva
-- Integração, Validação e Entrega Final
-- ============================================================


-- ============================================================
-- 1. IDENTIFICAÇÃO
-- ============================================================

-- Projeto: Sistema Escolar
-- Aluno: Pedro Gustavo Macena da Silva
-- Disciplina: Laboratório de Banco de Dados
-- Sprint: 5 de 5


-- ============================================================
-- 2. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS sistema_escolar;

USE sistema_escolar;


-- ============================================================
-- 3. ESTRUTURA DAS TABELAS
-- ============================================================

CREATE TABLE IF NOT EXISTS aluno (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE
);


CREATE TABLE IF NOT EXISTS professor (
    id_professor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL
);


CREATE TABLE IF NOT EXISTS disciplina (
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


CREATE TABLE IF NOT EXISTS turma (
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    sala VARCHAR(20) NOT NULL
);


CREATE TABLE IF NOT EXISTS matricula (
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
-- 4. CONFERÊNCIA DA ESTRUTURA
-- ============================================================

SHOW TABLES;

DESCRIBE aluno;
DESCRIBE professor;
DESCRIBE disciplina;
DESCRIBE turma;
DESCRIBE matricula;


-- ============================================================
-- 5. SHOW CREATE TABLE
-- ============================================================

SHOW CREATE TABLE aluno;

SHOW CREATE TABLE professor;

SHOW CREATE TABLE disciplina;

SHOW CREATE TABLE turma;

SHOW CREATE TABLE matricula;


-- ============================================================
-- 6. CONFERÊNCIA DOS DADOS
-- ============================================================

SELECT * FROM aluno;

SELECT * FROM professor;

SELECT * FROM disciplina;

SELECT * FROM turma;

SELECT * FROM matricula;


-- ============================================================
-- 7. INSERT - MATRÍCULAS
-- Relaciona ALUNO + TURMA + DISCIPLINA
-- ============================================================

INSERT INTO matricula (id_aluno, id_turma, id_disciplina)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5);


-- ============================================================
-- 8. CONFERÊNCIA DOS INSERTS
-- ============================================================

SELECT *
FROM matricula;


-- ============================================================
-- 9. UPDATE - ALUNO
-- ============================================================

UPDATE aluno
SET telefone = '65977770001'
WHERE id_aluno = 1;


-- ============================================================
-- 10. UPDATE - PROFESSOR
-- ============================================================

UPDATE professor
SET email = 'carlos.almeida.novo@escola.com'
WHERE id_professor = 1;


-- ============================================================
-- 11. UPDATE - TURMA
-- ============================================================

UPDATE turma
SET sala = 'Sala 10'
WHERE id_turma = 1;


-- ============================================================
-- 12. CONFERÊNCIA DOS UPDATES
-- ============================================================

SELECT *
FROM aluno
WHERE id_aluno = 1;

SELECT *
FROM professor
WHERE id_professor = 1;

SELECT *
FROM turma
WHERE id_turma = 1;


-- ============================================================
-- 13. DELETE - MATRÍCULA
-- ============================================================

DELETE FROM matricula
WHERE id_matricula = 4;


DELETE FROM matricula
WHERE id_matricula = 5;


-- ============================================================
-- 14. CONFERÊNCIA DOS DELETES
-- ============================================================

SELECT *
FROM matricula;


-- ============================================================
-- 15. SELECT BÁSICO
-- ============================================================

SELECT *
FROM aluno;


-- ============================================================
-- 16. SELECT COM COLUNAS ESPECÍFICAS
-- ============================================================

SELECT nome, matricula, telefone
FROM aluno;


-- ============================================================
-- 17. WHERE
-- ============================================================

SELECT nome, telefone
FROM aluno
WHERE id_aluno = 1;


-- ============================================================
-- 18. WHERE COM MAIS DE UMA CONDIÇÃO
-- ============================================================

SELECT nome, matricula, telefone
FROM aluno
WHERE matricula IS NOT NULL
  AND telefone IS NOT NULL
ORDER BY nome ASC;


-- ============================================================
-- 19. ORDER BY
-- ============================================================

SELECT nome, matricula
FROM aluno
ORDER BY nome ASC;


-- ============================================================
-- 20. COUNT
-- ============================================================

SELECT COUNT(*) AS total_alunos
FROM aluno;


-- ============================================================
-- 21. SUM
-- ============================================================

SELECT SUM(carga_horaria) AS carga_horaria_total
FROM disciplina;


-- ============================================================
-- 22. AVG
-- ============================================================

SELECT AVG(carga_horaria) AS carga_horaria_media
FROM disciplina;


-- ============================================================
-- 23. MIN E MAX
-- ============================================================

SELECT
    MIN(carga_horaria) AS menor_carga_horaria,
    MAX(carga_horaria) AS maior_carga_horaria
FROM disciplina;


-- ============================================================
-- 24. GROUP BY
-- ============================================================

SELECT
    turno,
    COUNT(*) AS quantidade_turmas
FROM turma
GROUP BY turno;


-- ============================================================
-- 25. HAVING
-- ============================================================

SELECT
    turno,
    COUNT(*) AS quantidade_turmas
FROM turma
GROUP BY turno
HAVING COUNT(*) > 1;


-- ============================================================
-- 26. EXPRESSÃO SQL
-- ============================================================

SELECT
    nome,
    carga_horaria,
    carga_horaria * 1.10 AS carga_horaria_com_acrescimo
FROM disciplina;


-- ============================================================
-- 27. CONSULTA EXTRA
-- Disciplinas com mais de 40 horas
-- ============================================================

SELECT
    nome,
    carga_horaria
FROM disciplina
WHERE carga_horaria > 40
ORDER BY carga_horaria DESC;


-- ============================================================
-- 28. CONSULTA EXTRA
-- Quantidade de matrículas por turma
-- ============================================================

SELECT
    id_turma,
    COUNT(*) AS quantidade_matriculas
FROM matricula
GROUP BY id_turma
ORDER BY quantidade_matriculas DESC;


-- ============================================================
-- 29. CONSULTA EXTRA
-- Quantidade de matrículas por disciplina
-- ============================================================

SELECT
    id_disciplina,
    COUNT(*) AS quantidade_matriculas
FROM matricula
GROUP BY id_disciplina
ORDER BY quantidade_matriculas DESC;


-- ============================================================
-- 30. VALIDAÇÃO DA INTEGRIDADE REFERENCIAL
-- ============================================================

SELECT
    m.id_matricula,
    a.nome AS aluno,
    t.nome AS turma,
    d.nome AS disciplina
FROM matricula m
INNER JOIN aluno a
    ON m.id_aluno = a.id_aluno
INNER JOIN turma t
    ON m.id_turma = t.id_turma
INNER JOIN disciplina d
    ON m.id_disciplina = d.id_disciplina;


-- ============================================================
-- 31. VALIDAÇÃO DOS PROFESSORES E DISCIPLINAS
-- ============================================================

SELECT
    d.id_disciplina,
    d.nome AS disciplina,
    p.nome AS professor
FROM disciplina d
INNER JOIN professor p
    ON d.id_professor = p.id_professor;


-- ============================================================
-- 32. VALIDAÇÃO DE CHAVES E RESTRIÇÕES
-- ============================================================

SHOW CREATE TABLE aluno;

SHOW CREATE TABLE professor;

SHOW CREATE TABLE disciplina;

SHOW CREATE TABLE turma;

SHOW CREATE TABLE matricula;


-- ============================================================
-- 33. VALIDAÇÃO FINAL DOS REGISTROS
-- ============================================================

SELECT COUNT(*) AS total_alunos
FROM aluno;

SELECT COUNT(*) AS total_professores
FROM professor;

SELECT COUNT(*) AS total_disciplinas
FROM disciplina;

SELECT COUNT(*) AS total_turmas
FROM turma;

SELECT COUNT(*) AS total_matriculas
FROM matricula;


-- ============================================================
-- 34. CONSULTA FINAL MAIS IMPORTANTE
-- Mostra as matrículas com aluno, turma e disciplina
-- ============================================================

SELECT
    m.id_matricula,
    a.nome AS aluno,
    t.nome AS turma,
    d.nome AS disciplina
FROM matricula m
INNER JOIN aluno a
    ON m.id_aluno = a.id_aluno
INNER JOIN turma t
    ON m.id_turma = t.id_turma
INNER JOIN disciplina d
    ON m.id_disciplina = d.id_disciplina
ORDER BY a.nome ASC;


-- ============================================================
-- 35. CONSULTA FINAL MAIS COMPLETA
-- Alunos, turmas, disciplinas e professores
-- ============================================================

SELECT
    a.nome AS aluno,
    t.nome AS turma,
    d.nome AS disciplina,
    p.nome AS professor,
    d.carga_horaria
FROM matricula m
INNER JOIN aluno a
    ON m.id_aluno = a.id_aluno
INNER JOIN turma t
    ON m.id_turma = t.id_turma
INNER JOIN disciplina d
    ON m.id_disciplina = d.id_disciplina
INNER JOIN professor p
    ON d.id_professor = p.id_professor
ORDER BY a.nome ASC;


-- ============================================================
-- 36. VALIDAÇÃO FINAL DAS TABELAS
-- ============================================================

SHOW TABLES;


-- ============================================================
-- FIM DA SPRINT 5/5
-- SISTEMA ESCOLAR
-- ============================================================