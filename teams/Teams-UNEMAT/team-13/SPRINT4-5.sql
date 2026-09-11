-- ============================================================
-- SPRINT 4/5 - SISTEMA ESCOLAR
-- Pedro Gustavo Macena da Silva
-- Consultas SQL e Expressões
-- ============================================================

USE sistema_escolar;


-- ============================================================
-- 1. SELECT BÁSICO
-- Pergunta:
-- Quais são todos os alunos cadastrados no sistema?
-- ============================================================

SELECT *
FROM aluno;


-- ============================================================
-- 2. SELECT COM COLUNAS ESPECÍFICAS
-- Pergunta:
-- Quais são os nomes, matrículas e telefones dos alunos?
-- ============================================================

SELECT nome, matricula, telefone
FROM aluno;


-- ============================================================
-- 3. WHERE
-- Pergunta:
-- Qual é o telefone do aluno de id 1?
-- ============================================================

SELECT nome, telefone
FROM aluno
WHERE id_aluno = 1;


-- ============================================================
-- 4. WHERE COM MAIS DE UMA CONDIÇÃO
-- Pergunta:
-- Quais alunos possuem matrícula cadastrada e telefone?
-- ============================================================

SELECT nome, matricula, telefone
FROM aluno
WHERE matricula IS NOT NULL
  AND telefone IS NOT NULL
ORDER BY nome ASC;


-- ============================================================
-- 5. ORDER BY
-- Pergunta:
-- Quais são os alunos em ordem alfabética?
-- ============================================================

SELECT nome, matricula
FROM aluno
ORDER BY nome ASC;


-- ============================================================
-- 6. COUNT
-- Pergunta:
-- Quantos alunos estão cadastrados no sistema?
-- ============================================================

SELECT COUNT(*) AS total_alunos
FROM aluno;


-- ============================================================
-- 7. SUM
-- Pergunta:
-- Qual é a soma total das cargas horárias das disciplinas?
-- ============================================================

SELECT SUM(carga_horaria) AS carga_horaria_total
FROM disciplina;


-- ============================================================
-- 8. AVG
-- Pergunta:
-- Qual é a carga horária média das disciplinas?
-- ============================================================

SELECT AVG(carga_horaria) AS carga_horaria_media
FROM disciplina;


-- ============================================================
-- 9. MIN E MAX
-- Pergunta:
-- Qual é a menor e a maior carga horária entre as disciplinas?
-- ============================================================

SELECT
    MIN(carga_horaria) AS menor_carga_horaria,
    MAX(carga_horaria) AS maior_carga_horaria
FROM disciplina;


-- ============================================================
-- 10. GROUP BY
-- Pergunta:
-- Quantas turmas existem em cada turno?
-- ============================================================

SELECT
    turno,
    COUNT(*) AS quantidade_turmas
FROM turma
GROUP BY turno;


-- ============================================================
-- 11. HAVING
-- Pergunta:
-- Quais turnos possuem mais de uma turma?
-- ============================================================

SELECT
    turno,
    COUNT(*) AS quantidade_turmas
FROM turma
GROUP BY turno
HAVING COUNT(*) > 1;


-- ============================================================
-- 12. EXPRESSÃO SQL
-- Pergunta:
-- Qual seria a carga horária de cada disciplina acrescida
-- de 10%?
-- ============================================================

SELECT
    nome,
    carga_horaria,
    carga_horaria * 1.10 AS carga_horaria_com_acrescimo
FROM disciplina;


-- ============================================================
-- 13. CONSULTA EXTRA
-- Pergunta:
-- Quais disciplinas possuem carga horária maior que 40 horas?
-- ============================================================

SELECT
    nome,
    carga_horaria
FROM disciplina
WHERE carga_horaria > 40
ORDER BY carga_horaria DESC;


-- ============================================================
-- 14. CONSULTA EXTRA COM AGRUPAMENTO
-- Pergunta:
-- Quantas matrículas existem para cada turma?
-- ============================================================

SELECT
    id_turma,
    COUNT(*) AS quantidade_matriculas
FROM matricula
GROUP BY id_turma
ORDER BY quantidade_matriculas DESC;


-- ============================================================
-- 15. CONSULTA EXTRA
-- Pergunta:
-- Quantas matrículas existem para cada disciplina?
-- ============================================================

SELECT
    id_disciplina,
    COUNT(*) AS quantidade_matriculas
FROM matricula
GROUP BY id_disciplina
ORDER BY quantidade_matriculas DESC;


-- ============================================================
-- FIM DA SPRINT 4/5
-- ============================================================