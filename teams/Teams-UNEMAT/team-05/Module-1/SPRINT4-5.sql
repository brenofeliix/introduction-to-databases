-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Ylma
-- Banco: clinica_Ser

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE clinica_Ser;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- SELECT básico: listar todos os pacientes
SELECT *
FROM paciente;

-- Colunas específicas: nome e CPF dos pacientes
SELECT nome, cpf
FROM paciente;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta com WHERE: exames com preço negativo (erro de cadastro)
SELECT *
FROM exame
WHERE preco < 0;

-- Consulta com duas condições: exames com preço maior que 100 e ativos
SELECT *
FROM exame
WHERE preco > 100
  AND status = 'ATIVO';

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Ordenar exames pelo preço do menor para o maior
SELECT *
FROM exame
ORDER BY preco ASC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- COUNT: quantos pacientes estão cadastrados
SELECT COUNT(*) AS total_pacientes
FROM paciente;

-- SUM: valor total de todos os exames cadastrados
SELECT SUM(preco) AS valor_total_exames
FROM exame;

-- AVG: preço médio dos exames
SELECT AVG(preco) AS preco_medio
FROM exame;

-- MIN / MAX: menor e maior preço de exame
SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM exame;

-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Quantos agendamentos cada paciente possui
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente;

-- ============================================================
-- 6. HAVING
-- ============================================================

-- Pacientes com mais de 3 agendamentos
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente
HAVING COUNT(*) > 3;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- Valor total de cada exame realizado (preço * quantidade)
SELECT id_exame,
       preco,
       quantidade,
       preco * quantidade AS valor_total
FROM exame_realizado;

-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

-- Detectar CPFs duplicados (regra de integridade)
SELECT cpf,
       COUNT(*) AS qtd
FROM paciente
GROUP BY cpf
HAVING COUNT(*) > 1;
USE clinica_medica;
SELECT * FROM paciente;
SELECT * FROM exame;
SELECT * FROM agendamento;
SELECT * FROM resultado;
SELECT nome, preco
FROM exame
WHERE preco > 100;
-- Consulta 01
-- Pergunta:
-- Quais exames possuem preço acima de R$ 100?

SELECT nome, preco
FROM exame
WHERE preco > 100;
SELECT id_paciente, COUNT(*) 
FROM agendamento
WHERE COUNT(*) > 3;
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente
HAVING COUNT(*) > 3;
