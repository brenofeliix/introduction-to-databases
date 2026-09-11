-- ============================================================
-- SPRINT 3/5 - SISTEMA ESCOLAR
-- Pedro Gustavo Macena da Silva
-- Manipulação de Dados com DML
-- ============================================================

USE sistema_escolar;


-- ============================================================
-- CONFERÊNCIA DOS DADOS EXISTENTES
-- ============================================================

SELECT * FROM professor;

SELECT * FROM aluno;

SELECT * FROM turma;

SELECT * FROM disciplina;

SELECT * FROM matricula;


-- ============================================================
-- INSERTS - MATRÍCULA
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
-- CONFERÊNCIA DAS MATRÍCULAS
-- ============================================================

SELECT * FROM matricula;


-- ============================================================
-- UPDATE 1
-- Alterando o telefone de um aluno
-- ============================================================

UPDATE aluno
SET telefone = '65977770001'
WHERE id_aluno = 1;
select*from
aluno
where id_aluno=1;

-- ============================================================
-- UPDATE 2
-- Alterando o e-mail de um professor
-- ============================================================

UPDATE professor
SET email = 'carlos.almeida.novo@escola.com'
WHERE id_professor = 1;


-- ============================================================
-- UPDATE 3
-- Alterando a sala de uma turma
-- ============================================================

UPDATE turma
SET sala = 'Sala 10'
WHERE id_turma = 1;


-- ============================================================
-- VERIFICAÇÃO DOS UPDATES
-- ============================================================

SELECT * FROM aluno
WHERE id_aluno = 1;

SELECT * FROM professor
WHERE id_professor = 1;

SELECT * FROM turma
WHERE id_turma = 1;


-- ============================================================
-- DELETE 1
-- Removendo uma matrícula
-- ============================================================

DELETE FROM matricula
WHERE id_matricula = 4;


-- ============================================================
-- DELETE 2
-- Removendo outra matrícula
-- ============================================================

DELETE FROM matricula
WHERE id_matricula = 5;


-- ============================================================
-- VERIFICAÇÃO DOS DELETES
-- ============================================================

SELECT * FROM matricula;


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM aluno;

SELECT * FROM professor;

SELECT * FROM disciplina;

SELECT * FROM turma;

SELECT * FROM matricula;


-- ============================================================
-- FIM DA SPRINT 3/5
-- ============================================================