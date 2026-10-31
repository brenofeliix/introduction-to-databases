-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude

USE secretaria_saude;

-- ============================================================
-- INNER JOIN 1
-- Quais pacientes possuem prontuário e qual o diagnóstico registrado?
-- ============================================================
SELECT p.id_paciente, p.nome AS paciente, pr.diagnostico, pr.data_registro
FROM paciente AS p
INNER JOIN prontuario AS pr ON pr.id_paciente = p.id_paciente;

-- ============================================================
-- INNER JOIN 2
-- Quais itens existem em estoque em cada unidade de saúde?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS item, e.tipo, e.quantidade, e.validade
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade;

-- ============================================================
-- LEFT JOIN
-- Quantos atendimentos cada unidade teve, incluindo unidades sem nenhum?
-- ============================================================
SELECT u.id_unidade, u.nome AS unidade, u.tipo,
       COUNT(a.id_atendimento) AS total_atendimentos
FROM unidade_saude AS u
LEFT JOIN atendimento AS a ON a.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome, u.tipo
ORDER BY total_atendimentos DESC;

-- ============================================================
-- RIGHT JOIN
-- Quais atendimentos ainda não possuem prontuário?
-- ============================================================
SELECT a.id_atendimento, a.data_hora, a.tipo_atendimento, a.status, pr.id_prontuario
FROM prontuario AS pr
RIGHT JOIN atendimento AS a ON a.id_atendimento = pr.id_atendimento
WHERE pr.id_prontuario IS NULL;

-- ============================================================
-- JOIN COM 3+ TABELAS 1 (4 tabelas)
-- Quem atendeu quem, onde e quando?
-- ============================================================
SELECT a.id_atendimento, p.nome AS paciente, pf.nome AS profissional,
       u.nome AS unidade, a.data_hora, a.tipo_atendimento, a.status
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
ORDER BY a.data_hora;

-- ============================================================
-- JOIN COM 3+ TABELAS 2 (5 tabelas)
-- Qual diagnóstico foi registrado, por qual profissional e em qual unidade?
-- ============================================================
SELECT p.nome AS paciente, pr.diagnostico, pf.nome AS profissional,
       pf.setor, u.nome AS unidade
FROM prontuario AS pr
INNER JOIN atendimento   AS a  ON a.id_atendimento   = pr.id_atendimento
INNER JOIN paciente      AS p  ON p.id_paciente      = pr.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade;

-- ============================================================
-- JOIN + WHERE
-- Quais vacinas estão com estoque baixo (< 50) e em qual unidade?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS vacina, e.quantidade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.tipo = 'VACINA' AND e.quantidade < 50;

-- ============================================================
-- JOIN + ORDER BY
-- Quais foram os registros clínicos mais recentes?
-- ============================================================
SELECT pr.data_registro, p.nome AS paciente, pr.diagnostico
FROM prontuario AS pr
INNER JOIN paciente AS p ON p.id_paciente = pr.id_paciente
ORDER BY pr.data_registro DESC;

-- ============================================================
-- JOIN + GROUP BY + AGREGAÇÃO
-- Quantos itens e quantas unidades em estoque cada unidade possui?
-- ============================================================
SELECT u.nome AS unidade,
       COUNT(*)          AS itens_cadastrados,
       SUM(e.quantidade) AS total_unidades_em_estoque,
       MIN(e.validade)   AS validade_mais_proxima
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome
ORDER BY total_unidades_em_estoque DESC;

-- ============================================================
-- CONSULTA MAIS ÚTIL
-- Agenda dos próximos 15 dias para a recepção
-- (data fixa para o resultado ser reproduzível; em uso real, troque por CURDATE())
-- ============================================================
SET @data_ref = '2026-10-27';
SELECT a.data_hora, p.nome AS paciente, p.telefone,
       pf.nome AS profissional, pf.setor, u.nome AS unidade, a.tipo_atendimento
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
WHERE a.status = 'AGENDADO'
  AND a.data_hora >= @data_ref
  AND a.data_hora <  @data_ref + INTERVAL 15 DAY
ORDER BY a.data_hora;